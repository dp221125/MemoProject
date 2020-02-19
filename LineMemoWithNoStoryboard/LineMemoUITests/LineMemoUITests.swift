//
//  LineMemoUITests.swift
//  LineMemoUITests
//
//  Created by MinKyeongTae on 2020/02/18.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import XCTest

class LineMemoUITests: XCTestCase {
    let app = XCUIApplication() // 테스트를 위한 UIApplication

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // MARK: 앱 실행

        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddingMemoDataWithAlbumImage() {
        let addMemoMainView = app.otherElements.matching(identifier: XCTIdentifier.AddMemoView.mainView).firstMatch
        let imageCollectionView = app.collectionViews.matching(identifier: XCTIdentifier.AddMemoView.imageCollectionView).firstMatch
        let addImageCell = imageCollectionView.cells.matching(identifier: XCTIdentifier.AddMemoView.addImageCell).firstMatch
        let titleTextField = app.textFields.matching(identifier: XCTIdentifier.AddMemoView.titleTextField).firstMatch
        let subTextView = app.textViews.matching(identifier: XCTIdentifier.AddMemoView.subTextView).firstMatch

        // 메모추가버튼을 클릭한다.
        let addMemoBarButton = app.buttons.matching(identifier: XCTIdentifier.MainMemoView.addMemoBarButton).firstMatch
        XCTAssertTrue(addMemoBarButton.exists)
        addMemoBarButton.tap()

        // MARK: AddMemoView 이동

        titleTextField.tap()
        titleTextField.typeText("Insert Title Text")
        subTextView.tap()
        subTextView.typeText("Insert Sub Text")
        addMemoMainView.tap()
        addImageCell.tap()
        app.sheets.buttons.matching(identifier: XCTIdentifier.Alert.getAlbumAlertAction).firstMatch.tap()
        app.tables.cells.element(boundBy: 0).tap()
        selectCollectionViewItemCell(at: 1)
        pressChooseButton()
        saveMemo()
        selectMainMemoTableViewLastRowCell()
    }

    private func selectCollectionViewItemCell(at index: Int) {
        let collectionView = app.collectionViews.firstMatch
        collectionView.cells.element(boundBy: index).tap()
    }

    private func pressChooseButton() {
        app.buttons["Choose"].tap()
    }

    private func saveMemo() {
        app.buttons["저장"].tap()
        app.buttons["네"].tap()
    }

    private func selectMainMemoTableViewLastRowCell() {
        let mainMemoTableView = app.tables.matching(identifier: XCTIdentifier.MainMemoView.memoTableView)
        if mainMemoTableView.cells.count == 0 { return }
        mainMemoTableView.cells.element(boundBy: mainMemoTableView.cells.count - 1).tap()
    }

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
