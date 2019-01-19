//
//  AKOrganAudioUnit.swift
//  AudioKit
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2019 AudioKit. All rights reserved.
//

import AVFoundation
import AudioKit

public class AKOrganAudioUnit: AKGeneratorAudioUnitBase {

    func setParameter(_ address: AKOrganParameter, value: Double) {
        setParameterWithAddress(address.rawValue, value: Float(value))
    }

    func setParameterImmediately(_ address: AKOrganParameter, value: Double) {
        setParameterImmediatelyWithAddress(address.rawValue, value: Float(value))
    }

    var rampDuration: Double = 0.0 {
        didSet { setParameter(.rampDuration, value: rampDuration) }
    }

    var masterVolume: Double = 1.0 {
        didSet { setParameter(.masterVolume, value: masterVolume) }
    }

    var pitchBend: Double = 0.0 {
        didSet { setParameter(.pitchBend, value: pitchBend) }
    }

    var vibratoDepth: Double = 1.0 {
        didSet { setParameter(.vibratoDepth, value: vibratoDepth) }
    }

    var drawbar0: Double = 0.0 {
        didSet { setParameter(.drawbar0, value: drawbar0) }
    }

    var drawbar1: Double = 0.0 {
        didSet { setParameter(.drawbar1, value: drawbar1) }
    }

    var drawbar2: Double = 1.0 {
        didSet { setParameter(.drawbar2, value: drawbar2) }
    }

    var drawbar3: Double = 0.0 {
        didSet { setParameter(.drawbar3, value: drawbar3) }
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

    var attackDuration: Double = 0.0 {
        didSet { setParameter(.attackDuration, value: attackDuration) }
    }

    var decayDuration: Double = 0.0 {
        didSet { setParameter(.decayDuration, value: decayDuration) }
    }

    var sustainLevel: Double = 1.0 {
        didSet { setParameter(.sustainLevel, value: sustainLevel) }
    }

    var releaseDuration: Double = 0.0 {
        didSet { setParameter(.releaseDuration, value: releaseDuration) }
    }

    var power: Double = 1.0 {
        didSet { setParameter(.power, value: power) }
    }

    var drive: Double = 1.0 {
        didSet { setParameter(.drive, value: drive) }
    }

    var outputLevel: Double = 1.0 {
        didSet { setParameter(.outputLevel, value: outputLevel) }
    }

    var leslieSpeed: Double = 4.0 {
        didSet { setParameter(.leslieSpeed, value: leslieSpeed) }
    }

    public override func initDSP(withSampleRate sampleRate: Double,
                                 channelCount count: AVAudioChannelCount) -> AKDSPRef {
        return createAKOrganDSP(Int32(count), sampleRate)
    }

    override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let nonRampFlags: AudioUnitParameterOptions = [.flag_IsReadable, .flag_IsWritable]

        var parameterAddress: AUParameterAddress = 0

        let masterVolumeParameter = AUParameterTree.createParameter(
            identifier: "masterVolume",
            name: "masterVolume",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let pitchBendParameter = AUParameterTree.createParameter(
            identifier: "pitchBend",
            name: "pitchBend",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: -1000.0...1000.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let vibratoDepthParameter = AUParameterTree.createParameter(
            identifier: "vibratoDepth",
            name: "vibratoDepth",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1000.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let drawbar0Parameter = AUParameterTree.createParameter(
            identifier: "drawbar0",
            name: "drawbar0",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let drawbar1Parameter = AUParameterTree.createParameter(
            identifier: "drawbar1",
            name: "drawbar1",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let drawbar2Parameter = AUParameterTree.createParameter(
            identifier: "drawbar2",
            name: "drawbar2",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let drawbar3Parameter = AUParameterTree.createParameter(
            identifier: "drawbar3",
            name: "drawbar3",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let drawbar4Parameter = AUParameterTree.createParameter(
            identifier: "drawbar4",
            name: "drawbar4",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let drawbar5Parameter = AUParameterTree.createParameter(
            identifier: "drawbar5",
            name: "drawbar5",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let drawbar6Parameter = AUParameterTree.createParameter(
            identifier: "drawbar6",
            name: "drawbar6",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let drawbar7Parameter = AUParameterTree.createParameter(
            identifier: "drawbar7",
            name: "drawbar7",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let drawbar8Parameter = AUParameterTree.createParameter(
            identifier: "drawbar8",
            name: "drawbar8",            // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,             // TODO: fix unit
            flags: .default)            // TODO: fix flags

        parameterAddress += 1

        let attackDurationParameter = AUParameterTree.createParameter(
            identifier: "attackDuration",
            name: "attackDuration",         // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...10.0,
            unit: .generic,             // TODO: fix unit
            flags: nonRampFlags)        // TODO: fix flags

        parameterAddress += 1

        let decayDurationParameter = AUParameterTree.createParameter(
            identifier: "decayDuration",
            name: "decayDuration",         // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...10.0,
            unit: .generic,             // TODO: fix unit
            flags: nonRampFlags)        // TODO: fix flags

        parameterAddress += 1

        let sustainLevelParameter = AUParameterTree.createParameter(
            identifier: "sustainLevel",
            name: "sustainLevel",         // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...1.0,
            unit: .generic,             // TODO: fix unit
            flags: nonRampFlags)        // TODO: fix flags

        parameterAddress += 1

        let releaseDurationParameter = AUParameterTree.createParameter(
            identifier: "releaseDuration",
            name: "releaseDuration",         // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 0.0...10.0,
            unit: .generic,             // TODO: fix unit
            flags: nonRampFlags)        // TODO: fix flags

        parameterAddress += 1

        let powerParameter = AUParameterTree.createParameter(
            identifier: "power",
            name: "power",         // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 1.0...2.0,
            unit: .generic,             // TODO: fix unit
            flags: nonRampFlags)        // TODO: fix flags

        parameterAddress += 1

        let driveParameter = AUParameterTree.createParameter(
            identifier: "drive",
            name: "drive",         // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 1.0...2.5,
            unit: .generic,             // TODO: fix unit
            flags: nonRampFlags)        // TODO: fix flags

        parameterAddress += 1

        let outputLevelParameter = AUParameterTree.createParameter(
            identifier: "outputLevel",
            name: "outputLevel",         // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 1.0...2.5,
            unit: .generic,             // TODO: fix unit
            flags: nonRampFlags)        // TODO: fix flags

        parameterAddress += 1

        let leslieSpeedParameter = AUParameterTree.createParameter(
            identifier: "leslieSpeed",
            name: "leslieSpeed",         // TODO: fix human-readable parameter name
            address: parameterAddress,
            range: 1.0...8.0,
            unit: .generic,             // TODO: fix unit
            flags: nonRampFlags)        // TODO: fix flags

        parameterAddress += 1

        setParameterTree(AUParameterTree(children: [
            masterVolumeParameter,
            pitchBendParameter,
            vibratoDepthParameter,
            drawbar0Parameter,
            drawbar1Parameter,
            drawbar2Parameter,
            drawbar3Parameter,
            drawbar4Parameter,
            drawbar5Parameter,
            drawbar6Parameter,
            drawbar7Parameter,
            drawbar8Parameter,
            attackDurationParameter,
            decayDurationParameter,
            sustainLevelParameter,
            releaseDurationParameter,
            powerParameter,
            driveParameter,
            outputLevelParameter,
            leslieSpeedParameter,
            ]))

        masterVolumeParameter.value = 1.0
        pitchBendParameter.value = 0.0
        vibratoDepthParameter.value = 1.0
        drawbar0Parameter.value = 0.0
        drawbar1Parameter.value = 0.0
        drawbar2Parameter.value = 1.0
        drawbar3Parameter.value = 0.0
        drawbar4Parameter.value = 0.0
        drawbar5Parameter.value = 0.0
        drawbar6Parameter.value = 0.0
        drawbar7Parameter.value = 0.0
        drawbar8Parameter.value = 0.0
        attackDurationParameter.value = 0.0
        decayDurationParameter.value = 0.0
        sustainLevelParameter.value = 1.0
        releaseDurationParameter.value = 0.0
        powerParameter.value = 1.0
        driveParameter.value = 1.0
        outputLevelParameter.value = 1.0
        leslieSpeedParameter.value = 4.0
    }

    public override var canProcessInPlace: Bool { return true }

    public func playNote(noteNumber: UInt8,
                         velocity: UInt8,
                         noteFrequency: Float) {
        doAKOrganPlayNote(dsp, noteNumber, velocity, noteFrequency)
    }

    public func stopNote(noteNumber: UInt8, immediate: Bool) {
        doAKOrganStopNote(dsp, noteNumber, immediate)
    }

    public func sustainPedal(down: Bool) {
        doAKOrganSustainPedal(dsp, down)
    }

    override public func shouldClearOutputBuffer() -> Bool {
        return true
    }

}
