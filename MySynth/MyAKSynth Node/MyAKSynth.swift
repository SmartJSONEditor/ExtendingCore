//
//  MyAKSynth.swift
//  AudioKit
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2019 AudioKit. All rights reserved.
//

import AudioKit

/// Synth
///
@objc open class MyAKSynth: AKPolyphonicNode, AKComponent {
    public typealias AKAudioUnitType = MyAKSynthAudioUnit
    /// Four letter unique description of the node
    public static let ComponentDescription = AudioComponentDescription(instrument: "AKsy")

    // MARK: - Properties

    @objc public var internalAU: AKAudioUnitType?
    private var token: AUParameterObserverToken?

    fileprivate var masterVolumeParameter: AUParameter?
    fileprivate var pitchBendParameter: AUParameter?
    fileprivate var vibratoDepthParameter: AUParameter?

    fileprivate var drawbar1LevelParameter: AUParameter?
    fileprivate var drawbar2LevelParameter: AUParameter?
    fileprivate var drawbar3LevelParameter: AUParameter?
    fileprivate var drawbar4LevelParameter: AUParameter?
    fileprivate var drawbar5LevelParameter: AUParameter?
    fileprivate var drawbar6LevelParameter: AUParameter?
    fileprivate var drawbar7LevelParameter: AUParameter?
    fileprivate var drawbar8LevelParameter: AUParameter?
    fileprivate var drawbar9LevelParameter: AUParameter?
    fileprivate var drawbar10LevelParameter: AUParameter?
    fileprivate var drawbar11LevelParameter: AUParameter?
    fileprivate var drawbar12LevelParameter: AUParameter?
    fileprivate var drawbar13LevelParameter: AUParameter?
    fileprivate var drawbar14LevelParameter: AUParameter?
    fileprivate var drawbar15LevelParameter: AUParameter?
    fileprivate var drawbar16LevelParameter: AUParameter?

    fileprivate var attackDurationParameter: AUParameter?
    fileprivate var decayDurationParameter: AUParameter?
    fileprivate var sustainLevelParameter: AUParameter?
    fileprivate var releaseDurationParameter: AUParameter?

    /// Ramp Duration represents the speed at which parameters are allowed to change
    @objc open dynamic var rampDuration: Double = AKSettings.rampDuration {
        willSet {
            internalAU?.rampDuration = newValue
        }
    }

    /// Master volume (fraction)
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

    /// Pitch offset (semitones)
    @objc open dynamic var pitchBend: Double = 0.0 {
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

    /// Vibrato amount (semitones)
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

    /// Drawbar 1 level (fraction)
    @objc open dynamic var drawbar1: Double = 1.0 {
        willSet {
            guard drawbar1 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar1LevelParameter != nil {
                    drawbar1LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar1 = newValue
        }
    }

    /// Drawbar 2 level (fraction)
    @objc open dynamic var drawbar2: Double = 0.0 {
        willSet {
            guard drawbar2 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar2LevelParameter != nil {
                    drawbar2LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar2 = newValue
        }
    }

    /// Drawbar 3 level (fraction)
    @objc open dynamic var drawbar3: Double = 0.0 {
        willSet {
            guard drawbar3 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar3LevelParameter != nil {
                    drawbar3LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar3 = newValue
        }
    }

    /// Drawbar 4 level (fraction)
    @objc open dynamic var drawbar4: Double = 0.0 {
        willSet {
            guard drawbar4 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar4LevelParameter != nil {
                    drawbar4LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar4 = newValue
        }
    }

    /// Drawbar 5 level (fraction)
    @objc open dynamic var drawbar5: Double = 0.0 {
        willSet {
            guard drawbar5 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar5LevelParameter != nil {
                    drawbar5LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar5 = newValue
        }
    }

    /// Drawbar 6 level (fraction)
    @objc open dynamic var drawbar6: Double = 0.0 {
        willSet {
            guard drawbar6 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar6LevelParameter != nil {
                    drawbar6LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar6 = newValue
        }
    }

    /// Drawbar 7 level (fraction)
    @objc open dynamic var drawbar7: Double = 0.0 {
        willSet {
            guard drawbar7 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar7LevelParameter != nil {
                    drawbar7LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar7 = newValue
        }
    }

    /// Drawbar 8 level (fraction)
    @objc open dynamic var drawbar8: Double = 0.0 {
        willSet {
            guard drawbar8 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar8LevelParameter != nil {
                    drawbar8LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar8 = newValue
        }
    }

    /// Drawbar 9 level (fraction)
    @objc open dynamic var drawbar9: Double = 0.0 {
        willSet {
            guard drawbar9 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar9LevelParameter != nil {
                    drawbar9LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar9 = newValue
        }
    }

    /// Drawbar 10 level (fraction)
    @objc open dynamic var drawbar10: Double = 0.0 {
        willSet {
            guard drawbar10 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar10LevelParameter != nil {
                    drawbar10LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar10 = newValue
        }
    }

    /// Drawbar 11 level (fraction)
    @objc open dynamic var drawbar11: Double = 0.0 {
        willSet {
            guard drawbar11 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar11LevelParameter != nil {
                    drawbar11LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar11 = newValue
        }
    }

    /// Drawbar 12 level (fraction)
    @objc open dynamic var drawbar12: Double = 0.0 {
        willSet {
            guard drawbar12 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar12LevelParameter != nil {
                    drawbar12LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar12 = newValue
        }
    }

    /// Drawbar 13 level (fraction)
    @objc open dynamic var drawbar13: Double = 0.0 {
        willSet {
            guard drawbar13 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar13LevelParameter != nil {
                    drawbar13LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar13 = newValue
        }
    }

    /// Drawbar 14 level (fraction)
    @objc open dynamic var drawbar14: Double = 0.0 {
        willSet {
            guard drawbar14 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar14LevelParameter != nil {
                    drawbar14LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar14 = newValue
        }
    }

    /// Drawbar 15 level (fraction)
    @objc open dynamic var drawbar15: Double = 0.0 {
        willSet {
            guard drawbar15 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar15LevelParameter != nil {
                    drawbar15LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar15 = newValue
        }
    }

    /// Drawbar 16 level (fraction)
    @objc open dynamic var drawbar16: Double = 0.0 {
        willSet {
            guard drawbar16 != newValue else { return }

            if internalAU?.isSetUp ?? false {
                if token != nil && drawbar16LevelParameter != nil {
                    drawbar16LevelParameter?.setValue(Float(newValue), originator: token!)
                    return
                }
            }

            internalAU?.drawbar16 = newValue
        }
    }

    /// Amplitude attack duration (seconds)
    @objc open dynamic var attackDuration: Double = 0.0 {
        willSet {
            guard attackDuration != newValue else { return }
            internalAU?.attackDuration = newValue
        }
    }

    /// Amplitude Decay duration (seconds)
    @objc open dynamic var decayDuration: Double = 0.0 {
        willSet {
            guard decayDuration != newValue else { return }
            internalAU?.decayDuration = newValue
        }
    }

    /// Amplitude sustain level (fraction)
    @objc open dynamic var sustainLevel: Double = 1.0 {
        willSet {
            guard sustainLevel != newValue else { return }
            internalAU?.sustainLevel = newValue
        }
    }

    /// Amplitude Release duration (seconds)
    @objc open dynamic var releaseDuration: Double = 0.0 {
        willSet {
            guard releaseDuration != newValue else { return }
            internalAU?.releaseDuration = newValue
        }
    }

    // MARK: - Initialization

    /// Initialize this synth node
    ///
    /// - Parameters:
    ///   - masterVolume: 0.0 - 1.0
    ///   - pitchBend: semitones, signed
    ///   - vibratoDepth: semitones, typically less than 1.0
    ///   - attackDuration: seconds, 0.0 - 10.0
    ///   - decayDuration: seconds, 0.0 - 10.0
    ///   - sustainLevel: 0.0 - 1.0
    ///   - releaseDuration: seconds, 0.0 - 10.0
    ///
    @objc public init(
        masterVolume: Double = 1.0,
        pitchBend: Double = 0.0,
        vibratoDepth: Double = 0.0,
        attackDuration: Double = 0.0,
        decayDuration: Double = 0.0,
        sustainLevel: Double = 1.0,
        releaseDuration: Double = 0.0) {

        self.masterVolume = masterVolume
        self.pitchBend = pitchBend
        self.vibratoDepth = vibratoDepth
        self.attackDuration = attackDuration
        self.decayDuration = decayDuration
        self.sustainLevel = sustainLevel
        self.releaseDuration = releaseDuration

        MyAKSynth.register()

        super.init()

        AVAudioUnit._instantiate(with: MyAKSynth.ComponentDescription) { [weak self] avAudioUnit in
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
        self.attackDurationParameter = tree["attackDuration"]
        self.decayDurationParameter = tree["decayDuration"]
        self.sustainLevelParameter = tree["sustainLevel"]
        self.releaseDurationParameter = tree["releaseDuration"]

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
        self.internalAU?.setParameterImmediately(.attackDuration, value: attackDuration)
        self.internalAU?.setParameterImmediately(.decayDuration, value: decayDuration)
        self.internalAU?.setParameterImmediately(.sustainLevel, value: sustainLevel)
        self.internalAU?.setParameterImmediately(.releaseDuration, value: releaseDuration)
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
