//
//  AddMemoViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class AddMemoViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var subTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 1
        subTextView.layer.borderColor = UIColor.black.cgColor
        subTextView.layer.borderWidth = 1
    }
}
