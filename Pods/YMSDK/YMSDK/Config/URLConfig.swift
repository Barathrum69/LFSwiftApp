//
//  URLConfig.swift
//  ymsports
//
//  Created by wood on 25/1/21.
//

import Foundation

/// URL Host 项目请求地址配置
public struct URLConfig {
    /// user api
    public static var user: String {
        switch AppConfig.state {
        case .debug:
            return "http://web.txsp20.tv/"
        default:
            return "http://web.txsp20.tv/"
        }
    }

    /// Game api
    public static var game: String {
        switch AppConfig.state {
        case .debug:
            return "https://xj-mbs-yb5.2r9qgy.com/"
        default:
            return "https://xj-mbs-yb5.2r9qgy.com/"
        }
    }
}
