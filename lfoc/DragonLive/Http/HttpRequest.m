//
//  HttpRequest.m
//  BallSaintSport
//
//  Created by 11号 on 2020/11/4.
//

#import "HttpRequest.h"
#import "AFNetworking.h"
#import "UploadParam.h"
#import "EasyTextView.h"

@implementation HttpRequest

static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                {
                    // 位置网络
                    NSLog(@"位置网络");
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    // 无法联网
                    NSLog(@"无法联网");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    // 手机自带网络
                    NSLog(@"当前使用的是2G/3G/4G网络");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    // WIFI
                    NSLog(@"当前在WIFI网络下");
                }
            }
        }];
    });
    return _instance;
}

//#pragma mark -- GET请求 --
//+ (void)getWithURLString:(NSString *)URLString
//              parameters:(id)parameters
//                 success:(void (^)(id))success
//                 failure:(void (^)(NSError *))failure {
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    /**
//     *  可以接受的类型
//     */
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    /**
//     *  请求队列的最大并发数
//     */
////    manager.operationQueue.maxConcurrentOperationCount = 5;
//    /**
//     *  请求超时的时间
//     */
//    manager.requestSerializer.timeoutInterval = 30;
//    [manager GET:URLString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {
//            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:1 error:nil];
//            success(resultDic);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//}
//
//#pragma mark -- POST请求 --
//+ (void)postWithURLString:(NSString *)URLString
//               parameters:(id)parameters
//                  success:(void (^)(id))success
//                  failure:(void (^)(NSError *))failure {
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    [manager POST:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {
//            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:1 error:nil];
//            success(resultDic);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//}

//自动拼接字典参数
+ (NSString *)getUrlParamStr:(NSDictionary *)paramDic
{
    NSMutableString *mStr = [NSMutableString string];
    NSArray *valueArr = [paramDic allValues];
    NSArray *keyArr = [paramDic allKeys];
    for (NSInteger i=0; i<valueArr.count; i++) {
        NSString *value = [valueArr objectAtIndex:i];
        NSString *key = [keyArr objectAtIndex:i];
        NSString *str;
        if (i==0) {
            str = [NSString stringWithFormat:@"?%@=%@",key,value];
        }else {
            str = [NSString stringWithFormat:@"&%@=%@",key,value];
        }
        [mStr appendString:str];
    }
    return mStr;
}

#pragma mark -- POST/GET网络请求 --
+ (void)requestWithURLType:(UrlType)urlType
                  parameters:(nullable id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if ([[UserInstance shareInstance]isLogin]) {
        [manager.requestSerializer setValue:[UserInstance shareInstance].userId forHTTPHeaderField:@"x-uid"];
    }

    [manager.requestSerializer setValue:[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"x-version"];
    [manager.requestSerializer setValue:@"4" forHTTPHeaderField:@"x-client"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"x-source"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.operationQueue.maxConcurrentOperationCount = 5;
    //忽略
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSString *urlStr = [HttpUrl getRquestUrl:urlType];
//    NSLog(@"发生请求的网址：%@",urlStr);
    switch (type) {
        case HttpRequestTypeGet:
        {
            NSString *str = @"";
            if (parameters) {
                str = [NSString stringWithFormat:@"%@%@",urlStr,[self getUrlParamStr:parameters]];
            }else {
                str = [NSString stringWithFormat:@"%@",urlStr];
            }
            str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"get请求的接口地址：%@",str);

            [manager GET:str parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:1 error:nil];
                    [self errorWithDict:resultDic];
                    success(resultDic);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"请求异常：%@",error);
                if (failure) {
                    if (error.code == NSURLErrorTimedOut ||error.code == NSURLErrorNotConnectedToInternet) {
                        //超时
                        [[HCToast shareInstance]showToast:@"网络异常，请稍后再试"];
                    }
                    [STTextHudTool hideSTHud];
                    failure(error);
                }
            }];
        }
            break;
        case HttpRequestTypePost:
        {
//            NSLog(@"post请求的接口地址：%@",urlStr);
            [manager POST:urlStr parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:1 error:nil];
                    [self errorWithDict:resultDic];
                    success(resultDic);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    if (error.code == NSURLErrorTimedOut ||error.code == NSURLErrorNotConnectedToInternet) {
                        //超时
                        [[HCToast shareInstance]showToast:@"网络异常，请稍后再试"];
                    }
                    [STTextHudTool hideSTHud];

                    failure(error);
                }
            }];
        }
            break;
            
        case HttpRequestTypePut:
        {
            [manager PUT:urlStr parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:1 error:nil];
                    [self errorWithDict:resultDic];
                    success(resultDic);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    if (error.code == NSURLErrorTimedOut ||error.code == NSURLErrorNotConnectedToInternet) {
                        //超时
                        NSLog(@"超时");
                    }
                    [STTextHudTool hideSTHud];

                    failure(error);
                }
            }];
            break;
        }
        case HttpRequestTypeDelete:
        {
            [manager DELETE:urlStr parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:1 error:nil];
                    [self errorWithDict:resultDic];
                    success(resultDic);
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    if (error.code == NSURLErrorTimedOut ||error.code == NSURLErrorNotConnectedToInternet) {
                        //超时
                        NSLog(@"超时");
                    }
                    [STTextHudTool hideSTHud];

                    failure(error);
                }
            }];
            break;
        }

    }
}


+(void)errorWithDict:(NSDictionary *)resultDic
{
    NSInteger code = [resultDic[@"code"] integerValue];
    if (code==200) {
        return;
    }
    
    NSString *message = resultDic[@"message"];
    if (code == 500 &&[message isEqualToString:@"TokenAuth Permission denied, you need to login"]){
        //登录失效
        [[HCToast shareInstance]showToast:@"登录失效,请重新登录"];
        [UntilTools cleanUserDefault];
        [UntilTools pushLoginPage];
    }
}


- (void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters uploadParam:(NSArray<UploadParam *> *)uploadParams success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UploadParam *uploadParam in uploadParams) {
            [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 下载数据
- (void)downLoadWithURLString:(NSString *)URLString parameters:(id)parameters progerss:(void (^)(void))progress success:(void (^)(void))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress();
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
    }];
    [downLoadTask resume];
}

@end
