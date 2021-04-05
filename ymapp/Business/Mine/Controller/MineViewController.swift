//
//  MineViewController.swift
//  ymapp
//
//  Created by 11号 on 2021/3/15.
//

import Kingfisher
import Then
import UIKit
import YMSDK

class MineViewController: BaseViewController {
    var bgScrollView: UIScrollView!
    var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func setupUI() {
       navigationController?.navigationBar.isHidden = true

        bgScrollView = UIScrollView().then {
            view.addSubview($0)
            $0.backgroundColor = UIColor(red: 237 / 255.0, green: 242 / 255.0, blue: 251 / 255.0, alpha: 1.0)
            $0.snp.makeConstraints { make in
                make.top.left.bottom.right.equalToSuperview()
            }
        }

        bgScrollView.addHeaderRefresh {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.bgScrollView.endHeaderRefresh()
            }
        }

//        _ = UIImageView().then {
//            bgScrollView.addSubview($0)
//            // 本地webp图片解码
//            let localUrl = Bundle.main.url(forResource: "common_message_icon", withExtension: "png")
//            let dataProvider = LocalFileImageDataProvider(fileURL: localUrl!)
//            $0.kf.setImage(with: dataProvider)
//            $0.snp.makeConstraints { make in
//                make.top.left.right.equalToSuperview()
//                make.height.equalTo(300)
//            }
//        }

        contentView = UIView().then { contView in
            bgScrollView.addSubview(contView)
//            contView.backgroundColor = .yellow
            contView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.width.equalTo(view.width)
                make.height.equalTo(500)
            }
        }

        self.setTopUI()
        self.setCenterUI()
        self.setBottomUI()
    }

    func setTopUI() {
        let topView = UIView().then {
            contentView.addSubview($0)
            $0.backgroundColor = .white
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(315)
            }
        }
        _ = UIImageView().then {
            topView.addSubview($0)
            $0.image = UIImage(named: "mine_bgImage")
            $0.snp.makeConstraints { make in
                make.top.left.bottom.right.equalToSuperview()
            }
        }

        _ = UIButton().then {
            topView.addSubview($0)
            $0.setBackgroundImage(UIImage(named: "common_message_icon"), for: .normal)
            $0.snp.makeConstraints { make in
                make.top.equalTo(20)
                make.right.equalTo(-60)
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
        }

        _ = UIButton().then {
            topView.addSubview($0)
            $0.setBackgroundImage(UIImage(named: "common_user_setting"), for: .normal)
            $0.snp.makeConstraints { make in
                make.top.equalTo(20)
                make.right.equalTo(-20)
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
        }

        let userImage = UIImageView().then {
            topView.addSubview($0)
            $0.image = UIImage(named: "mine_userDefalutIcon")
            $0.snp.makeConstraints { make in
                make.top.equalTo(40)
                make.left.equalTo(20)
                make.width.equalTo(80)
                make.height.equalTo(80)
            }
            $0.layoutIfNeeded()
            UIView.bezierCorner(view: $0, corners: .allCorners, cornerRadii: CGSize(width: 40, height: 40))
        }

        let userName = UILabel().then {
            topView.addSubview($0)
            $0.textColor = .black
            $0.textAlignment = .left
            $0.font = .boldSystemFont(ofSize: 17)
            $0.text = "ymtest2"
            $0.snp.makeConstraints { make in
                make.top.equalTo(userImage.snp.top).offset(10)
                make.left.equalTo(userImage.snp.right).offset(10)
                make.width.equalTo(150)
                make.height.equalTo(20)
            }
        }

        _ = UILabel().then {
            topView.addSubview($0)
            $0.textColor = .black
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 15)
            $0.text = "加入KOK第27天"
            $0.snp.makeConstraints { make in
                make.top.equalTo(userName.snp.bottom).offset(8)
                make.left.equalTo(userImage.snp.right).offset(10)
                make.width.equalTo(150)
                make.height.equalTo(20)
            }
        }

        let wallet = UILabel().then {
            topView.addSubview($0)
            $0.textColor = .black
            $0.textAlignment = .left
            $0.font = .boldSystemFont(ofSize: 15)
            $0.text = "中心钱包"
            $0.snp.makeConstraints { make in
                make.top.equalTo(userImage.snp.bottom).offset(30)
                make.left.equalTo(30)
                make.width.equalTo(150)
                make.height.equalTo(20)
            }
        }

        let mutableStr = NSMutableAttributedString(string: "￥210.55")
        mutableStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: NSRange(location: 0, length: 1))

        mutableStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: mutableStr.length))

        _ = UILabel().then {
            topView.addSubview($0)
            $0.textColor = .black
            $0.textAlignment = .left
            $0.font = .boldSystemFont(ofSize: 16)
            $0.attributedText = mutableStr
            $0.snp.makeConstraints { make in
                make.top.equalTo(wallet.snp.bottom).offset(10)
                make.left.equalTo(30)
                make.width.equalTo(150)
                make.height.equalTo(20)
            }
        }

        // 存取款转账view
        for index in 0...2 {
            let itemWidth = 60
            let space = 25
            let itemView = self.getCQItemView(index: index, itemW: itemWidth)
            topView.addSubview(itemView)
            let rightMargin = space * (index + 1) + itemWidth * index
            itemView.snp.makeConstraints { make in
                make.top.equalTo(userImage.snp.bottom).offset(10)
                make.right.equalTo(-rightMargin)
                make.width.equalTo(itemWidth)
                make.height.equalTo(itemWidth)
            }
        }

        // vip特权 总动员
        let vipView = UIView().then {
            topView.addSubview($0)
            $0.backgroundColor = UIColor(red: 227 / 255.0, green: 232 / 255.0, blue: 251 / 255.0, alpha: 1.0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(wallet.snp.bottom).offset(55)
                make.right.equalTo(-30)
                make.left.equalTo(30)
                make.height.equalTo(80)
            }
        }

        let vipImgView = UIImageView().then {
            vipView.addSubview($0)
            $0.image = UIImage(named: "kok_common_user_center_vip")
            $0.snp.makeConstraints { make in
                make.left.equalTo(10)
                make.width.equalTo(53)
                make.height.equalTo(61)
                make.centerY.equalToSuperview()
            }
        }

        _ = UILabel().then {
            vipView.addSubview($0)
            $0.textColor = .black
            $0.textAlignment = .left
            $0.font = .boldSystemFont(ofSize: 15)
            $0.text = "VIP特权"
            $0.snp.makeConstraints { make in
                make.top.equalTo(20)
                make.left.equalTo(vipImgView.snp.right)
                make.width.equalTo(100)
                make.height.equalTo(20)
            }
        }
        _ = UILabel().then {
            vipView.addSubview($0)
            $0.textColor = .darkGray
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 13)
            $0.text = "每月红包 晋级红利"
            $0.snp.makeConstraints { make in
                make.top.equalTo(40)
                make.left.equalTo(vipImgView.snp.right)
                make.width.equalTo(150)
                make.height.equalTo(20)
            }
        }

        let inviteImgView = UIImageView().then {
            vipView.addSubview($0)
            $0.image = UIImage(named: "kok_common_user_header_share")
            $0.snp.makeConstraints { make in
                make.left.equalTo(vipView.snp.centerX).offset(5)
                make.width.equalTo(43)
                make.height.equalTo(43)
                make.centerY.equalToSuperview()
            }
        }

        _ = UILabel().then {
            vipView.addSubview($0)
            $0.textColor = .black
            $0.textAlignment = .left
            $0.font = .boldSystemFont(ofSize: 15)
            $0.text = "KOK总动员"
            $0.snp.makeConstraints { make in
                make.top.equalTo(20)
                make.left.equalTo(inviteImgView.snp.right).offset(5.0)
                make.width.equalTo(100)
                make.height.equalTo(20)
            }
        }
        _ = UILabel().then {
            vipView.addSubview($0)
            $0.textColor = .darkGray
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 13)
            $0.text = "邀友同欢 有钱同赚"
            $0.snp.makeConstraints { make in
                make.top.equalTo(40)
                make.left.equalTo(inviteImgView.snp.right).offset(5.0)
                make.width.equalTo(150)
                make.height.equalTo(20)
            }
        }
    }

    func setCenterUI() {
        let centerView = UIView().then {
            contentView.addSubview($0)
            $0.backgroundColor = .white
            $0.snp.makeConstraints { make in
                make.top.equalTo(315)
                make.left.right.equalToSuperview()
                make.height.equalTo(145)
            }
        }

        _ = UILabel().then {
            centerView.addSubview($0)
            $0.textColor = .black
            $0.textAlignment = .left
            $0.font = .boldSystemFont(ofSize: 16)
            $0.text = "常用功能"
            $0.snp.makeConstraints { make in
                make.top.equalTo(15)
                make.left.equalTo(30)
                make.width.equalTo(150)
                make.height.equalTo(20)
            }
        }

        _ = UIView().then {
            centerView.addSubview($0)
            $0.backgroundColor = UIColor(red: 233 / 255.0, green: 234 / 255.0, blue: 246 / 255.0, alpha: 1.0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(45)
                make.left.equalTo(30)
                make.right.equalTo(-30)
                make.height.equalTo(0.5)
            }
        }
    }

    func setBottomUI() {
    }

    func getCQItemView(index: Int, itemW: Int) -> UIView {
        let itemWidth = CGFloat(itemW)
        let itemView = UIView().then {
            $0.backgroundColor = .clear
        }

        _ = UIButton().then {
            itemView.addSubview($0)
            $0.setBackgroundImage(UIImage(named: "mine_topIcon"), for: .normal)
            $0.addTarget(self, action: #selector(withdrawalAction(btn:)), for: .touchUpInside)
            $0.tag = index
            $0.frame = CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth)
        }
        _ = UILabel().then {
            itemView.addSubview($0)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 15)
            $0.text = itemStr(index: index)
            $0.frame = CGRect(x: 0, y: itemWidth, width: itemWidth, height: 20)
        }

        func itemStr(index: Int) -> String {
            switch index {
            case 0:
                return "取款"
            case 1:
                return "存款"
            case 2:
                return "转账"
            default:
                return ""
            }
        }

        return itemView
    }

    @objc func withdrawalAction(btn: UIButton) {
        XLog("点击按钮\(btn.tag)")
    }
}
