//
//  ContentView.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.09.2021.
//

import SwiftUI

struct RecordButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(K.Colors.speechButtonColor))
            .foregroundColor(.white)
            .clipped()
            .cornerRadius(25)
            .padding(.bottom, 40)
            .font(.system(size: 20))
            .scaleEffect(configuration.isPressed ? 1.5 : 1.0)
    }
}

struct ContentView: View {
    
    @ObservedObject var speechRecorder: SpeechRecorder
    
    var body: some View {
        VStack {
            RecordingsList(speechRecorder: speechRecorder)
            if speechRecorder.recording == false {
                Button(action: {print("Start recording")}) {
                    Label("Start", systemImage: "mic.circle")
                }
                .buttonStyle(RecordButton())
            } else {
                Button(action: {print("Stop recording")}) {
                    Label("Stop", systemImage: "stop.circle")
                }
            }
        }
        .navigationBarTitle("Speech recorder")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(speechRecorder: SpeechRecorder())
    }
}
