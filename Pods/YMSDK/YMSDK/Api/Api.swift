//
//  Api.swift
//  ymsports
//
//  Created by wood on 25/1/21.
//

import Alamofire
import CommonCrypto
import CoreTelephony
import Foundation
import HandyJSON

/// 通过泛型转模型统一输出，兼容多版本API
public class ApiModel<T: HandyJSON>: HandyJSON {
    /// 状态码
    public var state: Int = 0

    /// 错误信息
    public var msg: String = ""

    /// 返回原始数据
    public var data: Any?

    /// 返回转模型后的对象
    public var object: T?

    /// 返回转模型后的对象数组
    public var array: [T]?

    /// 是否成功请求到数据
    public var isSuccess: Bool { return self.state == Api.kSuccess }

    public required init() { }

    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            state <-- "code"
        mapper <<<
            msg <-- "message"
        mapper <<<
            data <-- "data"
    }

    init(error: Api.Error) {
        state = error.rawValue
        switch error {
        case .noNetwork:
            msg = "error_network".sdkLocalized()
        case .timeout:
            msg = "error_request_timeout".sdkLocalized()
        default:
            msg = "error_server_error".sdkLocalized()
        }
    }
}

/// Api接口层，提供不同的接口服务
public class Api {
    /// 请求失败错误类型
    ///
    /// - noNetwork: 无网络
    /// - timeout: 请求超时
    /// - dataError: 解析数据失败
    /// - serverError: 服务器错误，responseCode != 200
    enum Error: Int {
        case noNetwork = -1
        case timeout
        case dataError
        case serverError
    }

    /// 请求时是否显示loading
    ///
    /// - none: 不显示（默认选项）
    /// - selfView: 显示在当前控制器view上，loading不会全屏覆盖（推荐）
    /// - keyWindow: 顶级window上，如果请求事件过长用户无法操作（不建议）
    /// - some(View): 在指定的view中显示loading
    public enum Loading<View> {
        /// 不显示（默认选项）
        case none
        /// 显示在当前控制器view上，loading不会全屏覆盖（推荐）
        case selfView
        /// 顶级window上，如果请求事件过长用户无法操作（不建议）
        case keyWindow
        /// 在指定的view中显示loading
        case some(View)
    }

    /// 接口成功码
    public static let kSuccess: Int = 0
    public static let apiVersion = "1.0.0"

    static let acceptableContentTypes = ["application/json", "text/json", "text/plain"] // text/plain用来支持Charles Local Map

    static let `default`: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.HTTPHeaders.default.dictionary
        configuration.timeoutIntervalForRequest = 25
        var serverTrustPolicies: [String: ServerTrustEvaluating] = [:]
        /**
         SSL安全认证：与服务器建立安全连接需要对服务器进行验证，可以用证书或者公钥私钥来实现
         该网络框架支持的证书类型：[".cer", ".CER", ".crt", ".CRT", ".der", ".DER"]
         1、DefaultTrustEvaluator 默认策略
         2、SSL Pinning阻止中间人Charles攻击
            - PinnedCertificatesTrustEvaluator 内置证书，将证书放入app的bundle里
            - PublicKeysTrustEvaluator 内置公钥，将证书的公钥硬编码进代码里
         3、DisabledEvaluator 不验证
         然并卵 - 我们公司的网络连接并没有SSL安全认证，强烈吐槽
         */
        // TODO:认证不通过，暂时去掉
//        ["api.xxx.com"].compactMap{ HttpDnsService.sharedInstance()?.getIpByHostAsync($0) }.forEach{ serverTrustPolicies[$0] = DisabledEvaluator() }
//        return Alamofire.Session(configuration: configuration, serverTrustManager: ServerTrustManager(evaluators: serverTrustPolicies))
        return Alamofire.Session(configuration: configuration)
    }()

    /// 通用网络请求
    ///
    /// - Parameters:
    ///   - urlRequest: 自定义请求对象
    ///   - loading: 是否显示loading
    ///   - completionHandler: 完成回调
    /// - Returns: DataRequest
//    @discardableResult
//    class func request(_ urlRequest: URLRequestConvertible, completionHandler: @escaping(_ result: ApiInfo) -> Void) -> DataRequest? {
//        if !(NetworkReachabilityManager()?.isReachable ?? false) {
//            UIApplication.shared.keyWindow?.showMsg("error_network".localized())
//            return nil
//        }
//        return Api.default.request(urlRequest).validate(statusCode: [200]).validate(contentType: acceptableContentTypes).responseJSON { (response) in
//            switch response.result {
//            case .success(let value):
//                XLog("✌️✌️\(String(describing: response.metrics)) \(String(describing: urlRequest.urlRequest)) \(value)")
//                if let parsedObject = Mapper<ApiInfo>(context: nil, shouldIncludeNilValues: false).map(JSONObject: value) {
//                    // 登录状态异常
//                    DispatchQueue.main.async { completionHandler(parsedObject) }
//                } else {
//                    DispatchQueue.main.async { completionHandler(self.errorInfo()) }
//                }
//            case .failure(let error):
//                XLog("😂😂\(String(describing: response.metrics)) \(String(describing: urlRequest.urlRequest)) \(error.localizedDescription)")
//                if (error as NSError).code == NSURLErrorTimedOut {
//                    completionHandler(self.errorInfo(.timeout))
//                } else {
//                    completionHandler(self.errorInfo())
//                }
//            }
//        }
//
//    }

    /// 带模型转换的网络请求，模型是对象Object
    ///
    /// - Parameters:
    ///   - urlRequest: 自定义请求对象
    ///   - keyPath: 对象路径keyPath，是从data后面key开始算起的
    ///   - loading: 是否显示loading
    ///   - completionHandler: 完成回调
    /// - Returns: DataRequest，无网络时不执行请求返回nil
    @discardableResult
    public class func request<T: HandyJSON>(_ urlRequest: URLRequestConvertible,
                                            keyPath: String? = nil,
                                            loading: Loading<UIView> = .none,
                                            completionHandler: @escaping(_ result: ApiModel<T>) -> Void) -> DataRequest? {
        if let isReachable = NetworkReachabilityManager()?.isReachable, !isReachable {
            if let keyWindow = UIApplication.shared.keyWindow {
                ToastUtil.showMessage("error_network".sdkLocalized(), inView: keyWindow)
            }
            return nil
        }
        var loadingView: UIView?
        DispatchQueue.main.async {
            switch loading {
            case .keyWindow:
                loadingView = UIApplication.shared.keyWindow
            case .selfView:
                loadingView = UIApplication.topViewController?.view
            case .some(let view):
            loadingView = view
            default:
                break
            }
            if let loadingView = loadingView {
                ToastUtil.showLoading(in: loadingView)
            }
        }
        return Api.default.request(urlRequest).validate(statusCode: [200]).validate(contentType: acceptableContentTypes).responseJSON { response in
            switch response.result {
            case .success(let value):
                XLog("😂😂\(String(describing: response.metrics)) \(String(describing: urlRequest.urlRequest)) \(value)")
                if let value = value as? [String: Any], let result = ApiModel<T>.deserialize(
                    from: (value.keys.contains("data") ? value : ["code": 0, "msg": "success", "data": value])) {
                    let path = keyPath?.isEmpty ?? true ? "data" : keyPath
                    result.object = T.deserialize(from: value, designatedPath: path)
                    if result.object == nil, let data = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted),
                       let string = String(data: data, encoding: .utf8) {
                        result.array = [T].deserialize(from: string, designatedPath: path)?.compactMap({ $0 })
                    }
                    DispatchQueue.main.async { completionHandler(result) }
                } else {
                    DispatchQueue.main.async { completionHandler(ApiModel<T>(error: .dataError)) }
                }
            case .failure(let error):
                XLog("😞😞\(String(describing: response.metrics)) \(String(describing: urlRequest.urlRequest)) \(error.localizedDescription)")
                if (error as NSError).code == NSURLErrorTimedOut {
                    DispatchQueue.main.async { completionHandler(ApiModel<T>(error: .timeout)) }
                } else {
                    DispatchQueue.main.async { completionHandler(ApiModel<T>(error: .serverError)) }
                }
            }
            DispatchQueue.main.async {
                if let loadingView = loadingView {
                    ToastUtil.showLoading(in: loadingView)
                }
            }
        }
    }
}

// MARK: - Api Header
public extension Api {
    /// 根据不同的API版本获取请求头
    ///
    /// - Parameter encrypt: API加密方式，默认 V3
    /// - Returns: 请求头
    class func HTTPHeaderFields() -> [String: Any] {
        /**
         请求头：appSecret就是那个第三方的appKey
         请求头: client就是PC(0),
           ANDROID(1),
           IOS(2),
           WEB(3)的具体数字
         请求头:accessType就是HTTP(0),
           WEBSOCKET(1),
           TCP(2)的具体数字
         */

        return [
            "userId": "",
            "language": "en",
            "client": 2,
            "platform": "iOS",
            "accessType": 0,
            "appVersion": AppConfig.appVersion,
            "systemName": UIDevice.current.systemName,
            "time": Int(Date().timeIntervalSince1970),
            "appCode": Constants.chatAppId,
            "idfv": UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
    }
}
