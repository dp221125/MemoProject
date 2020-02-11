//
//  ViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class MainMemoViewController: UIViewController {
    // MARK: - UI

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addMemoBarButtonItem: UIBarButtonItem!

    // MARK: - Properties

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    // MARK: Method

    // MARK: - Configuration

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailMemoViewController = segue.destination as? DetailMemoViewController,
            let memoData = sender as? MemoData else { return }
        detailMemoViewController.configureMemoData(memoData)
    }

    // MARK: - Event

    @IBAction func addMemoBarButtonItemPressed(_: UIBarButtonItem) {
        performSegue(withIdentifier: UIIdentifier.Segue.goToAddMemoView, sender: nil)
    }
}

extension MainMemoViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return UserDataManager.shared.memoDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mainTableViewCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.Table.main, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        mainTableViewCell.configureCell(UserDataManager.shared.memoDataList[indexPath.row])
        return mainTableViewCell
    }
}

extension MainMemoViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return CellHeight.mainTableView
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDataManager.shared.configureEditingMemoIndex(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: UIIdentifier.Segue.goToDetailMemoView, sender: UserDataManager.shared.memoDataList[indexPath.row])
    }

    func tableView(_: UITableView, editingStyleForRowAt _: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            do {
                try UserDataManager.shared.remove(at: indexPath.row)
            } catch {
                debugPrint("Removing Error")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}
