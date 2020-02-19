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
        // MARK: AddMemoView 이동

        pressAddMemoBarButton()

        // MARK: 메모 Image 선택

        pressAddImageCell()
        mornitorAlbumAuthAlertController()
        getAlbum()

        selectTableViewCell(at: 0)
        selectCollectionViewItemCell(at: 1)
        pressButton(identifier: "Choose")

        // MARK: 메모내용 입력

        insertMemoText(title: "Insert Title Text", subText: "Insert Sub Text")
        hideKeyboard()

        // MARK: 메모저장

        saveMemo()

        // MARK: 저장메모 확인

        selectMainMemoTableViewLastRowCell()
    }

    private func pressAddMemoBarButton() {
        let addMemoBarButton = app.buttons.matching(identifier: XCTIdentifier.MainMemoView.addMemoBarButton).firstMatch
        addMemoBarButton.tap()
    }

    private func pressAddImageCell() {
        let imageCollectionView = app.collectionViews.matching(identifier: XCTIdentifier.AddMemoView.imageCollectionView).firstMatch
        let addImageCell = imageCollectionView.cells.matching(identifier: XCTIdentifier.AddMemoView.addImageCell).firstMatch
        addImageCell.tap()
    }

    private func getAlbum() {
        app.sheets.buttons.matching(identifier: XCTIdentifier.Alert.getAlbumAction).firstMatch.tap()
        app.tap()
    }

    private func mornitorAlbumAuthAlertController() {
        addUIInterruptionMonitor(withDescription: "AlbumAuthAlertControllerPresented") { alert -> Bool in
            alert.buttons["OK"].tap()
            return true
        }
    }

    private func hideKeyboard() {
        let addMemoMainView = app.otherElements.matching(identifier: XCTIdentifier.AddMemoView.mainView).firstMatch
        addMemoMainView.tap()
    }

    private func insertMemoText(title: String, subText: String) {
        let titleTextField = app.textFields.matching(identifier: XCTIdentifier.AddMemoView.titleTextField).firstMatch
        let subTextView = app.textViews.matching(identifier: XCTIdentifier.AddMemoView.subTextView).firstMatch

        titleTextField.tap()
        titleTextField.typeText(title)
        subTextView.tap()
        subTextView.typeText(subText)
    }

    private func selectCollectionViewItemCell(at index: Int) {
        app.collectionViews.firstMatch.cells.element(boundBy: index).tap()
    }

    private func selectTableViewCell(at index: Int) {
        app.tables.cells.element(boundBy: index).tap()
    }

    func pressButton(identifier: String) {
        app.buttons[identifier].tap()
    }

    func saveMemo() {
        app.buttons["저장"].tap()
        let allowButton = app.buttons["네"]
        if allowButton.waitForExistence(timeout: 3.0) {
            allowButton.tap()
        }
    }

    func selectMainMemoTableViewLastRowCell() {
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
