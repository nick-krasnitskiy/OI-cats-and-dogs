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
            Text("Empty list")
        }
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(speechRecorder: SpeechRecorder())
    }
}
