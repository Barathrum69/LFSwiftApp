//
//  OuterNotifyCenter.swift
//  ymsports
//
//  Created by wood on 21/1/21.
//

import Foundation

/// 外部唤起schema：prefix = "ymsdk://"
/// 参数：["param0", "param1", "param2", "param3", "param4", "param5", "param6", "param7", "param8", "param9"]
/// 协议：ymsdk://event?type=xxx&WtagA=xxx&WtagQ=xxx&Ntag=xxx&param0=xxx&param1=xxx...
/// 如跳转包裹支付协议为：ymsdk://event?type=pay&param0=invoiceId&param1=0
public class OuterNotifyCenter: NSObject {
    static let prefix = "event?"

    public class func notify(_ host: String) {
        if let range = host.range(of: prefix) {
            // 获取参数
            let params = String(host.suffix(from: range.lowerBound)).trim().getURLParams()
            let valueArray = WebNativeActionPolicy.paramsKeyArray
                .compactMap({ params[$0] })
                .compactMap({ $0.removingPercentEncoding })
            // 获取事件类型
            if let type = params["type"] {
                let routeString: String
                if valueArray.isEmpty {
                    routeString = type
                } else {
                    routeString = String(format: "%@(%@)", type, valueArray
                                            .compactMap({ $0.replacing(regex: ",", with: "%2c") }).joined(separator: ","))
                }

                let event = PageEvent<String>.getEvent(host: routeString)
                PageRouter.route(event)
            }
        } else {
            let event = PageEvent<String>.getEvent(host: host)
            PageRouter.route(event)
        }
    }
}
