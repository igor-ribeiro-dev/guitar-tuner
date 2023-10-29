//
//  DisplayTuneView.swift
//  GuitarTuner Watch App
//
//  Created by Igor Ribeiro on 28/10/23.
//

import SwiftUI
import MicrophonePitchDetector

struct DisplayTuneView: View {
    
    @ObservedObject private var pitchDetector = MicrophonePitchDetector()
    
    @State private var note: String = "A"
    @State private var frequencyMeasurement: Measurement<UnitFrequency> = Measurement(
        value: 440.0,
        unit: .hertz
    )
    @State private var circleColorBg = AppColors.background
    @State private var timerToRestoreBg: Timer?
    @State private var lastNoteTimestamp: Date?
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Spacer()
            
            ZStack {
                Circle()
                    .foregroundColor(circleColorBg)
                    .frame(width: 120)
                VStack {
                    Text(note).font(.largeTitle)
                    Text(frequencyMeasurement.formatted()).font(.caption2)
                }
                
            }
            
            Spacer()
            
            Image(systemName: "arrow.down")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            PitchScaleView(pitchDetector: pitchDetector)
                .frame(height: 30)
        }
        .onChange(of: pitchDetector.pitch, { _, _ in
            let tunerData = TunerData(pitch: pitchDetector.pitch)
            
            self.note = tunerData.closestNote.note.names[0]
            
            let color = getBackgroundColor(by: tunerData.closestNote.distance.cents)
            
            self.frequencyMeasurement = roundFrequencyMeasurement(
                frequency: tunerData.closestNote.frequency.measurement
            )
                        
            resetTimer()
            
            withAnimation(.easeInOut) {
                self.circleColorBg = color
            }
        })
        .ignoresSafeArea(edges: [.horizontal, .top])
    }
    
    func getBackgroundColor(by distance: Float) -> Color {
        
        let distanceAcceptable: Float = 8.0
        
        if distance >= (distanceAcceptable * -1) && distance <= distanceAcceptable {
            return Color.green
        }
        
        return AppColors.background
    }
    
    func roundFrequencyMeasurement(frequency: Measurement<UnitFrequency>) -> Measurement<UnitFrequency> {
        
        return Measurement(
            value: (frequency.value * 100).rounded() / 100,
            unit: UnitFrequency.hertz
        )
    }
    
    func resetTimer() -> Void {
        timerToRestoreBg?.invalidate()
        self.lastNoteTimestamp = Date()
        
        timerToRestoreBg = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            guard let lastTimestamp = self.lastNoteTimestamp else {
                return
            }
            
            if lastTimestamp.timeIntervalSinceNow <= -3 {
                timerToRestoreBg?.invalidate()
                
                withAnimation(.easeInOut) {
                    self.circleColorBg = AppColors.background
                }
            }
            
        }
    }
}

#Preview {
    DisplayTuneView()
}
