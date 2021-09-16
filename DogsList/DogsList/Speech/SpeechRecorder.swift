//
//  SpeechRecorder.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.09.2021.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class SpeechRecorder: ObservableObject {
    
    let objectWillChange = PassthroughSubject<SpeechRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    var recording = false {
            didSet {
                objectWillChange.send(self)
            }
        }
}
