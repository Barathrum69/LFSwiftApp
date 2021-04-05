# App通用跳转协议

## 支持协议类型

* H5和native交互  
	- 协议名：  
	`ymsdknative`  
	- 协议格式  
	`ymsdknative://event?type=xxx&WtagA=xxx&WtagQ=xxx&Ntag=xxx&param0=xxx&param1=xxx...`  
	- 协议示例  
	`ymsdknative://event?type=topicSubject&param0=catid`
* 外部拉起App  
	- 协议名：  
	`ymsdk`  
	- 协议格式  
	`ymsdk://event?type=xxx&WtagA=xxx&WtagQ=xxx&Ntag=xxx&param0=xxx&param1=xxx...`  
	- 协议示例  
	`ymsdk://event?type=topicSubject&param0=catid`
    
    <br>

```js
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
```

<br>
<br>
