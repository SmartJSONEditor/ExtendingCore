//
//  ViewController.swift
//  AKOrgan
//
//  Created by Shane Dunne on 2019-01-18.
//  Copyright © 2019 AudioKit. All rights reserved.
//

import Cocoa
import AudioKit
import AudioKitUI

class ViewController: NSViewController, NSWindowDelegate {

    let conductor = Conductor.shared

    @IBOutlet weak var plot: AKNodeOutputPlot!

    @IBOutlet weak var drawbar0: NSSlider!
    @IBOutlet weak var drawbar1: NSSlider!
    @IBOutlet weak var drawbar2: NSSlider!
    @IBOutlet weak var drawbar3: NSSlider!
    @IBOutlet weak var drawbar4: NSSlider!
    @IBOutlet weak var drawbar5: NSSlider!
    @IBOutlet weak var drawbar6: NSSlider!
    @IBOutlet weak var drawbar7: NSSlider!
    @IBOutlet weak var drawbar8: NSSlider!

    @IBOutlet weak var distortion: NSSlider!
    @IBOutlet weak var drive: NSSlider!
    @IBOutlet weak var output: NSSlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        conductor.midi.addListener(self)
        plot.node = conductor.plotout

        drawbar0.doubleValue = conductor.organ.drawbar0
        drawbar1.doubleValue = conductor.organ.drawbar1
        drawbar2.doubleValue = conductor.organ.drawbar2
        drawbar3.doubleValue = conductor.organ.drawbar3
        drawbar4.doubleValue = conductor.organ.drawbar4
        drawbar5.doubleValue = conductor.organ.drawbar5
        drawbar6.doubleValue = conductor.organ.drawbar6
        drawbar7.doubleValue = conductor.organ.drawbar7
        drawbar8.doubleValue = conductor.organ.drawbar8

        distortion.doubleValue = conductor.organ.power
        drive.doubleValue = conductor.organ.drive
        output.doubleValue = conductor.organ.outputLevel
    }

    override func viewDidAppear() {
        self.view.window?.delegate = self
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }

    @IBAction func drawbar0Changed(_ sender: NSSlider) {
        conductor.organ.drawbar0 = sender.doubleValue
    }
    @IBAction func drawbar1Changed(_ sender: NSSlider) {
        conductor.organ.drawbar1 = sender.doubleValue
    }
    @IBAction func drawbar2Changed(_ sender: NSSlider) {
        conductor.organ.drawbar2 = sender.doubleValue
    }
    @IBAction func drawbar3Changed(_ sender: NSSlider) {
        conductor.organ.drawbar3 = sender.doubleValue
    }
    @IBAction func drawbar4Changed(_ sender: NSSlider) {
        conductor.organ.drawbar4 = sender.doubleValue
    }
    @IBAction func drawbar5Changed(_ sender: NSSlider) {
        conductor.organ.drawbar5 = sender.doubleValue
    }
    @IBAction func drawbar6Changed(_ sender: NSSlider) {
        conductor.organ.drawbar6 = sender.doubleValue
    }
    @IBAction func drawbar7Changed(_ sender: NSSlider) {
        conductor.organ.drawbar7 = sender.doubleValue
    }
    @IBAction func drawbar8Changed(_ sender: NSSlider) {
        conductor.organ.drawbar8 = sender.doubleValue
    }

    @IBAction func distortionChanged(_ sender: NSSlider) {
        conductor.organ.power = sender.doubleValue
    }
    @IBAction func driveChanged(_ sender: NSSlider) {
        conductor.organ.drive = sender.doubleValue
    }
    @IBAction func outputChanged(_ sender: NSSlider) {
        conductor.organ.outputLevel = sender.doubleValue
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
