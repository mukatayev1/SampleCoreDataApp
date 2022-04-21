//
//  MyCell.swift
//  CoreDataPractice
//
//  Created by Aidos Mukatayev on 2022/04/19.
//

import UIKit

class MyCell: UITableViewCell {
    
    static let identifier = "MyCell"
    
    private let label: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .semibold)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLabel() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    func configure(text: String) {
        label.text = text
    }
}
