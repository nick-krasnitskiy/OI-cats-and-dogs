//
//  SpeechPlayer.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 17.09.2021.
//

import Foundation
import Foundation
import SwiftUI
import Combine
import AVFoundation

class SpeechPlayer: ObservableObject {
    
    let objectWillChange = PassthroughSubject<SpeechPlayer, Never>()
    
    var isPlaying = false {
            didSet {
                objectWillChange.send(self)
            }
        }
    
    var audioPlayer: AVAudioPlayer!
    
}
