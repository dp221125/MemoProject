//
//  RequestImage.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - RequestImage

/// * 이미지 요청 Singleton Class
final class RequestImage {
    static let shared = RequestImage()

    // MARK: Property

    var delegate: RequestImageDelegate?
}

// MARK: - RequestImage

extension RequestImage {
    func requestFromURL(_ urlString: String, completion: @escaping (Bool, UIImage?) -> Void) {
        delegate?.requestImageDidBegin()

        guard let imageURL = URL(string: urlString) else {
            delegate?.requestImageDidError()
            completion(false, nil)
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if error != nil {
                self.delegate?.requestImageDidError()
                completion(false, nil)
                return
            }

            DispatchQueue.main.async {
                guard let imageData = data,
                    let image = UIImage(data: imageData) else {
                    self.delegate?.requestImageDidError()
                    completion(false, nil)
                    return
                }

                self.delegate?.requestImageDidFinished()
                completion(true, image)
            }
        }.resume()
    }
}
