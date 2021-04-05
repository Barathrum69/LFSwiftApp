# LFSwiftApp

swift 基础框架

## Features

- [x] 首页
- [x] 优惠
- [x] 客服
- [x] 帮助中心
- [x] 个人中心

## Requirements

- iOS 11+ / macOS 11.0+ / xcode11.0+
- Swift 5.0+
- cocoapods 1.9.0+

### Installation

1. `git clone https://github.com/Barathrum69/LFSwiftApp.git`
2. `cd LFSwiftApp && pod install`
3. open ymapp.xcworkspace in xcode and click run.


### 项目结构

```
ProjectRoot
    |_ .gitignore       # 定义git忽略记录
    |_ CHANGELOG.md     # 每个版本的修改内容记录
    |_ Podfile          # cocoapods依赖管理
    |_ Docs/            # 项目文档
    |_ ymapp/           # 主项目
        |_ Base/        # 各种基类，例如BaseViewController
        |_ Business/    # 所有业务相关的代码
            |_ Home     # 业务模块名称，采用MVC架构
                |_ Model
                |_ View
                |_ Controller
            |_ Benefits
            |_ ...
        |_ Config/      # app配置文件
        |_ Entry/       # app入口
        |_ Api/         # 网络和Api请求接口
        |_ Kit/         # UI组件库
        |_ Utils/       # 工具目录
            |_ Router   # 页面统一跳转
            |_ Toast    # Toast相关
            |_ ...
        |_ Vendor/      # 手动集成的三方库
        |_ Resources/   # 资源文件，images、fonts、json、file
        |_ Support Files/       # 支持文件目录，Info.plist 本地化等
```


### Git提交规范
- `feat` :     新功能 feature
- `fix` :      修复 bug
- `docs` :      文档注释
- `style` :  代码格式(不影响代码运行的变动)
- `test` :    增加测试
- `chore` :  构建过程或辅助工具的变动


### Git分支命名规范
- `develop` 默认开发分支
- `fix` 线上问题修复分支，例如：fix/user-crash
- `master` 最终分支用来部署的

待功能自测完成后合并到`master`，更新文档说明并打`tag`更新版本号



### 代码开发规范

[Swift开发规范](Docs/swift-rules.md)


### Kit组件文档
- [ToastUtil HUD](Docs/toast.md)
- [Localized本地化](Docs/localized.md)
- [PopAlert通用弹框](Docs/popalert.md)
- [AppConfig](Docs/appconfig.md)
- [UIConfig](Docs/uiconfig.md)
- [Foundation扩展](Docs/foundation.md)
- [UIKit扩展](Docs/uikit.md)
- [Api网络请求](Docs/api.md)
- [App通用跳转协议](Docs/jump.md)
