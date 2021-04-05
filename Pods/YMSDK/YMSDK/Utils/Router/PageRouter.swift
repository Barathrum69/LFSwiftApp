//
//  PageRouter.swift
//  ymsports
//
//  Created by wood on 21/1/21.
//

import UIKit

/// 路由事件协议
public protocol EventProtocol {
    /// 获取事件中文名称，用来数据统计
    func name() -> String
    /// 把通用协议翻译成PageEvent事件 -> login(name, pwd)
//    static func getEvent<T>(host: String) -> PageEvent<T>
}

/// 页面标识事件，创建一个pageEvent即可触发页面路由器转跳子页面
///
/// - webView: 用Service WebWiew打开(url)
/// - setting: 设置(首页的设置，无需登录)
/// - errorPage: 默认错误页面
/// - browser: 用Safari打开(url)
/// - none: 不做调转
/// - login: 登录(未登录状态)
/// - register: 注册(未登录状态)
/// - mailto: 发邮件(邮箱)
/// - showToast: toast提示(msg)
/// - showDialog: 弹框标题(title, content)
/// - closeWeb: 关闭webview
/// - generic: 外部类型，自己定义并实现跳转
public enum PageEvent<T>: EventProtocol {
    /// 外部类型，自己定义并实现跳转
    case generic(T)
    /// webView: 用Service WebWiew打开(url)
    case webView(title: String?, url: String)
    /// setting: 设置(首页的设置，无需登录)
    case setting
    /// errorPage: 默认错误页面
    case errorPage
    /// browser: 用Safari打开(url)
    case browser(url: String)
    /// none: 不做调转
    case none
    /// login: 登录(未登录状态)
    case login
    /// register: 注册(未登录状态)
    case register
    /// mailto: 发邮件(邮箱)
    case mailto(email: String)
    /// showToast: toast提示(msg)
    case showToast(msg: String)
    /// showDialog: 弹框标题(title, content)
    case showDialog(title: String, msg: String)
    /// exception: 无效参数导致异常
    case exception(info: [String: String])
    /// closeWeb: 关闭webview
    case closeWeb

    /// 获取事件中文名称，用来数据统计
    public func name() -> String {
        switch self {
        case let .webView(title, url):
            return "WebView-\(title ?? "")-\(url)"
        case .setting:
            return "首页设置"
        case .errorPage:
            return "错误页面"
        case .browser(let url):
            return "Safari-\(url)"
        case .none:
            return ""
        case .login:
            return "登录"
        case .register:
            return "注册"
        case .mailto:
            return "发邮件"
        case .showToast:
            return "toast提示"
        case .showDialog:
            return "弹框标题"
        case .exception:
            return "exception"
        case .closeWeb:
            return "关闭webview"
        case .generic(let name):
            return "\(name)"
        }
    }

    /// 根据host解析PageEvent
    ///
    /// - Parameter host: 拼接的路由字符串
    static func getEvent(host: String) -> PageEvent {
        var prefix = host
        var arguments: [String] = []
        if let index = host.firstIndex(of: "(") {
            arguments = host.suffix(from: index).dropFirst().dropLast().split(separator: ",")
                .compactMap({ String($0).replacing(regex: "%2c", with: ",").trim() })
            prefix = String(host.prefix(upTo: index))
        }

        let exceptionInfo = ["Category": "跳转事件", "Label": "事件类型:\(prefix) 参数:\(arguments)"]
        XLog("\(host), \(prefix), \(arguments)")

        switch prefix {
        case "webView":
            if let urlString = arguments.first, urlString.isValidURL() {
                return .webView(title: "", url: urlString)
            }
            return .exception(info: exceptionInfo)
        case "setting":
            return .setting
        case "browser":
            if let urlString = arguments.first, urlString.isValidURL() {
                return .browser(url: urlString)
            }
            return .exception(info: exceptionInfo)
        case "login":
            return .login
        case "register":
            return .register
        case "mailto":
            if let email = arguments.first {
                return .mailto(email: email)
            }
            return .exception(info: exceptionInfo)
        case "showToast":
            if let msg = arguments.first, !msg.isEmpty {
                return .showToast(msg: msg)
            }
            return .exception(info: exceptionInfo)
        case "showDialog":
            if arguments.count >= 2 {
                return .showDialog(title: arguments[0], msg: arguments[1])
            }
            return .exception(info: exceptionInfo)
        default:
            return .none
        }
    }
}

/// 页面路由转跳
public class PageRouter {
    /// 根据event转跳至具体的页面
    ///
    /// - Parameter event: PageEvent页面标识
    public class func route(_ event: PageEvent<String>) {
        // PageRouter是页面跳转，如果首页还没加载完，跳转就么意义，app启动了再跳转，在这之前的跳转都取消掉
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
//              appDelegate.window?.rootViewController is UITabBarController else {
//            return
//        }
        guard let top = UIApplication.topViewController else { return }
        switch event {
        case .none:
            break
        case let .webView(title, url):
            // TODO: webView
            XLog("webView(\(title ?? ""),\(url)")
        case .setting:
            // TODO: 设置
            XLog("setting")
        case .errorPage:
            top.present(BaseNavController(rootViewController: ErrorPageViewController()), animated: true, completion: nil)
        case .browser(let url):
            if let url = URL(string: url.URLString()) {
                UIApplication.shared.open(url)
            }
        case .login:
            // TODO: 登录
            XLog("login")
        case .register:
            // TODO: 注册
            XLog("register")
        case .mailto(let email):
            // appnative://event?type=mailto&param0="+encodeURIComponent("business@kok.com,care@kok.com?subject=邮件主题&body=邮件内容"
            if let str = email.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                let url = URL(string: "mailto:" + str) {
                UIApplication.shared.open(url)
            }
        case .showToast(let msg):
            ToastUtil.showMessage(msg, inView: top.view)
        case let .showDialog(title, msg):
            PopAlertView.showTipAlert(obj: PopAlertObj(title: title, subtitle: msg, cancelText: nil, confirmText: nil, block: {}))
        case .exception(let info):
            // TODO: 统计错误事件
            XLog("跳转异常\(info)")
        case .closeWeb:
            top.navigationController?.popViewController(animated: true)
        let preName = top.title ?? "主页面"
            // TODO: 统计
            XLog("统计\(preName)")
        case .generic(let name):
            XLog("generic(\(name))")
        }
    }
}

/// Demo for Router
// class MyRouter: PageRouter {
//    override class func route(_ event: PageEvent<String>) {
//        if case .generic(let name) = event {
//            XLog("generic(\(name))")
//            // event?type=mailto
//            // 实现跳转
//        } else {
//            super.route(event)
//        }
//    }
//
//    func test() {
//        // 调用内建路由
//        PageRouter.route(.closeWeb)
//        // 调用子模块路由
//        PageRouter.route(.generic("event?type=mailto"))
//    }
// }
