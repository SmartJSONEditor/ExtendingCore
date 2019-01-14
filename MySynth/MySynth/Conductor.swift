//
//  Conductor.swift
//  ExtendingAudioKit
//
//  Created by Shane Dunne, revision history on Githbub.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AudioKit

func offsetNote(_ note: MIDINoteNumber, semitones: Int) -> MIDINoteNumber {
    let nn = Int(note)
    return (MIDINoteNumber)(semitones + nn)
}

class Conductor {

    static let shared = Conductor()

    let midi = AKMIDI()
    var synth: MyAKSynth
    var reverb: AKZitaReverb
    var dryWet: AKDryWetMixer
    var plotout: AKMixer

    var pitchBendUpSemitones = 2
    var pitchBendDownSemitones = 2

    var synthSemitoneOffset = 0

    init() {

        // MIDI Configure
        midi.createVirtualPorts()
        midi.openInput("Session 1")
        midi.openOutput()

        // Session settings
        //AKAudioFile.cleanTempDirectory()
        AKSettings.bufferLength = .medium
        AKSettings.enableLogging = false

        // Signal Chain
        synth = MyAKSynth()
        reverb = AKZitaReverb(synth)
        dryWet = AKDryWetMixer(synth, reverb, balance: 0.5)
        plotout = AKMixer(dryWet)

        // Set Output & Start AudioKit
        AudioKit.output = dryWet
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start")
        }

        // Initial parameters setup: synth
        synth.attackDuration = 0.01
        synth.decayDuration = 0.01
        synth.sustainLevel = 0.8
        synth.releaseDuration = 0.25
        synth.filterAttackDuration = 2.0
        synth.filterDecayDuration = 2.0
        synth.filterSustainLevel = 0.0
        synth.filterReleaseDuration = 3.0
        synth.filterCutoff = 0.0
        synth.filterStrength = 20.0
        synth.vibratoDepth = 0.0
    }

    func addMIDIListener(_ listener: AKMIDIListener) {
        midi.addListener(listener)
    }

    func getMIDIInputNames() -> [String] {
        return midi.inputNames
    }

    func openMIDIInput(byName: String) {
        midi.closeAllInputs()
        midi.openInput(byName)
    }

    func openMIDIInput(byIndex: Int) {
        midi.closeAllInputs()
        midi.openInput(midi.inputNames[byIndex])
    }

    func playNote(note: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        // key-up, key-down and pedal operations are mediated by SDSustainer
        synth.play(noteNumber: offsetNote(note, semitones: synthSemitoneOffset), velocity: velocity)
    }

    func stopNote(note: MIDINoteNumber, channel: MIDIChannel) {
        // key-up, key-down and pedal operations are mediated by SDSustainer
        synth.stop(noteNumber: offsetNote(note, semitones: synthSemitoneOffset))
    }

    func allNotesOff() {
        for note in 0 ... 127 {
            synth.stop(noteNumber: MIDINoteNumber(note + synthSemitoneOffset))
        }
    }

    func afterTouch(_ pressure: MIDIByte) {
    }

    func controller(_ controller: MIDIByte, value: MIDIByte) {
        switch controller {
        case AKMIDIControl.modulationWheel.rawValue:
            synth.vibratoDepth = 0.5 * Double(value) / 128.0
        case AKMIDIControl.damperOnOff.rawValue:
            // key-up, key-down and pedal operations are mediated by SDSustainer
            synth.sustainPedal(pedalDown: value != 0)
        default:
            break
        }
    }

    func pitchBend(_ pitchWheelValue: MIDIWord) {
        let pwValue = Double(pitchWheelValue)
        let scale = (pwValue - 8_192.0) / 8_192.0
        if scale >= 0.0 {
            synth.pitchBend = scale * self.pitchBendUpSemitones
        } else {
            synth.pitchBend = scale * self.pitchBendDownSemitones
        }
    }

}