//
//  TunerHandle.swift
//  GuitarTuner Watch App
//
//  Created by Igor Ribeiro on 13/10/23.
//

import Foundation


class TunerHandler {
    
    public struct MusicalNote {
        var note: String
        var tune: Double
        var freqStart: Double
        var freqEnd: Double
        var frequency: Double = 0.0
    }
    
    var notes: [MusicalNote] = [
        MusicalNote(note: "E2", tune: 82.41, freqStart: 81.17, freqEnd: 83.65),
        MusicalNote(note: "B3", tune: 246.94, freqStart: 243.23, freqEnd: 250.65),
        MusicalNote(note: "G3", tune: 196.00, freqStart: 193.12, freqEnd: 198.88),
        MusicalNote(note: "D3", tune: 146.83, freqStart: 144.63, freqEnd: 149.03),
        MusicalNote(note: "A2", tune: 110.00, freqStart: 108.35, freqEnd: 111.65),
        MusicalNote(note: "E4", tune: 329.63, freqStart: 324.68, freqEnd: 334.58),
        
        // Não fazem parte do violão
        MusicalNote(note: "C", tune: 261.63, freqStart: 254.29, freqEnd: 269.40),
        MusicalNote(note: "F", tune: 349.23, freqStart: 339.44, freqEnd: 359.61)
       
    ]

    
//    var A: MusicalNote = MusicalNote(note: "A", tune: 440.00, freqStart: 427.66, freqEnd: 453.08)
//    var B: MusicalNote = MusicalNote(note: "B", tune: 493.88, freqStart: 480.03, freqEnd: 508.57)
//    var C: MusicalNote = MusicalNote(note: "C", tune: 261.63, freqStart: 254.29, freqEnd: 269.40)
//    var D: MusicalNote = MusicalNote(note: "D", tune: 293.66, freqStart: 285.43, freqEnd: 302.39)
//    var E: MusicalNote = MusicalNote(note: "E", tune: 329.63, freqStart: 320.39, freqEnd: 339.43)
//    var F: MusicalNote = MusicalNote(note: "F", tune: 349.23, freqStart: 339.44, freqEnd: 359.61)
//    var G: MusicalNote = MusicalNote(note: "G", tune: 392.00, freqStart: 381.00, freqEnd: 403.65)
    
    func handleFrequency(frequency: Double) -> MusicalNote? {
        
        for note in notes {
            if frequency >= note.freqStart && frequency <= note.freqEnd {
                
                return MusicalNote(
                    note: note.note,
                    tune: note.tune,
                    freqStart: note.freqStart,
                    freqEnd: note.freqEnd,
                    frequency: frequency
                )
//                return note
            }
        }
        
        return nil
    }
    
    func getNote() -> MusicalNote {
        return MusicalNote(note: "E2", tune: 82.41, freqStart: 81.17, freqEnd: 83.65, frequency: 82.1313)
    }
}
