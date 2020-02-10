//
//  ViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMemoBarButtonItem: UIBarButtonItem!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Method
    @IBAction func addMemoBarButtonItemPressed(_ sender: UIBarButtonItem) {
        print("pressed!!")
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommonData.shared.memoDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mainTableViewCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.main, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        return mainTableViewCell
    }
}

extension MainViewController: UITableViewDelegate {
    
}


