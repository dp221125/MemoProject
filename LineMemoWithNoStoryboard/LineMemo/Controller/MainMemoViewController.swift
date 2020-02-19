//
//  ViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - MainMemoViewController

/// * 메인 메모리스트 뷰컨트롤러

class MainMemoViewController: UIViewController {
    // MARK: UI

    private let mainView: MainMemoView = {
        let mainView = MainMemoView()
        return mainView
    }()

    // MARK: Life Cycle

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
}

// MARK: - Configuration

extension MainMemoViewController: ViewControllerSetting {
    func configureViewController() {
        title = TitleData.mainMemoView
        configureTableView()
        configureAddMemoBarButtonItem()
    }

    private func configureAddMemoBarButtonItem() {
        let addMemoBarButtonItem = UIBarButtonItem(title: "메모추가", style: .plain, target: self, action: #selector(addMemoBarButtonItemPressed(_:)))
        addMemoBarButtonItem.tintColor = .black
        addMemoBarButtonItem.activateXCTIdentifier(XCTIdentifier.MainMemoView.addMemoBarButton)
        navigationItem.rightBarButtonItem = addMemoBarButtonItem
    }

    private func configureTableView() {
        let mainMemoTableViewCellNib = UINib(nibName: UIIdentifier.Nib.TableViewCell.mainMemo, bundle: nil)

        mainView.tableView.register(mainMemoTableViewCellNib, forCellReuseIdentifier: UIIdentifier.Cell.Table.main)

        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.allowsSelectionDuringEditing = false
    }

    func reloadMemoData() {
        DispatchQueue.main.async { [weak self] in
            self?.mainView.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailMemoViewController = segue.destination as? DetailMemoViewController,
            let memoData = sender as? MemoData else { return }
        detailMemoViewController.configureMemoData(memoData)
    }
}

// MARK: - Event

extension MainMemoViewController {
    @objc func addMemoBarButtonItemPressed(_: UIBarButtonItem) {
        presentViewController(destination: AddMemoViewController())
    }
}

// MARK: - Transition

extension MainMemoViewController {
    func presentDetailViewController(indexPath: IndexPath) {
        let detailMemoViewController = DetailMemoViewController()
        detailMemoViewController.configureMemoData(UserDataManager.shared.memoDataList[indexPath.row])
        presentViewController(destination: detailMemoViewController)
    }
}

// MARK: - UITableViewDataSource

extension MainMemoViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        mainView.configureDataInfoLabel(isMemoData: UserDataManager.shared.memoDataList.isEmpty ? false : true)
        return UserDataManager.shared.memoDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mainTableViewCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.Table.main, for: indexPath) as? MainMemoTableViewCell else { return UITableViewCell() }
        mainTableViewCell.configureCell(UserDataManager.shared.memoDataList[indexPath.row])
        return mainTableViewCell
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            do {
                try UserDataManager.shared.remove(at: indexPath.row)
                mainView.tableView.deleteRows(at: [indexPath], with: .automatic)
                navigationController?.presentToastView("해당 메모가 삭제되었습니다.")
            } catch {
                navigationController?.presentToastView("메모 삭제에 실패했습니다.\n\(String(describing: (error as? UserDataError)?.message))")
            }
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate

extension MainMemoViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return ViewSize.Height.mainTableView
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        return UIView()
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDataManager.shared.configureEditingMemoIndex(at: indexPath.row)
        mainView.tableView.deselectRow(at: indexPath, animated: true)

        presentDetailViewController(indexPath: indexPath)
    }

    func tableView(_: UITableView, editingStyleForRowAt _: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
