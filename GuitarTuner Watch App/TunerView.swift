//
//  TunerView.swift
//  GuitarTuner Watch App
//
//  Created by Igor Ribeiro on 12/10/23.
//

import SwiftUI



struct TunerView: View {
    private let tunerMaxValue: Double = 100
    private let minAngle: Double = -110
    private let maxAngle: Double = 220
    
    @StateObject private var audioProcessor = AudioProcessor()
    private var tunerHandler: TunerHandler = TunerHandler()
    
    @State private var level: Double = 0.0
    @State private var isListening = AudioProcessor.isListening
    @State private var btnLabel: String = "Start"
    
    @State private var note: String = ""

    
    var body: some View {
        VStack {
            
//            Text("Level: \(Int(level))")
            Text("Nota: \(note)")
                
            Spacer(minLength: 40)
            ZStack {
                Circle()
                    .trim(from: 0.2, to: 0.8)
                    .stroke(style: StrokeStyle(lineWidth: 40))
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(90) )
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2.5, height: 55)
                    .cornerRadius(1)
                    .offset(y: -30)
                    .rotationEffect(.degrees(minAngle + (level / tunerMaxValue) * maxAngle))
                    .animation(.easeOut(duration: 0.1), value: level)
            }
            .frame(width: 75, height: 75)
//            Slider(value: $level, in: 0...tunerMaxValue, step: 1)
            Button(btnLabel) {
                
//                
//                let note = tunerHandler.getNote()
//                
//                let diff = note.freqEnd - note.freqStart
//                let value = ((note.frequency - note.freqStart) * 100) / diff
//                
//                
//                self.note = note.note
//                self.level = value
                
                
                
                if(AudioProcessor.isListening) {
                    btnLabel = "Start"
                    audioProcessor.stopListening()
                } else {
                    btnLabel = "Stop"
                    Task {
                        await audioProcessor.startListening() { frequencyListened in
                            
//                            print(frequencyListened)
                            
                            guard let musicalNote = self.tunerHandler.handleFrequency(frequency: frequencyListened) else {
                                return
                            }
                            
                            self.note = musicalNote.note
                            
                            self.level = ((musicalNote.frequency - musicalNote.freqStart) * 100) / (musicalNote.freqEnd - musicalNote.freqStart)
                            
                            print(musicalNote)
                            
                           
                        }
                    }
                   
                }
            }
        }
        .padding()
    }
}

#Preview {
    TunerView()
}
