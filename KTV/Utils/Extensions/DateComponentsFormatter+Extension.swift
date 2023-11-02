//
//  DateComponentsFormatter+Extension.swift
//  KTV
//
//  Created by dodor on 2023/11/02.
//

import Foundation

extension DateComponentsFormatter {
    static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        return formatter
    }()
}
