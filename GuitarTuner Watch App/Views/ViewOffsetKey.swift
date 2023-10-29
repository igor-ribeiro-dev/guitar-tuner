//
//  ViewOffsetKey.swift
//  GuitarTuner Watch App
//
//  Created by Igor Ribeiro on 28/10/23.
//

import SwiftUI

struct ViewOffsetData: Equatable {
    let scaleNote: ScaleNote
    let offset: CGFloat
}

struct ViewOffsetKey: PreferenceKey {
    
    typealias Value = [ViewOffsetData]
    
    static var defaultValue: [ViewOffsetData] = []
    
    static func reduce(value: inout [ViewOffsetData], nextValue: () -> [ViewOffsetData]) {
        value.append(contentsOf: nextValue())
    }
}
