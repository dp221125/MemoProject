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
        return tableView
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
    }

    func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
