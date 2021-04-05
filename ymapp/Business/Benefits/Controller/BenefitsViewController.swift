//
//  BenefitsViewController.swift
//  ymapp
//
//  Created by admin on 2021/3/11.
//

import Then
import UIKit
import XLPagerTabStrip
import YMSDK

class BenefitsViewController: ButtonBarPagerTabStripViewController {
    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()
    }

    private func setupUI() {
        navigationItem.title = "优惠活动"

        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _: CGFloat, _: Bool, _: Bool) -> Void in
            oldCell?.label.textColor = UIColor.gray
            newCell?.label.textColor = UIColor.blue
        }

        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemTitleColor = .gray
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .blue

        // tabbar
        let tabbar = ButtonBarView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
            buttonBarView = $0
            $0.backgroundColor = .purple
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalToSuperview()
                make.height.equalTo(44)
            }
        }
        // containerView
        _ = UIScrollView().then {
            self.view.addSubview($0)
            self.containerView = $0
            $0.snp.makeConstraints { make in
                make.left.bottom.right.equalToSuperview()
                make.top.equalTo(tabbar.snp.bottom)
            }
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vcs = ["全部", "最新", "新人", "VIP", "日常", "豪礼"].map { title -> UIViewController in
            let vc = BenefitTabStripVC()
            vc.title = title
            return vc
        }
        return vcs
    }
}
