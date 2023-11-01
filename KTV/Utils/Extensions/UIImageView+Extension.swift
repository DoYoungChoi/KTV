//
//  UIImageView+Extension.swift
//  KTV
//
//  Created by dodor on 2023/10/31.
//

import UIKit

extension UIImageView {
    
    @discardableResult
    func loadImage(url: URL) -> Task<Void, Never> {
        return .init {
            guard let responseData = try? await URLSession.shared.data(for: .init(url: url)).0,
                  let image = UIImage(data: responseData) else {
                return
            }
            
            self.image = image
        }
    }
    
}
