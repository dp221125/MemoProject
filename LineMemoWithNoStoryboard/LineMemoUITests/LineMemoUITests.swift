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

    // MARK: - 이미지 x + 메모 추가 테스트

    func testAddingMemoDataWithoutImage() {
        // MARK: AddMemoView 이동

        pressAddMemoBarButton()

        // MARK: 메모내용 입력

        insertMemoText(title: "Insert Title Text", subText: "Insert Sub Text")
        hideKeyboard()
        sleep(1)

        // MARK: 메모저장

        saveMemo()
        sleep(1)

        // MARK: 저장메모 확인

        selectMainMemoTableViewLastRowCell()
    }

    // MARK: - URL이미지 + 메모 추가 테스트

    func testAddingMemoDataWithURLImage() {
        let sampleImageURL = "https://homepages.cae.wisc.edu/~ece533/images/cat.png"

        // MARK: AddMemoView 이동

        pressAddMemoBarButton()

        // MARK: 메모 URL Image 추가

        pressAddImageCell()
        presentAddImageURLView()
        getURLImage(url: sampleImageURL)

        // MARK: 메모내용 입력

        insertMemoText(title: "Insert Title Text", subText: "Insert Sub Text")
        hideKeyboard()
        sleep(1)

        // MARK: 메모저장

        saveMemo()
        sleep(1)

        // MARK: 저장메모 확인

        selectMainMemoTableViewLastRowCell()
    }

    // MARK: - 앨범 이미지 + 메모 추가 테스트

    func testAddingMemoDataWithAlbumImage() {
        // MARK: AddMemoView 이동

        pressAddMemoBarButton()

        // MARK: 메모 Image 선택

        pressAddImageCell()
        mornitorAlbumAuthAlertController()
        getAlbumImage()

        // MARK: 메모내용 입력

        insertMemoText(title: "Insert Title Text", subText: "Insert Sub Text")
        hideKeyboard()
        sleep(1)

        // MARK: 메모저장

        saveMemo()
        sleep(1)

        // MARK: 저장메모 확인

        selectMainMemoTableViewLastRowCell()
    }

    private func getURLImage(url imageURL: String) {
        let urlTextField = app.textFields.matching(identifier: XCTIdentifier.AddImageURLView.urlTextField).firstMatch
        let addURLImageButton = app.buttons.matching(identifier: XCTIdentifier.AddImageURLView.addButton).firstMatch
        let editMemoView = app.otherElements.matching(identifier: XCTIdentifier.AddMemoView.mainView).firstMatch

        urlTextField.tap()
        urlTextField.typeText(imageURL)
        addURLImageButton.tap()

        if !editMemoView.waitForExistence(timeout: TimeInterval(10.0)) {
            fatalError("There is Long Delay while getting URL Image")
        }
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

    private func getAlbumImage() {
        app.sheets.buttons.matching(identifier: XCTIdentifier.Alert.getAlbumAction).firstMatch.tap()
        app.tap()

        selectTableViewCell(at: 0)
        selectCollectionViewItemCell(at: 1)
        pressButton(identifier: "Choose")
    }

    private func presentAddImageURLView() {
        app.sheets.buttons.matching(identifier: XCTIdentifier.Alert.presentAddImageURLViewAction).firstMatch.tap()
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

    private func insertMemoText(title: String = "titleText", subText: String = "SubText") {
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

    private func pressButton(identifier: String) {
        app.buttons[identifier].tap()
    }

    private func saveMemo() {
        app.buttons["저장"].tap()
        let allowButton = app.buttons["네"]
        if allowButton.waitForExistence(timeout: 3.0) {
            allowButton.tap()
        }
    }

    private func selectMainMemoTableViewLastRowCell() {
        let mainMemoTableView = app.tables.matching(identifier: XCTIdentifier.MainMemoView.memoTableView)
        if mainMemoTableView.cells.count == 0 { return }
        mainMemoTableView.cells.element(boundBy: mainMemoTableView.cells.count - 1).tap()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
