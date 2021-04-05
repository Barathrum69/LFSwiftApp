//
//  HomeApi.swift
//  ymsports
//
//  Created by wood on 25/1/21.
//

import Alamofire
import Foundation
import YMSDK

/// 首页相关接口
///
/// - gameInfo: 获取game信息
enum HomeApi: URLRequestConvertible {
    /// 获取game信息 https://xj-mbs-yb5.2r9qgy.com/zh-cn/Service/CentralService?GetData&ts=1614402480400
    case gameInfo(params: [String: Any])

    static var baseURLString: String { URLConfig.game }

    var method: Alamofire.HTTPMethod {
        switch self {
        default:
            return .post
        }
    }

    var path: String {
        switch self {
        case .gameInfo:
            return "zh-cn/Service/CentralService?GetData&ts=1614402480400"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try (HomeApi.baseURLString + path).asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .gameInfo(let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        }

        let headers: [String: Any] = [
            "Accept-Encoding": "gzip, deflate, br",
            "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
            "Origin": "https://xj-mbs-yb5.2r9qgy.com",
            "Referer": "https://xj-mbs-yb5.2r9qgy.com/m/zh-cn/sports/?sc=ABIAJJ&theme=YB5",
            "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
            "Cookie": "ASP.NET_SessionId=42cz254rneerd2mwc2eoiaqf; sbmwl3-yb4=1829900042.20480.0000; redirect=done; lobbyUrl=localhost; logoutUrl=localhost; historyUrl=%2Fm%2Fzh-cn%2Fsports%3Ftheme%3DYB5%26sni%3Dm052lcmlxu4r4gp4fagnsoak; settingProfile=OddsType=1&NoOfLinePerEvent=1&SortBy=1&AutoRefreshBetslip=True; BS@Cookies=; fav3=; favByBetType=; fav-com=; CCDefaultTvPlay=; CCDefaultBgPlay=; timeZone=480; opCode=YB5; mc=",
            "sec-fetch-site": "same-origin",
            "sec-fetch-mode": "cors",
            "sec-fetch-dest": "empty"
        ]
        headers.forEach { urlRequest.setValue("\($0.value)", forHTTPHeaderField: $0.key) }

//        Api.HTTPHeaderFields().forEach { urlRequest.setValue("\($0.value)", forHTTPHeaderField: $0.key) }

        return urlRequest
    }
}
