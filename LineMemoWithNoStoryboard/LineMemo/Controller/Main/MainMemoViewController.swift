//
//  ViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - MainMemoViewController
/// * 메인 메모리스트 뷰컨트롤러
class MainMemoViewController: UIViewController {
    // MARK: UI
    
    private let viewModel: MainMemoViewModelType
    private let disposeBag = DisposeBag()
    private weak var dataInfoLabel: UILabel?
    private var tableView: UITableView {
        guard let tableView = self.view as? UITableView else {
            fatalError()
        }
        return tableView
    }

    
    init(viewModel: MainMemoViewModelType = MainMemoViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    override func loadView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        self.view = tableView
        
        let mainMemoTableViewCellNib = UINib(nibName: UIIdentifier.Nib.TableViewCell.mainMemo, bundle: nil)
        tableView.register(mainMemoTableViewCellNib, forCellReuseIdentifier: UIIdentifier.Cell.Table.main)
        tableView.delegate = self
        tableView.allowsSelectionDuringEditing = false
        
        let dataInfoLabel = UILabel()
        dataInfoLabel.font = UIFont.subFont()
        dataInfoLabel.textColor = .black
        dataInfoLabel.text = "현재 메모가 존재하지 않습니다."
        dataInfoLabel.textAlignment = .center
        self.dataInfoLabel = dataInfoLabel
        tableView.addSubview(dataInfoLabel)
        dataInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataInfoLabel.leftAnchor.constraint(equalTo: tableView.safeAreaLeftAnchor, constant: ViewSize.basicInset),
            dataInfoLabel.rightAnchor.constraint(equalTo: tableView.safeAreaRightAnchor, constant: -ViewSize.basicInset),
            dataInfoLabel.centerXAnchor.constraint(equalTo: tableView.safeAreaCenterXAnchor),
            dataInfoLabel.centerYAnchor.constraint(equalTo: tableView.safeAreaCenterYAnchor)
        ])
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TitleData.mainMemoView
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "메모추가", style: .plain, target: self, action: #selector(addMemoBarButtonItemPressed(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    func configureDataInfoLabel(_ isMemoData: Bool) {
        if isMemoData {
            dataInfoLabel?.isHidden = true
        } else {
            dataInfoLabel?.isHidden = false
        }
    }
    
    @objc
    private func addMemoBarButtonItemPressed(_: UIBarButtonItem) {
        presentViewController(destination: AddMemoViewController())
    }
    
    private func bind() {

        self.viewModel.mainOutputs.memo
            .do(onNext: { data in self.configureDataInfoLabel(data.isEmpty ? false : true) })
            .bind(to: tableView.rx.items(cellIdentifier: UIIdentifier.Cell.Table.main,
                                         cellType: MainMemoTableViewCell.self)) {
                                            _, item, cell in
                                            cell.configureCell(item) }
            .disposed(by: self.disposeBag)
        
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

// MARK: - UITableViewDelegate
extension MainMemoViewController: UITableViewDelegate {
    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            self.viewModel.mainInputs.deleteAction(indexPath.row)
        default:
            break
        }
    }
        
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
        self.tableView.deselectRow(at: indexPath, animated: true)
        presentDetailViewController(indexPath: indexPath)
    }

    func tableView(_: UITableView, editingStyleForRowAt _: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
