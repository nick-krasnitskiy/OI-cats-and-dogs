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
    
    var body: some View {
        HStack {
            Text("\(audioURL.lastPathComponent)")
            Spacer()
        }
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(speechRecorder: SpeechRecorder())
    }
}
