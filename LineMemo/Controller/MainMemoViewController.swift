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
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Method

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
        return CommonData.shared.memoDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mainTableViewCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.Table.main, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        mainTableViewCell.configureCell(CommonData.shared.memoDataList[indexPath.row])
        return mainTableViewCell
    }
}

extension MainMemoViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return CellHeight.mainTableView
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: UIIdentifier.Segue.goToDetailMemoView, sender: CommonData.shared.memoDataList[indexPath.row])
    }
}