//
//  AddImageViewModel.swift
//  LineMemo
//
//  Created by Seokho on 2020/03/25.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol ImagePickerViewModelInputType {
    var data: AnyObserver<Data> { get }
}
protocol ImagePickerViewModelOutputType {
}

protocol ImagePikcerViewModelType {
    var pickerInputs: ImagePickerViewModelInputType { get }
    var pickerOutput: ImagePickerViewModelOutputType { get }
}

protocol AddMemoViewModelInputType {
    func checkInput(input: (fieldText: String, subText: String))
    func deleteButton(_ index: Int)
}
protocol AddMemoViewModelOutputType {
    var isVaild: Observable<Bool> { get }
    var imageList: Observable<[UIImage]> { get }
}

protocol AddMemoViewModelType: ImagePikcerViewModelType, ImagePickerViewModelInputType, ImagePickerViewModelOutputType {
    var inputs: AddMemoViewModelInputType { get }
    var outpusts: AddMemoViewModelOutputType { get }
}

class AddMemoViewModel: AddMemoViewModelType, AddMemoViewModelInputType, AddMemoViewModelOutputType {

    //ImagePikcerViewModelType
    var pickerInputs: ImagePickerViewModelInputType { return self }
    var pickerOutput: ImagePickerViewModelOutputType { return self }
    
    //AddMemoViewModelType
    var inputs: AddMemoViewModelInputType { return self }
    var outpusts: AddMemoViewModelOutputType { return self }
    
    var data: AnyObserver<Data>
    
    private var _isVaild = PublishSubject<Bool>()
    lazy var isVaild = _isVaild.asObservable()
    
    private let _imageList = BehaviorSubject<[UIImage]>(value: [.addImage])
    lazy var imageList: Observable<[UIImage]> = _imageList.asObservable()
    
    private let disposeBag = DisposeBag()
    
    init() {
        let data = PublishSubject<Data>()
        self.data = data.asObserver()
  
        data
            .compactMap { UIImage(data: $0)}
            .withLatestFrom(_imageList) { value0 ,value1 -> [UIImage] in
                var imageList = value1
                imageList.insert(value0, at: 1)
                return imageList
        }
        .bind(to: _imageList)
        .disposed(by: self.disposeBag)

    }
    
    func checkInput(input: (fieldText: String, subText: String)){
        let value =  !input.fieldText.trimmingCharacters(in: .whitespaces).isEmpty
            && !input.subText.trimmingCharacters(in: .whitespaces).isEmpty
        self._isVaild.onNext(value)
    }
    
    func deleteButton(_ index: Int) {
        do {
            var value = try _imageList.value()
            value.remove(at: index)
            _imageList.onNext(value)
        } catch {
            fatalError()
        }
    }
    

}
