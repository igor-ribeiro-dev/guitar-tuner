//
//  FretView.swift
//  GuitarTuner Watch App
//
//  Created by Igor Ribeiro on 28/10/23.
//

import SwiftUI

struct FretView: View {
    
    var scaleNote: ScaleNote?
    
    private let baseHeight: CGFloat = 15
    private let baseWidth: CGFloat = 1.5
    
    var body: some View {
        ZStack(alignment: .center) {
            if(scaleNote != nil) {
                Rectangle()
                    .fill(AppColors.background)
                    .frame(width: self.baseWidth, height: self.baseHeight + 5)
                    .overlay() {
                        Group {
                            Text(self.scaleNote!.names[0])
                                .frame(alignment: .center)
                                .offset(x: 2, y: -22)
                        }
                        .frame(width: 30)
                    }
            } else {
                Rectangle()
                    .fill(AppColors.background)
                    .frame(width: self.baseWidth, height: self.baseHeight)
                
            }
        }
        .background(GeometryReader { geometry in
            if scaleNote != nil {
                Color.clear.preference(
                    key: ViewOffsetKey.self,
                    value: [ViewOffsetData(
                        scaleNote: scaleNote!,
                        offset: geometry.frame(in: .global).minX
                    )])
            }
        })
        .frame(
            width: 1.5,
            height: 60
        )
    }
    
    
}

#Preview {
    HStack(alignment: .bottom) {
        FretView(scaleNote: ScaleNote.A)
        FretView()
        FretView()
        FretView()
        FretView()
        FretView(scaleNote: ScaleNote.G)
        FretView()
        FretView()
        FretView()
        FretView()
        FretView(scaleNote: ScaleNote.DSharp_EFlat)
    }
}
