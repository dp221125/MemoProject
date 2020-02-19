//
//  XCTIdentifier.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/19.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

struct XCTIdentifier {
    struct MainMemoView {
        static let addMemoBarButton = "addMemoBarButtonItem"
        static let memoTableView = "memoTableView"
    }

    struct Alert {
        static let authRequestControllerView = "authRequestAlertControllerView"
        static let addImageControllerView = "addImageAlertView"
        static let getAlbumAction = "getAlbumAlertAction"
        static let presentAddImageURLViewAction = "getImageFromURLAction"
        static let getCameraAction = "getCameraAlertAction"
        static let cancelAction = "cancelAlertAction"
    }

    struct AddMemoView {
        static let imageCollectionView = "imageCollectionView"
        static let addImageCell = "addImageCell"
        static let mainView = "addMemoView"
        static let titleTextField = "titleTextField"
        static let subTextView = "subTextView"
    }

    struct AddImageURLView {
        static let addButton = "addImageURLButton"
        static let urlTextField = "urlTextField"
    }
}
