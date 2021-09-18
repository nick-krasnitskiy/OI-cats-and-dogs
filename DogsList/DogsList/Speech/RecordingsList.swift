//
//  RecordingsList.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.09.2021.
//

import SwiftUI

struct RecordingsList: View {
    
    @ObservedObject var speechRecorder: SpeechRecorder
    
    var body: some View {
        List {
            ForEach(speechRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURL: recording.fileURL)
            }
        }
    }
}

struct RecordingRow: View {
    
    var audioURL: URL
    
    @ObservedObject var speechPlayer = SpeechPlayer()
    
    var body: some View {
        HStack {
            if speechPlayer.isPlaying == false {
                Button(action: { self.speechPlayer.startPlayback(audio: self.audioURL)}) {
                    Label("\(audioURL.lastPathComponent)", systemImage: "play.circle")
                }
            } else {
                Button(action: { self.speechPlayer.stopPlayback()}) {
                    Label("\(audioURL.lastPathComponent)", systemImage: "stop")
                }
            }
        }.accentColor(Color(.white))
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(speechRecorder: SpeechRecorder())
    }
}
