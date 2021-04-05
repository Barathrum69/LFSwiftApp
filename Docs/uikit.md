#  UIKit扩展


## UIView扩展
### showPop在指定View上动画显示或关闭弹窗
```js
/// 在指定View上动画显示或关闭弹窗
/// - Parameters:
///   - inView: 在指定View上显示弹窗，当isShow=false时可为nil
///   - widthFactor: view宽度系数[0.1, 1]表示widthFactor*deviceWidth，如果值为[100, deviceWidth]表示所有机型都一样的宽度，如果不设置widthFactor则用自身的宽
///   - tapMaskClose: true:点击mask蒙版执行isShow=false操作 false:必须点关闭按钮才能关闭弹窗，当isShow=false时可为nil
func showPop(inView: UIView?, widthFactor: CGFloat, tapMaskClose: Bool)


/// 关闭弹窗
func closePop(completionBlock: VoidBlock?)
```

### UIView点击事件
```js
func addTap(handler: ((_ sender: UITapGestureRecognizer) -> Void)?) -> UITapGestureRecognizer?
```


### 获取view的x/y/width/height
```js
var x: CGFloat
var y: CGFloat
var width: CGFloat
var height: CGFloat
```


### stack view 布局
```js
/// stack view 布局
///
/// - Parameters:
///   - items: 要布局的子视图集合，须先添加进父视图中才能布局
///   - spacing: 间距
///   - margin: 边缘
func stackHerizontal(_ items: [UIView], _ spacing: CGFloat, _ margin: CGFloat) 


func stackVertical(_ items: [UIView], _ spacing: CGFloat, _ margin: CGFloat)
```

### 添加边框
```js
/// 单实线样式
///
/// - top: 顶部
/// - right: 右边
/// - bottom: 底部
/// - left: 左边
/// - strike: 删除线
enum BorderEdge: Int {
    case top, right, bottom, left, strike
}

/// 在view上添加SingleLine，线宽默认0.5
///
/// - Parameters:
///   - eage: 指定边缘
///   - color: 线条颜色
func addBorder(_ eage: BorderEdge, _ color: UIColor)
```


### bezier圆角
```js
/// 指定位置切圆角
///
/// - Parameters:
///   - view: 切圆角的view
///   - corners: 需要切的角
///   - cornerRadii: 圆角半径
static func bezierCorner(view: UIView, corners: UIRectCorner, cornerRadii: CGSize)
```


## UINavigationController

### Pop到前N个控制器
```js
/// Pop到前N个控制器
///
/// - Parameter index: 控制器栈中倒数第几个
func popViewController(atLast index: Int)
```


## UITableView

### Inset
```js
/// 标准间距 10
static let sectionInset: CGFloat = 10.0
/// section 间距 0
static let zeroInset: CGFloat = 0.001
```

### 高度为0的cell （自动布局）
```js
/// 高度为0的cell （自动布局）
static var emptyCell: UITableViewCell
```

## UIApplication
### 获取当前topViewController
```js
/// 获取当前topViewController
static var topViewController: UIViewController?
```

## UIImageView
### image动画 瞬间放大缩小
```js
func playBounce()
```


## UIImage
### compressQuality压缩到指定大小
```js
func compressQuality(maxLength: Int) -> Data
```

### 缩放到指定width
```js
func scaleImage(width: CGFloat) -> UIImage
```


## UIColor
### UIColor.hex(0xffffff)
```js
static func hex(_ value: Int, _ alpha: CGFloat) -> UIColor 
```



