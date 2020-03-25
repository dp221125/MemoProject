//
//  MainMemoViewModel.swift
//  LineMemo
//
//  Created by Seokho on 2020/03/25.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation
import RxSwift

protocol MainMemoViewInputType {
    func deleteAction(_ row: Int)
}

protocol MainMemoViewOutputType {
    var memo: Observable<[MemoData]> { get }
}

protocol MainMemoViewModelType {
    var mainInputs: MainMemoViewInputType { get }
    var mainOutputs: MainMemoViewOutputType {get }
}

class MainMemoViewModel: MainMemoViewModelType, MainMemoViewInputType, MainMemoViewOutputType {
    
    var mainInputs: MainMemoViewInputType { return self }
    var mainOutputs: MainMemoViewOutputType { return self}
    
    //output
    var memo: Observable<[MemoData]>
    
    private let disposeBag = DisposeBag()
    private let dataManager: MemoDataManager
    
    init(dataManager: MemoDataManager = MemoDataManager()) {
        self.dataManager = dataManager
        let memo = BehaviorSubject<[MemoData]>(value: [])
        self.memo = memo
        
        dataManager.loadData()
            .bind(to: memo)
            .disposed(by: self.disposeBag)
        
    }
    
    func deleteAction(_ row: Int) {
        //
    }
}
