//
//  Tuner.swift
//  FFT Spectro
//
//  Created by Anadyr on 5/24/20.
//  Copyright © 2020 Anadyr. All rights reserved.
//

import Foundation
import SwiftUI

struct TuneData {
    var note: String
    var freq: Float
    var difference: String
}



var launched: Bool = false

//var notes = ("C", "C#", "D", "Eb", "E", "F", "F#", "G", "G#", "A", "Bb", "B")
var notes = ("C C# D Eb E F F# G G# A Bb B").components(separatedBy: " ")

//var f =


var C0 = 16.35
var base = log2(C0)
var C2 = pow(2, base + Double(2))
var C6 = pow(2, base + Double(6))
var C8 = pow(2, base + Double(8))


func getNote(frequency: Float) -> TuneData {
    if (!frequency.isNormal) { return TuneData(note: "ERROR 404", freq: frequency, difference: "Note Not Found") }
    let log = log2(frequency) - Float(base)
    let noteLength = notes.count
    let note = (log * Float(noteLength))
    let noteIndex = round(note)
    let difference = note - noteIndex
    let formattedDifference = (abs(difference) < 0.05) ? "Perfect" : String(round(difference * 100))
    let formattedNote = String(notes[Int(noteIndex) % noteLength]) + String(Int(log))
    let noteData = TuneData(note: formattedNote, freq: frequency, difference: formattedDifference)
    
    return noteData
    
    
}




var audioInput: TempiAudioInput!
class Spectral {
    var note = TuneData(note: "", freq: 0.00, difference: "")
    
    func start(){
        let audioInputCallback: TempiAudioInputCallback = { (timeStamp, numberOfFrames, samples) -> Void in
            self.bufferAudio(samples: samples)
        }
        
        audioInput = TempiAudioInput(audioInputCallback: audioInputCallback, sampleRate: 10000, numberOfChannels: 1)
        audioInput.startRecording()
    }
    let fft = TempiFFT(withSize: 1024, sampleRate: 10000)
    
    var bucket = [Float]()
    
    func bufferAudio(samples: [Float]) {
        bucket += samples
        if (bucket.count >= 1024) {
            fft_is_go(samples: bucket)
            bucket = [Float]()
        }
    }
    
    func fft_is_go( samples: [Float]) {
        
        
        fft.windowType = TempiFFTWindowType.hamming
        fft.fftForward(samples)
        
        fft.calculateLogarithmicBands(minFrequency: Float(C2), maxFrequency: Float(C6), bandsPerOctave: 144)

        var max_magnitude = Float(-1e20)
        var max_index = -1
        for (i, m) in fft.bandMagnitudes.enumerated() {
            if (m > max_magnitude) {
                max_magnitude = m
                max_index = i
            }
        }
        let max_freq = fft.bandFrequencies[max_index]
        

        self.note = getNote(frequency: max_freq)
        
        
    }
}

