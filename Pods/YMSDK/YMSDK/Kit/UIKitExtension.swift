//
//  Extension.swift
//  ymsports
//
//  Created by wood on 22/1/21.
//

import UIKit
import SnapKit
import CommonCrypto

// MARK: - UIView
public extension UIView {
    
    /// 在指定View上动画显示或关闭弹窗
    /// - Parameters:
    ///   - inView: 在指定View上显示弹窗，当isShow=false时可为nil
    ///   - widthFactor: view宽度系数[0.1, 1]表示widthFactor*deviceWidth，如果值为[100, deviceWidth]表示所有机型都一样的宽度，如果不设置widthFactor则用自身的宽
    ///   - tapMaskClose: true:点击mask蒙版执行isShow=false操作 false:必须点关闭按钮才能关闭弹窗，当isShow=false时可为nil
    func showPop(inView: UIView? = UIApplication.shared.keyWindow, widthFactor: CGFloat = CGFloat.zero, tapMaskClose: Bool = true) {
        if !Thread.current.isMainThread {
            XLog("非主线程调用UIKit")
            return
        }
        guard let inView = inView else { return }
        ToastUtil.showMask(in: inView) { tapMaskClose ? self.closePop() : nil }.addSubview(self)
        let width: CGFloat
        switch widthFactor {
        case CGFloat.zero:
            width = self.width
        case 0.1...1:
            width = widthFactor * inView.width
        case 100...inView.width:
            width = widthFactor
        default:
            width = 0.8 * inView.width
        }
        self.frame = CGRect(x: (inView.width - width) * 0.5, y: (inView.height - self.height) * 0.5, width: width, height: self.height)
        /**
         用代码创建的所有view ， translatesAutoresizingMaskIntoConstraints 默认是 YES
         用 IB 创建的所有 view ，translatesAutoresizingMaskIntoConstraints 默认是 NO (autoresize 布局:YES , autolayout布局 :NO)
         如果是xib创建的需要修改Layout设置为Auto
         */
        if !self.translatesAutoresizingMaskIntoConstraints || (widthFactor >= 0.1 && widthFactor <= 1) {
            self.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
                make.width.equalTo(width)
            })
        }
        self.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        }, completion: { _ in
            
        })
    }
    
    /// 关闭弹窗
    func closePop(completionBlock: VoidBlock? = nil) {
        UIView.animate(withDuration: 0.35, animations: {
            self.alpha = 0
        }, completion: { _ in
            let mask = self.superview
            self.removeFromSuperview()
            mask?.removeFromSuperview()
            completionBlock?()
        })
    }
}

// MARK: - UINavigationController
public extension UINavigationController {

    /// Pop到前N个控制器
    ///
    /// - Parameter index: 控制器栈中倒数第几个
    func popViewController(atLast index: Int) {
        let count = self.viewControllers.count
        if count > 0 && index < count {
            self.popToViewController(self.viewControllers[count - 1 - index], animated: true)
        }
    }
}

// MARK: - UITableView
public extension UITableView {
    /// 标准间距 10
    static let sectionInset: CGFloat = 10.0
    /// section 间距 0
    static let zeroInset: CGFloat = 0.001
}

// MARK: - UITableViewCell
public extension UITableViewCell {
    /// 高度为0的cell （自动布局）
    static var emptyCell: UITableViewCell {
        get {
            let cell = UITableViewCell()
            let view = UIView()
            view.backgroundColor = UIColor.clear
            cell.contentView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.top.equalToSuperview()
                make.bottom.equalToSuperview().priority(.low)
                make.height.equalTo(0.2) // 可显示的最小高度
            }
            return cell
        }
    }
}

// MARK: - UIImageView
public extension UIImageView {
    /// image动画 瞬间放大缩小
    func playBounce() {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.5)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic

        self.layer.add(bounceAnimation, forKey: nil)

        if let iconImage = self.image {
            let renderImage = iconImage.withRenderingMode(.automatic)
            self.image = renderImage
        }
    }
}

// MARK: - UIWindow
extension UIWindow {
    fileprivate static func getTopViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let naviC = vc as? UINavigationController {
            return UIWindow.getTopViewControllerFrom(naviC.visibleViewController)
        } else if let tabC = vc as? UITabBarController {
            return UIWindow.getTopViewControllerFrom(tabC.selectedViewController)
        } else if let presentC = vc?.presentedViewController {
            return UIWindow.getTopViewControllerFrom(presentC)
        } else {
            return vc
        }
    }

}

// MARK: - UIApplication
public extension UIApplication {
    /// 获取当前topViewController
    static var topViewController: UIViewController? {
        return UIWindow.getTopViewControllerFrom(UIApplication.shared.keyWindow?.rootViewController)
    }
}

// MARK: - UIButton
public extension UIButton {
    convenience init(text: String?, color: UIColor?, size: CGFloat, _ state: UIControl.State = []) {
        self.init()
        self.setTitle(text, for: state)
        self.setTitleColor(color, for: state)
        self.titleLabel?.font = UIFont.systemFont(ofSize: size)
    }
    
    /// 设置按钮badge number
    /// - Parameters:
    ///   - number: 数字 100 => 99+
    func setBadge(number: NSInteger) {
        let rect = imageView?.frame ?? CGRect.zero
        let badge = UILabel(frame: CGRect(x: rect.origin.x + rect.size.width - 10, y: rect.origin.y - 10, width: 20, height: 20))
        badge.layer.cornerRadius = 10
        badge.clipsToBounds = true
        badge.backgroundColor = UIColor.hex(0xE6505F)
        badge.textColor = UIColor.white
        badge.font = UIFont.systemFont(ofSize: 10)
        badge.textAlignment = .center
        badge.text = number > 99 ? "99+" : "\(number)"
        addSubview(badge)
    }
}

// MARK: - UILabel
public extension UILabel {

    convenience init(text: String?, color: UIColor, size: CGFloat) {
        self.init()
        self.text = text
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: size)
    }

}

// MARK: - UIView
public extension UIView {

    static private var blockKey = "UITapgestureBlockKey"
    
    /// 为View添加UITapGestureRecognizer事件
    /// - Parameters:
    ///   - handler: 点击回调
    /// - Returns: UITapGestureRecognizer
    @discardableResult
    func addTap(handler: @escaping ((_ sender: UITapGestureRecognizer) -> Void)) -> UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        let target = _UITapgestureBlockTarget(handler: handler)
        objc_setAssociatedObject(self, &UIView.blockKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        let tap = UITapGestureRecognizer(target: target, action: #selector(_UITapgestureBlockTarget.invoke(_:)))
        self.addGestureRecognizer(tap)
        return tap
    }

    private class _UITapgestureBlockTarget {
        private var handler: (_ sender: UITapGestureRecognizer) -> Void
        init(handler: @escaping (_ sender: UITapGestureRecognizer) -> Void) {
            self.handler = handler
        }
        @objc func invoke(_ sender: UITapGestureRecognizer) {
            handler(sender)
        }
    }

    /// frame.x
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame = CGRect(x: newValue, y: frame.origin.y, width: frame.width, height: frame.height)
        }
    }
    /// frame.y
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame = CGRect(x: frame.origin.x, y: newValue, width: frame.width, height: frame.height)
        }
    }
    /// frame.width
    var width: CGFloat {
        get {
            return frame.width
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newValue, height: frame.height)
        }
    }
    /// frame.height
    var height: CGFloat {
        get {
            return frame.height
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: newValue)
        }
    }

    /// stack view 布局
    ///
    /// - Parameters:
    ///   - items: 要布局的子视图集合，须先添加进父视图中才能布局
    ///   - spacing: 间距
    ///   - margin: 边缘
    func stackHerizontal(_ items: [UIView], _ spacing: CGFloat = 0, _ margin: CGFloat = 0) {
        guard items.count > 1 else {
            return
        }
        items.first?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(margin)
        })
        items.last?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-margin)
        })
        var prev: UIView?
        for view in items {
            if let prev = prev {
                view.snp.makeConstraints({ (make) in
                    make.left.equalTo(prev.snp.right).offset(spacing)
                    make.width.equalTo(prev)
                })
            }
            view.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            })
            prev = view
        }
    }
    func stackVertical(_ items: [UIView], _ spacing: CGFloat = 0, _ margin: CGFloat = 0) {
        guard items.count > 1 else {
            return
        }
        items.first?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(margin)
        })
        items.last?.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-margin)
        })
        var prev: UIView?
        for view in items {
            if let prev = prev {
                view.snp.makeConstraints({ (make) in
                    make.top.equalTo(prev.snp.bottom).offset(spacing)
                    make.height.equalTo(prev)
                })
            }
            view.snp.makeConstraints({ (make) in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            })
            prev = view
        }
    }

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
    func addBorder(_ eage: BorderEdge, _ color: UIColor) {
        let line = UIView()
        line.backgroundColor = color
        line.tag = 1000
        self.addSubview(line)
        switch eage {
        case .top:
            line.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(0.5)
            }
        case .right:
            line.snp.makeConstraints { (make) in
                make.top.bottom.right.equalToSuperview()
                make.width.equalTo(0.5)
            }
        case .bottom:
            line.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(0.5)
            }
        case .left:
            line.snp.makeConstraints { (make) in
                make.top.bottom.left.equalToSuperview()
                make.width.equalTo(0.5)
            }
        case .strike:
            line.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.right.equalToSuperview()
                make.height.equalTo(0.5)
            }
        }
    }

    /// 设置虚线边框
    ///
    /// - Parameter color: 边框颜色
    func addDashBorder(_ color: UIColor) {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.path = UIBezierPath(rect: self.bounds).cgPath
        layer.lineWidth = 0.5
        layer.lineCap = CAShapeLayerLineCap(rawValue: "round")
        layer.lineDashPattern = [2, 2]
        self.layer.addSublayer(layer)
    }

    /// 指定位置切圆角
    ///
    /// - Parameters:
    ///   - view: 切圆角的view
    ///   - corners: 需要切的角
    ///   - cornerRadii: 圆角半径
    static func bezierCorner(view: UIView, corners: UIRectCorner, cornerRadii: CGSize) {
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
}


@IBDesignable
public extension UILabel {
    /// 直接填Localized.strings里面的key
    @IBInspectable
    var localizedString: String? {
        get {
            return text
        }
        set {
            if let newValue = newValue {
                text = newValue.localized()
            }
        }
    }
}

// Declare a global var to produce a unique address as the assoc object handle
private var disabledColorHandle: UInt8 = 0 << 1

// MARK: - UIButton
@IBDesignable
public extension UIButton {
    /// 直接填Localized.strings里面的key
    @IBInspectable
    var localizedString: String? {
        get {
            return currentTitle
        }
        set {
            if let newValue = newValue {
                setTitle(newValue.localized(), for: [])
            }
        }
    }
    
    // https://stackoverflow.com/questions/14523348/how-to-change-the-background-color-of-a-uibutton-while-its-highlighted
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }

    @IBInspectable
    var disabledColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &disabledColorHandle) as? UIColor
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}


private var placeholderColorHandle: UInt8 = 0 << 2

// MARK: - UITextField
@IBDesignable
public extension UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        if let color = placeholderColor {
            attributedPlaceholder = NSAttributedString(string: placeholder?.localized() ?? "", attributes: [.foregroundColor: color])
        } else {
            placeholder = placeholder?.localized()
        }
    }
    @IBInspectable
    var placeholderColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &placeholderColorHandle) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &placeholderColorHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let color = newValue, let placeholder = placeholder {
                attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: color])
            }
        }
    }

}

// MARK: - UIImage
public extension UIImage {
    /// 压缩图片到指定大小 bytes
    ///
    /// - Parameter maxLength: bytes
    /// - Returns: Data
    func compressQuality(maxLength: Int) -> Data {
        var compression: CGFloat = 1
        var data = self.jpegData(compressionQuality: compression)!
        if data.count < maxLength {
            return data
        }
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            }
        }
        return data
    }

    /// 压缩图片到指定宽度
    ///
    /// - Parameter width: width
    /// - Returns: UIImage
    func scaleImage(width: CGFloat) -> UIImage {
        if self.size.width < width {
            return self
        }
        let hight = width / self.size.width * self.size.height
        let rect = CGRect(x: 0, y: 0, width: width, height: hight)
        // 开启上下文
        UIGraphicsBeginImageContext(rect.size)
        // 将图片渲染到图片上下文
        self.draw(in: rect)
        // 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        // 关闭图片上下文
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - UIColor
public extension UIColor {
    /// 获取颜色 .hex(0xffffff)
    ///
    /// - Parameters:
    ///   - value: 二进制value
    ///   - alpha: 透明度
    /// - Returns: UIColor
    static func hex(_ value: UInt, _ alpha: CGFloat = 1.0) -> UIColor {
        let red = (CGFloat)((value & 0xFF0000) >> 16) / 255.0
        let green = (CGFloat)((value & 0xFF00) >> 8) / 255.0
        let blue = (CGFloat)(value & 0xFF) / 255.0
        return .init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 获取颜色 .hex("#ffffff")/.hex("#ffffff00")/.hex("ffffff")/.hex("ffffff00")
    /// - Parameters:
    ///   - hexStr: 16进制字符串
    ///   - alpha: 透明度
    /// - Returns: UIcolor
    static func hex(_ hexStr: String, _ alpha: CGFloat = 1.0) -> UIColor {
        var hex: String = hexStr.trim()
        if hex.hasPrefix("#") {
            hex = String(hex.suffix(from: hex.index(hex.startIndex, offsetBy: 1)))
        }
        if hex.count > 8 {
            hex = String(hex.prefix(8))
        }
        if let hexNumber = UInt(hex, radix: 16) {
            if hex.count == 6 {
                return UIColor.hex(hexNumber, alpha)
            } else if let validAlpha = UInt(String(hex.suffix(2)), radix: 16) {
                return UIColor.hex(hexNumber, CGFloat(validAlpha) / 255.0)
            }
        }
        return .clear
    }
}

private var shadowColorHandle: UInt8 = 0 << 3

// MARK: - CALayer
public extension CALayer {
    /// xib中设置阴影颜色
    var shadowUIColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &shadowColorHandle) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &shadowColorHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 获取颜色 .hex("#ffffff")/.hex("#ffffff00")/.hex("ffffff")/.hex("ffffff00")
    /// - Parameters:
    ///   - hexStr: 16进制字符串
    ///   - alpha: 透明度
    /// - Returns: UIcolor
    static func hex(_ hexStr: String, _ alpha: CGFloat = 1.0) -> UIColor {
        var hex: String = hexStr.trim()
        if hex.hasPrefix("#") {
            hex = String(hex.suffix(from: hex.index(hex.startIndex, offsetBy: 1)))
        }
        if hex.count > 8 {
            hex = String(hex.prefix(8))
        }
        if let hexNumber = UInt(hex, radix: 16) {
            if hex.count == 6 {
                return UIColor.hex(hexNumber, alpha)
            } else if let validAlpha = UInt(String(hex.suffix(2)), radix: 16) {
                return UIColor.hex(hexNumber, CGFloat(validAlpha) / 255.0)
            }
        }
        return .clear
    }
}
