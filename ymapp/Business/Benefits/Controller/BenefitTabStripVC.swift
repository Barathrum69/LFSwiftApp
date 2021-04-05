//
//  BenifitTabStripVC.swift
//  ymapp
//
//  Created by admin on 2021/3/11.
//

import Then
import XLPagerTabStrip
import YMSDK

class BenefitTabStripVC: BaseViewController {
    weak var tableView: UITableView!

    var dataSource = [
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fww3.sinaimg.cn%2Flarge%2F007Q5zgrgy1g3xepjbqcvj31hc0u0npe.jpg&refer=http%3A%2F%2Fwww.sina.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1618056637&t=efdd80d9d7fd9965f16ede855a3f7f79",
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2018-05-24%2F5b06245ed5513.jpg&refer=http%3A%2F%2Fpic1.win4000.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1618056637&t=398fb56c8b8eace7229b15a82131c6e8",
        "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3537366469,1713966415&fm=26&gp=0.jpg"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView().then {
            view.addSubview($0)
            $0.dataSource = self
            $0.delegate = self
            $0.register(BenefitCell.self, forCellReuseIdentifier: "BenefitCell")
            $0.snp.makeConstraints { make in
                make.left.top.right.bottom.equalToSuperview()
            }
        }
    }
}

extension BenefitTabStripVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.title)
    }
}

extension BenefitTabStripVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BenefitCell") as! BenefitCell
        cell.model = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
