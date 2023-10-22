import SwiftUI
import MicrophonePitchDetector


struct TunerView: View {
    private let tunerMaxValue: Double = 100
    private let minAngle: Double = -110
    private let maxAngle: Double = 220
        
    @ObservedObject private var pitchDetector = MicrophonePitchDetector()
    
    @State private var level: Double = 0.0
    @State private var btnLabel: String = "Start"
    
    @State private var note: String = ""

    
    var body: some View {
        VStack {
            Text("Nota: \(note)")
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
                .onChange(of: pitchDetector.pitch) { oldValue, newValue in
                    let tunerData = TunerData(pitch: pitchDetector.pitch)
                    self.note = tunerData.closestNote.note.names[0]
                    self.level = Double(tunerData.closestNote.distance.cents + 50)
                }
                
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
                    .animation(.easeIn(duration: 0.5), value: level)
            }
            .frame(width: 75, height: 75)
//            Button(btnLabel) {
//                Task {
//                    do {
//                        try await pitchDetector.activate()
//                    } catch {
//                        // TODO: Handle error
//                        print(error)
//                    }
//                }
//            }
        }
        .padding()
    }
}

#Preview {
    TunerView()
}
