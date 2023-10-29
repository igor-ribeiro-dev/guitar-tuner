//
//  PitchScaleView.swift
//  GuitarTuner Watch App
//
//  Created by Igor Ribeiro on 28/10/23.
//

import SwiftUI
import MicrophonePitchDetector


struct PitchScaleView: View {
        
    @ObservedObject var pitchDetector: MicrophonePitchDetector
    @State private var scrollValue: CGFloat = 0
    @State private var scaleNotesOffset: [ViewOffsetData] = []
    
    let centsSize = 12
    
    var body: some View {
        
        GeometryReader { geometry in
            
            HStack(alignment: .bottom) {
                                
                ForEach(ScaleNote.allCases, id: \.self) { scaleNote in
                                        
                    ForEach(0..<centsSize, id: \.self) { index in
                        FretView()
                    }
                    
                    FretView(scaleNote: scaleNote)
                }
                
                ForEach(0..<centsSize, id: \.self) { index in
                    FretView()
                }
            }
            
            .offset(x: scrollValue)
            .onPreferenceChange(ViewOffsetKey.self) { data in
                
                if(self.scaleNotesOffset.count != 0) {
                    return
                }
                
                self.scaleNotesOffset = data
            }
            .onChange(of: pitchDetector.pitch) { _, detectedPitch in
                
                let tunerData = TunerData(pitch: pitchDetector.pitch)
                
                for scaleNoteOffset in scaleNotesOffset {
                    if scaleNoteOffset.scaleNote == tunerData.closestNote.note {
                        
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut) {
                                
                                let distance = tunerData.closestNote.distance.cents
                                let baseOffset = (geometry.size.width / 2) + (-scaleNoteOffset.offset)
                                
                                scrollValue = baseOffset + CGFloat(distance)
                            }
                        }
                        break
                    }
                }
                
            }
            .onAppear() {
                Task {
                    do {
                        try await pitchDetector.activate()
                    } catch {
                        // TODO: Handle error
                        print(error)
                    }
                }
            }
        }
    }
}

#Preview {
    PitchScaleView(pitchDetector: MicrophonePitchDetector())
}
