//
//  AudioTunerProcessor.swift
//  GuitarTuner Watch App
//
//  Created by Igor Ribeiro on 12/10/23.
//

import Foundation
import AVFoundation

class AudioProcessor: ObservableObject {
    
    private var frequencyHandler = FrequencyHandler()
    
    private var audioEngine: AVAudioEngine = AVAudioEngine()
    
    public static var isListening: Bool = false
    
    func validatePermissions() async -> Void {
        if await AVAudioApplication.requestRecordPermission() {
            print(" Tem permissão pra acessar o mic")
        } else {
            print(" Não tem a porra da permissão pra acessar o mic")
        }
    }
    
    func startListening(onFreqChange: @escaping (Double) -> Void) async {
        
        await validatePermissions()
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Erro ao configurar AVAudioSession: \(error)")
        }
        
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
//        let bufferSize: UInt32 = 8192
//        let bufferSize: UInt32 = 4096
//        let bufferSize: UInt32 = 1024
        let bufferSize: UInt32 = 1024
        
        inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: recordingFormat) { (buffer: AVAudioPCMBuffer, time: AVAudioTime) in
            
            let newFrequency: Double = self.frequencyHandler.handleBuffer(buffer: buffer)
        
            onFreqChange(newFrequency)
        }
        
        do {
            try audioEngine.start()
            AudioProcessor.isListening = true
        } catch {
            print("Erro ao iniciar o audioEngine: \(error.localizedDescription)")
            AudioProcessor.isListening = false
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        try? AVAudioSession.sharedInstance().setActive(false)
        AudioProcessor.isListening = false
    }
}
