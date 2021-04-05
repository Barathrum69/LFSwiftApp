//
//  WebNativeActionPolicy.swift
//  ymsports
//
//  Created by wood on 21/1/21.
//

import UIKit

/// h5-native schema：nativePrefix = "ymsdknative://"
/// 参数：["param0", "param1", "param2", "param3", "param4", "param5", "param6", "param7", "param8", "param9"]
/// 协议：ymsdknative://event?type=xxx&WtagA=xxx&WtagQ=xxx&Ntag=xxx&param0=xxx&param1=xxx...
/// 如跳转包裹支付协议为：ymsdknative://event?type=pay&param0=invoiceId&param1=0
public class WebNativeActionPolicy: NSObject {
    static let nativePrefix = "ymsdknative://"
    static let paramsKeyArray = [
        "param0", "param1", "param2", "param3", "param4", "param5", "param6", "param7", "param8", "param9"
    ]

    /// h5跳转事件拦截
    ///
    /// - Parameter host: URL
    /// - Returns: true：表示事件被拦截，不用再处理
    public class func actionPolicy(host: String) -> Bool {
        /**
         协议：ymsdknative://event?type=xxx&WtagA=xxx&WtagQ=xxx&Ntag=xxx&param0=xxx&param1=xxx...
         如跳转包裹支付协议为：ymsdknative://event?type=pay&param0=invoiceId&param1=0
         */
        if let range = host.range(of: nativePrefix) { // 新协议
            // 获取参数
            let params = String(host.suffix(from: range.upperBound)).trim().getURLParams()
            let valueArray = paramsKeyArray.compactMap({ params[$0] }).compactMap({ $0.removingPercentEncoding })
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
                return true
            }
        }

        return false
    }
}
