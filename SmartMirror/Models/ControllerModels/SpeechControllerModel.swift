//
//  SpeechControllerModel.swift
//  SmartMirror
//
//  Created by Sander Geraedts on 19/01/2019.
//  Copyright © 2019 Code Panda. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechControllerModel {
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speak(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        
        speechUtterance.pitchMultiplier = 1.3
        speechUtterance.rate = 0.525
        
        speechSynthesizer.speak(speechUtterance)
    }
}
