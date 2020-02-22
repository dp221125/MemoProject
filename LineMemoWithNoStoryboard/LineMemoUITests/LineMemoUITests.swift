//
//  LineMemoUITests.swift
//  LineMemoUITests
//
//  Created by MinKyeongTae on 2020/02/18.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//  now Branch : Feature/TestApp

import XCTest

class LineMemoUITests: XCTestCase {
    // MARK: - Property

    private let app = XCUIApplication() // 테스트를 위한 UIApplication

    // MARK: Test Data

    private let sampleImageURL = "https://homepages.cae.wisc.edu/~ece533/images/cat.png"
    private let testTitleText = "This is the title text"
    private let testTitleTextToEdit = "This is the Edited title text"
    private let testSubText = "This is the sub text"
    private let testSubTextToEdit = "This is the Edited sub text"
    private var imageEditingMode: ImageEditingMode = .noImage
    private let deleteImageCount = 1

    // MARK: - SetUp

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // MARK: 앱 실행

        app.launch()

        mornitorAlbumAuthAlertController()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    // MARK: - TearDown

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - TEST Method

    // MARK: - 메모추가 로직 테스트

    /// * 이미지, 텍스트 등을 포함한 메모 추가 로직 테스트
    func testAddingMemoData() {
        // 이미지 추가유형 선택

        imageEditingMode = .albumImage

        // AddMemoView 이동

        pressAddMemoBarButton()

        // 메모데이터 편집

        switch imageEditingMode {
        case .noImage:
            break
        case .albumImage:
            addAlbumImage()
        case .urlImage:
            addURLImage()
        }

        insertMemoText(title: testTitleText, subText: testSubText)
        sleep(1)

        // 메모저장

        saveMemo()
        sleep(1)

        // 저장메모 확인

        selectMainMemoTableViewLastRowCell()
    }

    // MARK: - 메모편집 로직 테스트

    /// * 메모 편집 간 이미지 삭제 /. 추가, 텍스트 수정 로직 테스트
    func testEditingMemoData() {
        // 이미지 추가유형 선택

        imageEditingMode = .albumImage

        // 첫번제 메모 선택

        pressFirstMemoTableViewCell()

        // 메모데이터 편집

        app.buttons["편집"].tap()

        // 기존 메모이미지 삭제 (삭제할 이미지 갯수 지정)

        deleteMemoImage(count: deleteImageCount)

        // 새 메모이미지 추가

        switch imageEditingMode {
        case .noImage:
            break
        case .albumImage:
            addAlbumImage()
        case .urlImage:
            addURLImage()
        }

        sleep(1)
        // 메모 텍스트 입역 및 메인화면 이동

        editMemoText(title: testTitleTextToEdit, subText: testSubTextToEdit)
        app.buttons["저장"].tap()
        app.buttons["메모 리스트"].tap()
        sleep(1)
    }

    // MARK: - 메모 데이터 확인 + 삭제 테스트

    /// * 존재 메모데이터 순차 확인 및 제거 로직 테스트
    func testDeletingMemoData() {
        let memoTableView = app.tables.matching(identifier: XCTIdentifier.MainMemoView.memoTableView).firstMatch
        XCTAssert(memoTableView.cells.count > 0, "There's no cell to delete")

        // 셀 메모 데이터 순차 확인 & 삭제

        while memoTableView.cells.count > 0 {
            sleep(1)
            checkFirstTableViewCellData(element: memoTableView)
            deleteFirstMemoTableViewCell(element: memoTableView)
        }
    }

    // MARK: - 앱 실행 테스트

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }

    // MARK: - Event Method

    private func deleteMemoImage(count: Int) {
        for _ in 0 ..< count {
            if app.collectionViews.cells.element(boundBy: 1).exists {
                app.collectionViews.cells.element(boundBy: 1).coordinate(withNormalizedOffset: CGVector.zero).withOffset(CGVector(dx: app.collectionViews.cells.element(boundBy: 1).frame.size.width - 20, dy: 20)).tap()
                sleep(1)
            }
        }
    }

    private func addURLImage() {
        pressAddImageCell()
        presentAddImageURLView()
        getURLImage(url: sampleImageURL)
    }

    private func addAlbumImage() {
        pressAddImageCell()
        getAlbumImage()
    }

    private func checkFirstTableViewCellData(element: XCUIElement) {
        let firstCell = element.cells.element(boundBy: 0)
        firstCell.tap()
        app.buttons["메모 리스트"].tap()
    }

    private func deleteFirstMemoTableViewCell(element: XCUIElement) {
        let firstCell = element.cells
        firstCell.element(boundBy: 0).swipeLeft()
        sleep(1)

        firstCell.element(boundBy: 0).buttons["Delete"].tap()
    }

    private func getURLImage(url imageURL: String) {
        let urlTextField = app.textFields.matching(identifier: XCTIdentifier.AddImageURLView.urlTextField).firstMatch
        let addURLImageButton = app.buttons.matching(identifier: XCTIdentifier.AddImageURLView.addButton).firstMatch
        let editMemoView = app.otherElements.matching(identifier: XCTIdentifier.EditMemoView.mainView).firstMatch

        XCTAssert(urlTextField.waitForExistence(timeout: 30.0), "Failed to get urlTextField")
        urlTextField.tap()

        urlTextField.typeText(imageURL)
        addURLImageButton.tap()

        XCTAssert(editMemoView.waitForExistence(timeout: TimeInterval(30.0)), "There is Long Delay while getting URL Image")
    }

    private func pressFirstMemoTableViewCell() {
        let memoDataCells = app.tables.matching(identifier: XCTIdentifier.MainMemoView.memoTableView).cells
        XCTAssert(memoDataCells.count > 0, "There's no memoDataCell")

        let firstCell = memoDataCells.element(boundBy: 0)
        firstCell.tap()
    }

    private func pressAddMemoBarButton() {
        let addMemoBarButton = app.buttons.matching(identifier: XCTIdentifier.MainMemoView.addMemoBarButton).firstMatch
        addMemoBarButton.tap()
    }

    private func pressAddImageCell() {
        let imageCollectionView = app.collectionViews.matching(identifier: XCTIdentifier.EditMemoView.imageCollectionView).firstMatch
        let addImageCell = imageCollectionView.cells.matching(identifier: XCTIdentifier.EditMemoView.addImageCell).firstMatch
        addImageCell.tap()
    }

    private func getAlbumImage() {
        let presentAlbumAction = app.sheets.buttons["앨범 사진 가져오기"]
        XCTAssert(presentAlbumAction.waitForExistence(timeout: 1.0), "Failed to get presentAlbumAtion")
        presentAlbumAction.tap()
        sleep(1)

        app.coordinate(withNormalizedOffset: CGVector.zero).tap()
        selectTableViewCell(at: 0)
        selectCollectionViewItemCell(at: 1)

        XCTAssert(pressButton(identifier: "Choose") || pressButton(identifier: "선택"), "Failed to press button")
    }

    private func presentAddImageURLView() {
        app.sheets.buttons["URL로 등록하기"].tap()
    }

    private func mornitorAlbumAuthAlertController() {
        addUIInterruptionMonitor(withDescription: "AlbumAuthAlertControllerPresented") { alert -> Bool in
            if alert.buttons["확인"].exists {
                alert.buttons["확인"].tap()
            } else if alert.buttons["OK"].exists {
                alert.buttons["OK"].tap()
            }
            return true
        }
    }

    private func hideKeyboard() {
        let addMemoMainView = app.otherElements.matching(identifier: XCTIdentifier.EditMemoView.mainView).firstMatch
        addMemoMainView.tap()
    }

    private func insertMemoText(title: String = "titleText", subText: String = "SubText") {
        let titleTextField = app.textFields.matching(identifier: XCTIdentifier.EditMemoView.titleTextField).firstMatch
        let subTextView = app.textViews.matching(identifier: XCTIdentifier.EditMemoView.subTextView).firstMatch

        XCTAssert(titleTextField.waitForExistence(timeout: 1.0), "Failed to get titleTextField")

        titleTextField.tap()
        titleTextField.typeText(title)
        subTextView.tap()
        subTextView.typeText(subText)

        hideKeyboard()
    }

    private func editMemoText(title: String = "editedText", subText: String = "editedText") {
        let titleTextField = app.textFields.matching(identifier: XCTIdentifier.EditMemoView.titleTextField).firstMatch
        let subTextView = app.textViews.matching(identifier: XCTIdentifier.EditMemoView.subTextView).firstMatch

        XCTAssert(titleTextField.waitForExistence(timeout: 1.0), "Failed to get titleTextField")
        titleTextField.tap()
        selectAllText(element: titleTextField)
        titleTextField.typeText(title)
        subTextView.tap()
        selectAllText(element: subTextView)
        subTextView.typeText(subText)

        hideKeyboard()
    }

    private func selectAllText(element: XCUIElement) {
        element.press(forDuration: TimeInterval(2.0))
        app.menuItems["Select All"].tap()
    }

    private func selectCollectionViewItemCell(at index: Int) {
        let collectionViewCells = app.collectionViews.cells
        let collectionViewCell = collectionViewCells.element(boundBy: index)
        XCTAssert(collectionViewCell.waitForExistence(timeout: 10.0), "Failed to get CollectionViewCell")
        collectionViewCell.tap()
    }

    private func selectTableViewCell(at index: Int) {
        let tableViewCells = app.tables.cells
        let tableViewCell = tableViewCells.element(boundBy: index)
        XCTAssert(tableViewCell.waitForExistence(timeout: 10.0), "Failed to get TableViewCell")
        tableViewCells.element(boundBy: index).tap()
    }

    private func pressButton(identifier: String) -> Bool {
        if app.buttons[identifier].waitForExistence(timeout: 3.0) {
            app.buttons[identifier].tap()
            return true
        }
        return false
    }

    private func saveMemo() {
        app.buttons["저장"].tap()
        let allowButton = app.buttons["네"]
        XCTAssert(allowButton.waitForExistence(timeout: 1.0), "Failed to get Button")
        allowButton.tap()
    }

    private func selectMainMemoTableViewLastRowCell() {
        let mainMemoTableView = app.tables.matching(identifier: XCTIdentifier.MainMemoView.memoTableView)
        XCTAssert(mainMemoTableView.cells.count > 0, "There's no memoDataCell")
        mainMemoTableView.cells.element(boundBy: mainMemoTableView.cells.count - 1).tap()
    }
}
