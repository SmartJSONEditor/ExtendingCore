//
//  AKOrgan.swift
//  AudioKit
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2019 AudioKit. All rights reserved.
//

import AudioKit

/// Organ
///
@objc open class AKOrgan: AKPolyphonicNode, AKComponent {
    public typealias AKAudioUnitType = AKOrganAudioUnit
    /// Four letter unique description of the node
    public static let ComponentDescription = AudioComponentDescription(instrument: "AKor")

    // MARK: - Properties

    @objc public var internalAU: AKAudioUnitType?
    private var token: AUParameterObserverToken?

    fileprivate var masterVolumeParameter: AUParameter?
    fileprivate var pitchBendParameter: AUParameter?
    fileprivate var vibratoDepthParameter: AUParameter?
    fileprivate var drawbar0Parameter: AUParameter?
    fileprivate var drawbar1Parameter: AUParameter?
    fileprivate var drawbar2Parameter: AUParameter?
    fileprivate var drawbar3Parameter: AUParameter?
    fileprivate var drawbar4Parameter: AUParameter?
    fileprivate var drawbar5Parameter: AUParameter?
    fileprivate var drawbar6Parameter: AUParameter?
    fileprivate var drawbar7Parameter: AUParameter?
    fileprivate var drawbar8Parameter: AUParameter?

    fileprivate var attackDurationParameter: AUParameter?
    fileprivate var decayDurationParameter: AUParameter?
    fileprivate var sustainLevelParameter: AUParameter?
    fileprivate var releaseDurationParameter: AUParameter?
    fileprivate var powerParameter: AUParameter?
    fileprivate var driveParameter: AUParameter?
    fileprivate var outputLevelParameter: AUParameter?
    fileprivate var leslieSpeedParameter: AUParameter?

    /// Ramp Duration represents the speed at which parameters are allowed to change
    @objc open dynamic var rampDuration: Double = AKSettings.rampDuration {
        willSet {
            internalAU?.rampDuration = newValue
        }
    }

    /// masterVolume   TODO: fix title
    @objc open dynamic var masterVolume: Double = 1.0 {
        willSet {
            guard masterVolume != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && masterVolumeParameter != nil {
                    masterVolumeParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.masterVolume = newValue
        }
    }

    /// pitchBend   TODO: fix title
    @objc open dynamic var pitchBend: Double = 2.0 {
        willSet {
            guard pitchBend != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && pitchBendParameter != nil {
                    pitchBendParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.pitchBend = newValue
        }
    }

    /// vibratoDepth   TODO: fix title
    @objc open dynamic var vibratoDepth: Double = 1.0 {
        willSet {
            guard vibratoDepth != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && vibratoDepthParameter != nil {
                    vibratoDepthParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.vibratoDepth = newValue
        }
    }

    /// drawbar0   TODO: fix title
    @objc open dynamic var drawbar0: Double = 0.0 {
        willSet {
            guard drawbar0 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar0Parameter != nil {
                    drawbar0Parameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar0 = newValue
        }
    }

    /// drawbar1   TODO: fix title
    @objc open dynamic var drawbar1: Double = 0.0 {
        willSet {
            guard drawbar1 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar1Parameter != nil {
                    drawbar1Parameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar1 = newValue
        }
    }

    /// drawbar2   TODO: fix title
    @objc open dynamic var drawbar2: Double = 1.0 {
        willSet {
            guard drawbar2 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar2Parameter != nil {
                    drawbar2Parameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar2 = newValue
        }
    }

    /// drawbar3   TODO: fix title
    @objc open dynamic var drawbar3: Double = 0.0 {
        willSet {
            guard drawbar3 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar3Parameter != nil {
                    drawbar3Parameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar3 = newValue
        }
    }

    /// drawbar4   TODO: fix title
    @objc open dynamic var drawbar4: Double = 0.0 {
        willSet {
            guard drawbar4 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar4Parameter != nil {
                    drawbar4Parameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar4 = newValue
        }
    }

    /// drawbar5   TODO: fix title
    @objc open dynamic var drawbar5: Double = 0.0 {
        willSet {
            guard drawbar5 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar5Parameter != nil {
                    drawbar5Parameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar5 = newValue
        }
    }

    /// drawbar6   TODO: fix title
    @objc open dynamic var drawbar6: Double = 0.0 {
        willSet {
            guard drawbar6 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar6Parameter != nil {
                    drawbar6Parameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar6 = newValue
        }
    }

    /// drawbar7   TODO: fix title
    @objc open dynamic var drawbar7: Double = 0.0 {
        willSet {
            guard drawbar7 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar7Parameter != nil {
                    drawbar7Parameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar7 = newValue
        }
    }

    /// drawbar8   TODO: fix title
    @objc open dynamic var drawbar8: Double = 0.0 {
        willSet {
            guard drawbar8 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar8Parameter != nil {
                    drawbar8Parameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar8 = newValue
        }
    }

    /// attackDuration   TODO: fix title
    @objc open dynamic var attackDuration: Double = 0.0 {
        willSet {
            guard attackDuration != newValue else { return }
            internalAU?.attackDuration = newValue
        }
    }

    /// decayDuration   TODO: fix title
    @objc open dynamic var decayDuration: Double = 0.0 {
        willSet {
            guard decayDuration != newValue else { return }
            internalAU?.decayDuration = newValue
        }
    }

    /// sustainLevel   TODO: fix title
    @objc open dynamic var sustainLevel: Double = 1.0 {
        willSet {
            guard sustainLevel != newValue else { return }
            internalAU?.sustainLevel = newValue
        }
    }

    /// releaseDuration   TODO: fix title
    @objc open dynamic var releaseDuration: Double = 0.0 {
        willSet {
            guard releaseDuration != newValue else { return }
            internalAU?.releaseDuration = newValue
        }
    }

    /// power   TODO: fix title
    @objc open dynamic var power: Double = 1.0 {
        willSet {
            guard power != newValue else { return }
            internalAU?.power = newValue
        }
    }

    /// drive   TODO: fix title
    @objc open dynamic var drive: Double = 1.0 {
        willSet {
            guard drive != newValue else { return }
            internalAU?.drive = newValue
        }
    }

    /// outputLevel   TODO: fix title
    @objc open dynamic var outputLevel: Double = 1.0 {
        willSet {
            guard outputLevel != newValue else { return }
            internalAU?.outputLevel = newValue
        }
    }

    /// leslieSpeed   TODO: fix title
    @objc open dynamic var leslieSpeed: Double = 4.0 {
        willSet {
            guard leslieSpeed != newValue else { return }
            internalAU?.leslieSpeed = newValue
        }
    }

    // MARK: - Initialization

    /// Initialize this Organ node
    ///
    /// - Parameters:
    ///   - masterVolume: 0.0 - 1.0, fraction
    ///   - pitchBend: -1000.0 - 1000.0, semitones, signed
    ///   - vibratoDepth: 0.0 - 1000.0, semitones, usually < 1.0
    ///   - drawbar0: 0.0 - 1.0, fraction
    ///   - drawbar1: 0.0 - 1.0, fraction
    ///   - drawbar2: 0.0 - 1.0, fraction
    ///   - drawbar3: 0.0 - 1.0, fraction
    ///   - drawbar4: 0.0 - 1.0, fraction
    ///   - drawbar5: 0.0 - 1.0, fraction
    ///   - drawbar6: 0.0 - 1.0, fraction
    ///   - drawbar7: 0.0 - 1.0, fraction
    ///   - drawbar8: 0.0 - 1.0, fraction
    ///   - attackDuration: 0.0 - 10.0, seconds
    ///   - decayDuration: 0.0 - 10.0, seconds
    ///   - sustainLevel: 0.0 - 1.0, fraction
    ///   - releaseDuration: 0.0 - 10.0, seconds
    ///   - power: 1.0 - 2.0, arbitrary, 1.0 - 2.0
    ///   - drive: 1.0 - 2.5, arbitrary, 1.0 - 2.5
    ///   - outputLevel: 1.0 - 2.5, arbitrary, 1.0 - 2.5
    ///   - leslieSpeed: 1.0 - 8.0, arbitrary, 1 .. 8
    ///
    @objc public init(
        masterVolume: Double = 1.0,
        pitchBend: Double = 2.0,
        vibratoDepth: Double = 1.0,
        drawbar0: Double = 0.0,
        drawbar1: Double = 0.0,
        drawbar2: Double = 1.0,
        drawbar3: Double = 0.0,
        drawbar4: Double = 0.0,
        drawbar5: Double = 0.0,
        drawbar6: Double = 0.0,
        drawbar7: Double = 0.0,
        drawbar8: Double = 0.0,
        attackDuration: Double = 0.0,
        decayDuration: Double = 0.0,
        sustainLevel: Double = 1.0,
        releaseDuration: Double = 0.0,
        power: Double = 1.0,
        drive: Double = 1.0,
        outputLevel: Double = 1.0,
        leslieSpeed: Double = 4.0 ) {

        self.masterVolume = masterVolume
        self.pitchBend = pitchBend
        self.vibratoDepth = vibratoDepth
        self.drawbar0 = drawbar0
        self.drawbar1 = drawbar1
        self.drawbar2 = drawbar2
        self.drawbar3 = drawbar3
        self.drawbar4 = drawbar4
        self.drawbar5 = drawbar5
        self.drawbar6 = drawbar6
        self.drawbar7 = drawbar7
        self.drawbar8 = drawbar8
        self.attackDuration = attackDuration
        self.decayDuration = decayDuration
        self.sustainLevel = sustainLevel
        self.releaseDuration = releaseDuration
        self.power = power
        self.drive = drive
        self.outputLevel = outputLevel
        self.leslieSpeed = leslieSpeed

        AKOrgan.register()

        super.init()

        AVAudioUnit._instantiate(with: AKOrgan.ComponentDescription) { [weak self] avAudioUnit in
            guard let strongSelf = self else {
                AKLog("Error: self is nil")
                return
            }
            strongSelf.avAudioUnit = avAudioUnit
            strongSelf.avAudioNode = avAudioUnit
            strongSelf.internalAU = avAudioUnit.auAudioUnit as? AKAudioUnitType
        }

        guard let tree = internalAU?.parameterTree else {
            AKLog("Parameter Tree Failed")
            return
        }

        self.masterVolumeParameter = tree["masterVolume"]
        self.pitchBendParameter = tree["pitchBend"]
        self.vibratoDepthParameter = tree["vibratoDepth"]
        self.drawbar0Parameter = tree["drawbar0"]
        self.drawbar1Parameter = tree["drawbar1"]
        self.drawbar2Parameter = tree["drawbar2"]
        self.drawbar3Parameter = tree["drawbar3"]
        self.drawbar4Parameter = tree["drawbar4"]
        self.drawbar5Parameter = tree["drawbar5"]
        self.drawbar6Parameter = tree["drawbar6"]
        self.drawbar7Parameter = tree["drawbar7"]
        self.drawbar8Parameter = tree["drawbar8"]
        self.attackDurationParameter = tree["attackDuration"]
        self.decayDurationParameter = tree["decayDuration"]
        self.sustainLevelParameter = tree["sustainLevel"]
        self.releaseDurationParameter = tree["releaseDuration"]
        self.powerParameter = tree["power"]
        self.driveParameter = tree["drive"]
        self.outputLevelParameter = tree["outputLevel"]
        self.leslieSpeedParameter = tree["leslieSpeed"]

        token = tree.token(byAddingParameterObserver: { [weak self] _, _ in
            guard self != nil else {
                AKLog("Unable to create strong reference to self")
                return
            } // Replace _ with strongSelf if needed
            DispatchQueue.main.async {
                // This node does not change its own values so we won't add any
                // value observing, but if you need to, this is where that goes.
            }
        })

        self.internalAU?.setParameterImmediately(.masterVolume, value: masterVolume)
        self.internalAU?.setParameterImmediately(.pitchBend, value: pitchBend)
        self.internalAU?.setParameterImmediately(.vibratoDepth, value: vibratoDepth)
        self.internalAU?.setParameterImmediately(.drawbar0, value: drawbar0)
        self.internalAU?.setParameterImmediately(.drawbar1, value: drawbar1)
        self.internalAU?.setParameterImmediately(.drawbar2, value: drawbar2)
        self.internalAU?.setParameterImmediately(.drawbar3, value: drawbar3)
        self.internalAU?.setParameterImmediately(.drawbar4, value: drawbar4)
        self.internalAU?.setParameterImmediately(.drawbar5, value: drawbar5)
        self.internalAU?.setParameterImmediately(.drawbar6, value: drawbar6)
        self.internalAU?.setParameterImmediately(.drawbar7, value: drawbar7)
        self.internalAU?.setParameterImmediately(.drawbar8, value: drawbar8)
        self.internalAU?.setParameterImmediately(.attackDuration, value: attackDuration)
        self.internalAU?.setParameterImmediately(.decayDuration, value: decayDuration)
        self.internalAU?.setParameterImmediately(.sustainLevel, value: sustainLevel)
        self.internalAU?.setParameterImmediately(.releaseDuration, value: releaseDuration)
        self.internalAU?.setParameterImmediately(.power, value: power)
        self.internalAU?.setParameterImmediately(.drive, value: drive)
        self.internalAU?.setParameterImmediately(.outputLevel, value: outputLevel)
        self.internalAU?.setParameterImmediately(.leslieSpeed, value: leslieSpeed)
    }

    @objc open override func play(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, frequency: Double) {
        internalAU?.playNote(noteNumber: noteNumber, velocity: velocity, noteFrequency: Float(frequency))
    }

    @objc open override func stop(noteNumber: MIDINoteNumber) {
        internalAU?.stopNote(noteNumber: noteNumber, immediate: false)
    }

    @objc open func silence(noteNumber: MIDINoteNumber) {
        internalAU?.stopNote(noteNumber: noteNumber, immediate: true)
    }

    @objc open func sustainPedal(pedalDown: Bool) {
        internalAU?.sustainPedal(down: pedalDown)
    }
}
