//
//  MemoDataManager.swift
//  LineMemo
//
//  Created by Seokho on 2020/03/23.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import RxSwift
import Foundation

class MemoDataManager {
//    var memo = PublishSubject<[MemoData]>()
    
    func loadData() -> Observable<[MemoData]> {
        return Observable.just([])
    }
}
