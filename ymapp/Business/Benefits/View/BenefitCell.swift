//
//  BenefitCell.swift
//  ymapp
//
//  Created by admin on 2021/3/11.
//

import Then
import UIKit

class BenefitCell: UITableViewCell {
    weak var imgView: UIImageView!

    var model: String? {
        didSet {
            guard let str = model else {
                return
            }
            let url = URL(string: str)
            imgView.kf.setImage(with: url)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        imgView = UIImageView().then {
            self.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.right.bottom.equalToSuperview()
            }
        }
    }
}
