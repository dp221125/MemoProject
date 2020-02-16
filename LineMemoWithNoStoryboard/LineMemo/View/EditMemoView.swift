//
//  EditMemoView.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/16.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - EditMemoView

class EditMemoView: UIView {
    
    // MARK: UI
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = ViewSize.basicSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    let imageLabel: UILabel = {
        let photoLabel = UILabel()
        photoLabel.textColor = .black
        photoLabel.font = UIFont.titleFont()
        photoLabel.text = "사진"
        return photoLabel
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.text = "제목"
        titleLabel.font = UIFont.titleFont()
        return titleLabel
    }()
    
    let subTextLabel: UILabel = {
        let subTextLabel = UILabel()
        subTextLabel.textColor = .black
        subTextLabel.text = "내용"
        subTextLabel.font = UIFont.titleFont()
        return subTextLabel
    }()
    
    let imageCollectionView: UICollectionView = {
        let imageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: MemoImageCollectionViewFlowLayout())
        imageCollectionView.isScrollEnabled = true
        imageCollectionView.isUserInteractionEnabled = true
        imageCollectionView.alwaysBounceHorizontal = true
        imageCollectionView.backgroundColor = .lightGray
        return imageCollectionView
    }()
    
    let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.textColor = .black
        titleTextField.font = UIFont.mainFont()
        return titleTextField
    }()
    
    let subTextView: UITextView = {
        let subTextView = UITextView()
        subTextView.font = UIFont.mainFont()
        return subTextView
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Configuration

extension EditMemoView: ViewSetting {
    func addSubviews() {
        stackView.addArrangedSubview(imageLabel)
        stackView.addArrangedSubview(imageCollectionView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(subTextLabel)
        stackView.addArrangedSubview(subTextView)
        addSubview(stackView)
    }

    func makeConstraints() {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            stackView.topAnchor.constraint(equalTo: self.safeAreaTopAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaBottomAnchor, constant: -10)
        ])
        
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageLabel.leftAnchor.constraint(equalTo: self.stackView.leftAnchor, constant: 10),
            imageLabel.rightAnchor.constraint(equalTo: self.stackView.rightAnchor, constant: -10),
            imageLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.stackView.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: self.stackView.rightAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: ViewSize.Height.titleLabel)
        ])
        
        subTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTextLabel.leftAnchor.constraint(equalTo: self.stackView.leftAnchor, constant: 10),
            subTextLabel.rightAnchor.constraint(equalTo: self.stackView.rightAnchor, constant: -10),
            subTextLabel.heightAnchor.constraint(equalToConstant: ViewSize.Height.titleLabel)
        ])
    
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: ViewSize.Height.imageCollectionView)
        ])
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleTextField.leftAnchor.constraint(equalTo: self.stackView.leftAnchor, constant: 10),
            self.titleTextField.rightAnchor.constraint(equalTo: self.stackView.rightAnchor, constant: -10),
            self.titleTextField.heightAnchor.constraint(equalToConstant: ViewSize.Height.textField),
        ])
        
        subTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.subTextView.leftAnchor.constraint(equalTo: self.stackView.leftAnchor, constant: 10),
            self.subTextView.rightAnchor.constraint(equalTo: self.stackView.rightAnchor, constant: -10)
        ])
    }
}
