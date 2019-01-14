//
//  MyAKSynthAudioUnit.swift
//  AudioKit
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2019 AudioKit. All rights reserved.
//

import AVFoundation
import AudioKit

public class MyAKSynthAudioUnit: AKGeneratorAudioUnitBase {

    func setParameter(_ address: MyAKSynthParameter, value: Double) {
        setParameterWithAddress(address.rawValue, value: Float(value))
    }

    func setParameterImmediately(_ address: MyAKSynthParameter, value: Double) {
        setParameterImmediatelyWithAddress(address.rawValue, value: Float(value))
    }

    var rampDuration: Double = 0.0 {
        didSet { setParameter(.rampDuration, value: rampDuration) }
    }

    var masterVolume: Double = 0.0 {
        didSet { setParameter(.masterVolume, value: masterVolume) }
    }

    var pitchBend: Double = 0.0 {
        didSet { setParameter(.pitchBend, value: pitchBend) }
    }

    var vibratoDepth: Double = 1.0 {
        didSet { setParameter(.vibratoDepth, value: vibratoDepth) }
    }

    var attackDuration: Double = 0.0 {
        didSet { setParameter(.attackDuration, value: attackDuration) }
    }

    var decayDuration: Double = 0.0 {
        didSet { setParameter(.decayDuration, value: decayDuration) }
    }

    var sustainLevel: Double = 0.0 {
        didSet { setParameter(.sustainLevel, value: sustainLevel) }
    }

    var releaseDuration: Double = 0.0 {
        didSet { setParameter(.releaseDuration, value: releaseDuration) }
    }

    var drawbar1: Double = 1.0 {
        didSet { setParameter(.drawbar1, value: drawbar1) }
    }

    var drawbar2: Double = 0.0 {
        didSet { setParameter(.drawbar2, value: drawbar2) }
    }

    var drawbar3: Double = 0.0 {
        didSet { setParameter(.drawbar3, value: drawbar2) }
    }

    var drawbar4: Double = 0.0 {
        didSet { setParameter(.drawbar4, value: drawbar4) }
    }

    var drawbar5: Double = 0.0 {
        didSet { setParameter(.drawbar5, value: drawbar5) }
    }

    var drawbar6: Double = 0.0 {
        didSet { setParameter(.drawbar6, value: drawbar6) }
    }

    var drawbar7: Double = 0.0 {
        didSet { setParameter(.drawbar7, value: drawbar7) }
    }

    var drawbar8: Double = 0.0 {
        didSet { setParameter(.drawbar8, value: drawbar8) }
    }

    var drawbar9: Double = 0.0 {
        didSet { setParameter(.drawbar9, value: drawbar9) }
    }

    var drawbar10: Double = 0.0 {
        didSet { setParameter(.drawbar10, value: drawbar10) }
    }

    var drawbar11: Double = 0.0 {
        didSet { setParameter(.drawbar11, value: drawbar11) }
    }

    var drawbar12: Double = 0.0 {
        didSet { setParameter(.drawbar12, value: drawbar12) }
    }

    var drawbar13: Double = 0.0 {
        didSet { setParameter(.drawbar13, value: drawbar13) }
    }

    var drawbar14: Double = 0.0 {
        didSet { setParameter(.drawbar14, value: drawbar14) }
    }

    var drawbar15: Double = 0.0 {
        didSet { setParameter(.drawbar15, value: drawbar15) }
    }

    var drawbar16: Double = 0.0 {
        didSet { setParameter(.drawbar16, value: drawbar16) }
    }

    public override func initDSP(withSampleRate sampleRate: Double,
                                 channelCount count: AVAudioChannelCount) -> AKDSPRef {
        return createMyAKSynthDSP(Int32(count), sampleRate)
    }

    override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let nonRampFlags: AudioUnitParameterOptions = [.flag_IsReadable, .flag_IsWritable]

        var parameterAddress: AUParameterAddress = 0

        let masterVolumeParameter = AUParameterTree.createParameter(
            identifier: "masterVolume",
            name: "Master Volume",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let pitchBendParameter = AUParameterTree.createParameter(
            identifier: "pitchBend",
            name: "Pitch Offset (semitones)",
            address: parameterAddress,
            range: -1_000.0...1_000.0,
            unit: .relativeSemiTones,
            flags: .default)

        parameterAddress += 1

        let vibratoDepthParameter = AUParameterTree.createParameter(
            identifier: "vibratoDepth",
            name: "Vibrato amount (semitones)",
            address: parameterAddress,
            range: 0.0...24.0,
            unit: .relativeSemiTones,
            flags: .default)

        parameterAddress += 1

        let drawbar1Parameter = AUParameterTree.createParameter(
            identifier: "drawbar1",
            name: "Drawbar 1 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar2Parameter = AUParameterTree.createParameter(
            identifier: "drawbar2",
            name: "Drawbar 2 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar3Parameter = AUParameterTree.createParameter(
            identifier: "drawbar3",
            name: "Drawbar 3 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar4Parameter = AUParameterTree.createParameter(
            identifier: "drawbar4",
            name: "Drawbar 4 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar5Parameter = AUParameterTree.createParameter(
            identifier: "drawbar5",
            name: "Drawbar 5 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar6Parameter = AUParameterTree.createParameter(
            identifier: "drawbar6",
            name: "Drawbar 6 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar7Parameter = AUParameterTree.createParameter(
            identifier: "drawbar7",
            name: "Drawbar 7 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar8Parameter = AUParameterTree.createParameter(
            identifier: "drawbar8",
            name: "Drawbar 8 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar9Parameter = AUParameterTree.createParameter(
            identifier: "drawbar9",
            name: "Drawbar 9 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar10Parameter = AUParameterTree.createParameter(
            identifier: "drawbar10",
            name: "Drawbar 10 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar11Parameter = AUParameterTree.createParameter(
            identifier: "drawbar11",
            name: "Drawbar 11 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar12Parameter = AUParameterTree.createParameter(
            identifier: "drawbar12",
            name: "Drawbar 12 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar13Parameter = AUParameterTree.createParameter(
            identifier: "drawbar13",
            name: "Drawbar 13 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar14Parameter = AUParameterTree.createParameter(
            identifier: "drawbar14",
            name: "Drawbar 14 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar15Parameter = AUParameterTree.createParameter(
            identifier: "drawbar15",
            name: "Drawbar 15 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let drawbar16Parameter = AUParameterTree.createParameter(
            identifier: "drawbar16",
            name: "Drawbar 16 level",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: .default)

        parameterAddress += 1

        let attackDurationParameter = AUParameterTree.createParameter(
            identifier: "attackDuration",
            name: "Amplitude Attack duration (seconds)",
            address: parameterAddress,
            range: 0.0...1000.0,
            unit: .seconds,
            flags: nonRampFlags)

        parameterAddress += 1

        let decayDurationParameter = AUParameterTree.createParameter(
            identifier: "decayDuration",
            name: "Amplitude Decay duration (seconds)",
            address: parameterAddress,
            range: 0.0...1000.0,
            unit: .seconds,
            flags: nonRampFlags)

        parameterAddress += 1

        let sustainLevelParameter = AUParameterTree.createParameter(
            identifier: "sustainLevel",
            name: "Amplitude Sustain level (fraction)",
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,
            flags: nonRampFlags)

        parameterAddress += 1

        let releaseDurationParameter = AUParameterTree.createParameter(
            identifier: "releaseDuration",
            name: "Amplitude Release duration (seconds)",
            address: parameterAddress,
            range: 0.0...1000.0,
            unit: .seconds,
            flags: nonRampFlags)

        setParameterTree(AUParameterTree(children: [
            masterVolumeParameter,
            pitchBendParameter,
            vibratoDepthParameter,
            drawbar1Parameter,
            drawbar2Parameter,
            drawbar3Parameter,
            drawbar4Parameter,
            drawbar5Parameter,
            drawbar6Parameter,
            drawbar7Parameter,
            drawbar8Parameter,
            drawbar9Parameter,
            drawbar10Parameter,
            drawbar11Parameter,
            drawbar12Parameter,
            drawbar13Parameter,
            drawbar14Parameter,
            drawbar15Parameter,
            drawbar16Parameter,
            attackDurationParameter,
            decayDurationParameter,
            sustainLevelParameter,
            releaseDurationParameter
            ]))

        masterVolumeParameter.value = 1.0
        pitchBendParameter.value = 0.0
        vibratoDepthParameter.value = 0.0

        attackDurationParameter.value = 0.0
        decayDurationParameter.value = 0.0
        sustainLevelParameter.value = 1.0
        releaseDurationParameter.value = 0.0
    }

    public override var canProcessInPlace: Bool { return true }

    public func playNote(noteNumber: UInt8,
                         velocity: UInt8,
                         noteFrequency: Float) {
        doMyAKSynthPlayNote(dsp, noteNumber, velocity, noteFrequency)
    }

    public func stopNote(noteNumber: UInt8, immediate: Bool) {
        doMyAKSynthStopNote(dsp, noteNumber, immediate)
    }

    public func sustainPedal(down: Bool) {
        doMyAKSynthSustainPedal(dsp, down)
    }

    override public func shouldClearOutputBuffer() -> Bool {
        return true
    }

}
