//
//  UserApi.swift
//  ymsports
//
//  Created by wood on 25/1/21.
//

import Alamofire
import Foundation

/// 用户相关接口
///
/// - login: 登录
/// - verifyCode: 获取短信验证码
/// - updateUserInfo: 更新用户信息
public enum UserApi: URLRequestConvertible {
    /// 登录
    case login(name: String, code: String)
    /// 获取短信验证码
    case verifyCode(phone: String)
    /// 更新用户信息
    case updateUserInfo(userId: String, nickName: String, avatarBase64: String)

    public static var baseURLString: String { URLConfig.user }

    public var method: Alamofire.HTTPMethod {
        switch self {
        case .verifyCode:
            return .get
        default:
            return .post
        }
    }

    public var path: String {
        switch self {
        case .login:
            return "user/registerAndLogin"
        case .verifyCode:
            return "user/getValidCode"
        case .updateUserInfo:
            return "user/updateUserInfo"
        }
    }

    public func asURLRequest() throws -> URLRequest {
        let url = try UserApi.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case let .login(name, code):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["loginName": name, "validCode": code])
        case .verifyCode(let phone):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["phoneNumber": phone])
        case let .updateUserInfo(userId, nickName, avatarBase64):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["userId": userId, "nickname": nickName, "headPicBase64": avatarBase64])
        }

        Api.HTTPHeaderFields().forEach { urlRequest.setValue("\($0.value)", forHTTPHeaderField: $0.key) }

        return urlRequest
    }
}
