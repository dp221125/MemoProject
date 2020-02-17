//
//  MainMemoView.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/16.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - MainMemoView

/// * 메인 메모리스트 뷰
class MainMemoView: UIView {
    // MARK: UI

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .lightGray
        tableView.separatorStyle = .none
        return tableView
    }()

    private let dataInfoLabel: UILabel = {
        let dataInfoLabel = UILabel()
        dataInfoLabel.font = UIFont.subFont()
        dataInfoLabel.textColor = .black
        dataInfoLabel.text = "현재 메모가 존재하지 않습니다."
        dataInfoLabel.textAlignment = .center
        return dataInfoLabel
    }()

    // MARK: Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Configuration

extension MainMemoView: ViewSetting {
    func addSubviews() {
        addSubview(tableView)
        addSubview(dataInfoLabel)
    }

    func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.safeAreaLeftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.safeAreaRightAnchor),
            tableView.topAnchor.constraint(equalTo: self.safeAreaTopAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaBottomAnchor),
        ])

        dataInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataInfoLabel.leftAnchor.constraint(equalTo: tableView.safeAreaLeftAnchor, constant: ViewSize.basicInset),
            dataInfoLabel.rightAnchor.constraint(equalTo: tableView.safeAreaRightAnchor, constant: -ViewSize.basicInset),
            dataInfoLabel.heightAnchor.constraint(equalToConstant: ViewSize.Height.titleLabel),
            dataInfoLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            dataInfoLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
    }

    func configureDataInfoLabel(isMemoData: Bool) {
        if isMemoData {
            dataInfoLabel.isHidden = true
        } else {
            dataInfoLabel.isHidden = false
        }
    }
}
