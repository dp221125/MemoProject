//
//  AddImageURLVIew.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/17.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - AddImageURLView

/// * 이미지 URL 등록 뷰
class AddImageURLView: UIView {
    // MARK: UI

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = ViewSize.basicSpacing
        return stackView
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "이미지 URL 입력 후 등록버튼을 눌러주세요."
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.mainFont()
        return titleLabel
    }()

    let addImageButton: UIButton = {
        let addButton = UIButton()
        addButton.accessibilityIdentifier = XCTIdentifier.AddImageURLView.addButton
        addButton.setTitleColor(.white, for: .normal)
        addButton.setTitleColor(.darkGray, for: .highlighted)
        addButton.setTitle("이미지 등록하기", for: .normal)
        return addButton
    }()

    let urlTextField: UITextField = {
        let urlTextField = UITextField()
        urlTextField.accessibilityIdentifier = XCTIdentifier.AddImageURLView.urlTextField
        urlTextField.placeholder = "이미지 URL을 입력해주세요."
        return urlTextField
    }()

    // MARK: Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Configuration

extension AddImageURLView: ViewSetting {
    func configureView() {
        backgroundColor = .white
        addSubviews()
        makeConstraints()
    }

    func addSubviews() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(urlTextField)
        stackView.addArrangedSubview(addImageButton)
        addSubview(stackView)
    }

    func makeConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.leftAnchor.constraint(equalTo: self.safeAreaLeftAnchor),
            self.stackView.rightAnchor.constraint(equalTo: self.safeAreaRightAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.safeAreaTopAnchor, constant: ViewSize.basicInset * 3),
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leftAnchor.constraint(equalTo: stackView.safeAreaLeftAnchor, constant: ViewSize.basicInset),
            self.titleLabel.rightAnchor.constraint(equalTo: stackView.safeAreaRightAnchor, constant: -ViewSize.basicInset),
            self.titleLabel.heightAnchor.constraint(equalToConstant: ViewSize.Height.titleLabel),
        ])

        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.urlTextField.leftAnchor.constraint(equalTo: stackView.safeAreaLeftAnchor, constant: ViewSize.basicInset),
            self.urlTextField.rightAnchor.constraint(equalTo: stackView.safeAreaRightAnchor, constant: -ViewSize.basicInset),
            self.urlTextField.heightAnchor.constraint(equalToConstant: ViewSize.Height.textField),
        ])

        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.addImageButton.leftAnchor.constraint(equalTo: stackView.safeAreaLeftAnchor, constant: ViewSize.basicInset),
            self.addImageButton.rightAnchor.constraint(equalTo: stackView.safeAreaRightAnchor, constant: -ViewSize.basicInset),
            self.addImageButton.heightAnchor.constraint(equalToConstant: ViewSize.Height.button),
        ])
    }
}
