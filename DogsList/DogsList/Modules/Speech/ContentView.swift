//
//  ContentView.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.09.2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var speechRecorder: SpeechRecorder
    
    var body: some View {
         NavigationView {
            VStack {
                Text("Speech Recorder")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .padding()
                RecordingsList(speechRecorder: speechRecorder)
                
                if speechRecorder.recording == false {
                    Button(action: {print(self.speechRecorder.startRecording())}) {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 85, height: 85)
                            Text("Start")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 40)
                } else {
                    Button(action: {self.speechRecorder.stopRecording()}) {
                        ZStack {
                            Circle()
                                .stroke(Color.white, lineWidth: 6)
                                .frame(width: 85, height: 85)
                            Text("Stop")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 40)
                }
            }
            .navigationBarHidden(true)
        }
        .colorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(speechRecorder: SpeechRecorder())
    }
}
