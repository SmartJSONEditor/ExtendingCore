//
//  ViewController.swift
//  AKOrgan-iOS
//
//  Created by Shane Dunne on 2019-01-24.
//  Copyright © 2019 AudioKit. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class ViewController: UIViewController {

    let conductor = Conductor.shared

    @IBOutlet weak var plot: AKNodeOutputPlot!

    @IBOutlet weak var drawbar0: UISlider!
    @IBOutlet weak var drawbar1: UISlider!
    @IBOutlet weak var drawbar2: UISlider!
    @IBOutlet weak var drawbar3: UISlider!
    @IBOutlet weak var drawbar4: UISlider!
    @IBOutlet weak var drawbar5: UISlider!
    @IBOutlet weak var drawbar6: UISlider!
    @IBOutlet weak var drawbar7: UISlider!
    @IBOutlet weak var drawbar8: UISlider!

    @IBOutlet weak var distortion: UISlider!
    @IBOutlet weak var drive: UISlider!
    @IBOutlet weak var output: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        conductor.midi.addListener(self)
        plot.node = conductor.plotout

        drawbar0.value = Float(conductor.organ.drawbar0)
        drawbar1.value = Float(conductor.organ.drawbar1)
        drawbar2.value = Float(conductor.organ.drawbar2)
        drawbar3.value = Float(conductor.organ.drawbar3)
        drawbar4.value = Float(conductor.organ.drawbar4)
        drawbar5.value = Float(conductor.organ.drawbar5)
        drawbar6.value = Float(conductor.organ.drawbar6)
        drawbar7.value = Float(conductor.organ.drawbar7)
        drawbar8.value = Float(conductor.organ.drawbar8)

        distortion.value = Float(conductor.organ.power)
        drive.value = Float(conductor.organ.drive)
        output.value = Float(conductor.organ.outputLevel)
    }

    @IBAction func drawbar0Changed(_ sender: UISlider) {
        conductor.organ.drawbar0 = Double(sender.value)
    }
    @IBAction func drawbar1Changed(_ sender: UISlider) {
        conductor.organ.drawbar1 = Double(sender.value)
    }
    @IBAction func drawbar2Changed(_ sender: UISlider) {
        conductor.organ.drawbar2 = Double(sender.value)
    }
    @IBAction func drawbar3Changed(_ sender: UISlider) {
        conductor.organ.drawbar3 = Double(sender.value)
    }
    @IBAction func drawbar4Changed(_ sender: UISlider) {
        conductor.organ.drawbar4 = Double(sender.value)
    }
    @IBAction func drawbar5Changed(_ sender: UISlider) {
        conductor.organ.drawbar5 = Double(sender.value)
    }
    @IBAction func drawbar6Changed(_ sender: UISlider) {
        conductor.organ.drawbar6 = Double(sender.value)
    }
    @IBAction func drawbar7Changed(_ sender: UISlider) {
        conductor.organ.drawbar7 = Double(sender.value)
    }
    @IBAction func drawbar8Changed(_ sender: UISlider) {
        conductor.organ.drawbar8 = Double(sender.value)
    }

    @IBAction func distortionChanged(_ sender: UISlider) {
        conductor.organ.power = Double(sender.value)
    }
    @IBAction func driveChanged(_ sender: UISlider) {
        conductor.organ.drive = Double(sender.value)
    }
    @IBAction func outputChanged(_ sender: UISlider) {
        conductor.organ.outputLevel = Double(sender.value)
    }

}

extension ViewController: AKMIDIListener {

    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        DispatchQueue.main.async {
            if (velocity == 0) {
                self.conductor.stopNote(note: noteNumber, channel: channel);
            } else {
                self.conductor.playNote(note: noteNumber, velocity: velocity, channel: channel)
            }
        }
    }

    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        DispatchQueue.main.async {
            self.conductor.stopNote(note: noteNumber, channel: channel)
        }
    }

    // MIDI Controller input
    func receivedMIDIController(_ controller: MIDIByte, value: MIDIByte, channel: MIDIChannel) {
        AKLog("Channel: \(channel + 1) controller: \(controller) value: \(value)")
        conductor.controller(controller, value: value)
    }

    // MIDI Pitch Wheel
    func receivedMIDIPitchWheel(_ pitchWheelValue: MIDIWord, channel: MIDIChannel) {
        conductor.pitchBend(pitchWheelValue)
    }

    // After touch
    func receivedMIDIAfterTouch(_ pressure: MIDIByte, channel: MIDIChannel) {
        conductor.afterTouch(pressure)
    }

    // MIDI Setup Change
    func receivedMIDISetupChange() {
        AKLog("midi setup change, midi.inputNames: \(conductor.midi.inputNames)")
        let inputNames = conductor.midi.inputNames
        inputNames.forEach { inputName in
            conductor.midi.openInput(inputName)
        }
    }

}
