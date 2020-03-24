//
//  ToastView.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/12.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - ToastView

/// * 알림목적 토스트 뷰 Singleton class

final class ToastView {
    static let shared = ToastView()

    // MARK: UI

    private let backgroundView = UIView()
    private let contentView = UIView()
    private let textLabel = UILabel()

    // MARK: Initializer

    private init() {}
}

// MARK: - Configuration

extension ToastView {
    private func congifureToastView(_ view: UIView, message: String) {
        backgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundView.center = view.center
        backgroundView.backgroundColor = .clear
        backgroundView.alpha = 0
        view.addSubview(backgroundView)

        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.8, height: 50)
        contentView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 100)
        contentView.backgroundColor = .darkGray
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = ViewSize.CornerRadius.basic
        contentView.alpha = 0

        textLabel.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        textLabel.numberOfLines = 2
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textColor = .white
        textLabel.center = contentView.center
        textLabel.text = message
        textLabel.textAlignment = .center
        textLabel.center = CGPoint(x: contentView.bounds.width / 2, y: contentView.bounds.height / 2)
        contentView.addSubview(textLabel)
        view.addSubview(contentView)
    }
}

// MARK: Event

extension ToastView {
    func presentShortMessage(_ view: UIView, message: String) {
        congifureToastView(view, message: message)

        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.contentView.alpha = 0.8
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.3, animations: { [weak self] in
                self?.contentView.alpha = 0
            }) { _ in
                DispatchQueue.main.async { [weak self] in
                    self?.textLabel.removeFromSuperview()
                    self?.contentView.removeFromSuperview()
                    self?.backgroundView.removeFromSuperview()
                }
            }
        }
    }
}
