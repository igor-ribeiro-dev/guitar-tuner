//
//  FrequencyHandler.swift
//  GuitarTuner Watch App
//
//  Created by Igor Ribeiro on 12/10/23.
//

import Foundation
import Accelerate
import AVFoundation

class FrequencyHandler {

    

    func handleBuffer(buffer: AVAudioPCMBuffer) -> Double {
        
        if let channelData = buffer.floatChannelData?[0] {
            let bufferSize = buffer.frameLength

            // Preparação
            let log2n = vDSP_Length(log2(Double(bufferSize)))
            let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2))
            var real = [Float](repeating: 0, count: Int(bufferSize))
            var imaginary = [Float](repeating: 0, count: Int(bufferSize))
            var output = DSPSplitComplex(realp: &real, imagp: &imaginary)

            // Copie os dados do buffer para o array real (assumindo que seu buffer contém apenas dados reais)
            for i in 0..<Int(bufferSize) {
                real[i] = channelData[i]
                imaginary[i] = 0.0
            }

            // Realize a FFT
            vDSP_fft_zip(fftSetup!, &output, 1, log2n, FFTDirection(FFT_FORWARD))

            // Cálculo das magnitudes
            var magnitudes = [Float](repeating: 0.0, count: Int(bufferSize))
            vDSP_zvmags(&output, 1, &magnitudes, 1, vDSP_Length(bufferSize))

            // Encerre o setup FFT quando terminar
            vDSP_destroy_fftsetup(fftSetup)

            // Opcional: Encontre o índice da magnitude máxima para determinar a frequência predominante
            var maxMagnitude: Float = 0.0
            var maxIndex: vDSP_Length = 0
            vDSP_maxvi(magnitudes, 1, &maxMagnitude, &maxIndex, vDSP_Length(bufferSize))

//            print("Índice da frequência predominante: \(maxIndex)")
            
//            let sampleRate: Double = 44100.0
            let sampleRate: Double = 48000.0
//            let sampleRate: Double = 88200.0
//            let sampleRate: Double = 96000.0
            
            func frequencyForIndex(_ index: UInt) -> Double {
                return Double(index) * sampleRate / Double(bufferSize)
            }
            
            return frequencyForIndex(maxIndex)
        }
        
        return 0.0
    }
    
    func handleBufferr(buffer: AVAudioPCMBuffer) -> Double {
        if let channelData = buffer.floatChannelData?[0] {
            let bufferSize = buffer.frameLength

            // Preparação
            let log2n = vDSP_Length(log2(Double(bufferSize)))
            let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2))
            
            var real = [Float](repeating: 0, count: Int(bufferSize))
            var imaginary = [Float](repeating: 0, count: Int(bufferSize))
            
            // Janelamento
            var window = [Float](repeating: 0.0, count: Int(bufferSize))
            vDSP_hann_window(&window, vDSP_Length(bufferSize), Int32(vDSP_HANN_NORM))
            for i in 0..<Int(bufferSize) {
                real[i] = channelData[i] * window[i]
                imaginary[i] = 0.0
            }
            
            var output = DSPSplitComplex(realp: &real, imagp: &imaginary)
            
            // Realize a FFT
            vDSP_fft_zip(fftSetup!, &output, 1, log2n, FFTDirection(FFT_FORWARD))
            
            // Cálculo das magnitudes
            var magnitudes = [Float](repeating: 0.0, count: Int(bufferSize))
            vDSP_zvmags(&output, 1, &magnitudes, 1, vDSP_Length(bufferSize))
            
            // Encerre o setup FFT quando terminar
            vDSP_destroy_fftsetup(fftSetup)
            
            // Encontre o índice da magnitude máxima para determinar a frequência predominante
            var maxMagnitude: Float = 0.0
            var maxIndex: vDSP_Length = 0
            vDSP_maxvi(magnitudes, 1, &maxMagnitude, &maxIndex, vDSP_Length(bufferSize))
            
            let sampleRate: Double = 48000.0
            func frequencyForIndex(_ index: UInt) -> Double {
                return round( Double(index) * sampleRate / Double(bufferSize) )
            }
            
            return frequencyForIndex(maxIndex)
        }
        
        print("ta saindo zero")
        return 0.0
    }

}
