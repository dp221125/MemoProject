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

    // MARK: Initializer

    private init() {}
}

// MARK: - RequestImage

extension RequestImage {
    func requestFromURL(_ urlString: String) {
        delegate?.requestImageDidBegin(self)

        guard let imageURL = URL(string: urlString) else {
            delegate?.requestImageDidError(self, RequestImageError.requestFailed)
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if error != nil {
                self.delegate?.requestImageDidError(self, RequestImageError.invalidFormat)
                return
            }

            DispatchQueue.main.async {
                guard let imageData = data,
                    let image = UIImage(data: imageData) else {
                    self.delegate?.requestImageDidError(self, RequestImageError.invalidFormat)
                    return
                }

                self.delegate?.requestImageDidFinished(self, image)
            }
        }.resume()
    }
}
