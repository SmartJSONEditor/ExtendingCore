//
//  ViewController.swift
//  MySynth
//
//  Created by Shane Dunne on 2019-01-12.
//  Copyright © 2019 AudioKit. All rights reserved.
//

import Cocoa
import AudioKit
import AudioKitUI

class ViewController: NSViewController, NSWindowDelegate {

    @IBOutlet private var plot: AKNodeOutputPlot!

    @IBOutlet weak var drawbar1: NSSlider!
    @IBOutlet weak var drawbar2: NSSlider!
    @IBOutlet weak var drawbar3: NSSlider!
    @IBOutlet weak var drawbar4: NSSlider!
    @IBOutlet weak var drawbar5: NSSlider!
    @IBOutlet weak var drawbar6: NSSlider!
    @IBOutlet weak var drawbar7: NSSlider!
    @IBOutlet weak var drawbar8: NSSlider!
    @IBOutlet weak var drawbar9: NSSlider!
    @IBOutlet weak var drawbar10: NSSlider!
    @IBOutlet weak var drawbar11: NSSlider!
    @IBOutlet weak var drawbar12: NSSlider!
    @IBOutlet weak var drawbar13: NSSlider!
    @IBOutlet weak var drawbar14: NSSlider!
    @IBOutlet weak var drawbar15: NSSlider!
    @IBOutlet weak var drawbar16: NSSlider!

    let conductor = Conductor.shared
    var isPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()

        conductor.midi.addListener(self)
        plot.node = conductor.plotout

        drawbar1.doubleValue = conductor.synth.drawbar1
        drawbar2.doubleValue = conductor.synth.drawbar2
        drawbar3.doubleValue = conductor.synth.drawbar3
        drawbar4.doubleValue = conductor.synth.drawbar4
        drawbar5.doubleValue = conductor.synth.drawbar5
        drawbar6.doubleValue = conductor.synth.drawbar6
        drawbar7.doubleValue = conductor.synth.drawbar7
        drawbar8.doubleValue = conductor.synth.drawbar8
        drawbar9.doubleValue = conductor.synth.drawbar9
        drawbar10.doubleValue = conductor.synth.drawbar10
        drawbar11.doubleValue = conductor.synth.drawbar11
        drawbar12.doubleValue = conductor.synth.drawbar12
        drawbar13.doubleValue = conductor.synth.drawbar13
        drawbar14.doubleValue = conductor.synth.drawbar14
        drawbar15.doubleValue = conductor.synth.drawbar15
        drawbar16.doubleValue = conductor.synth.drawbar16
    }

    override func viewDidAppear() {
        self.view.window?.delegate = self
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }

    @IBAction func drawbar1Changed(_ sender: NSSlider) {
        conductor.synth.drawbar1 = drawbar1.doubleValue
    }

    @IBAction func drawbar2Changed(_ sender: NSSlider) {
        conductor.synth.drawbar2 = drawbar2.doubleValue
    }

    @IBAction func drawbar3Changed(_ sender: NSSlider) {
        conductor.synth.drawbar3 = drawbar3.doubleValue
    }

    @IBAction func drawbar4Changed(_ sender: NSSlider) {
        conductor.synth.drawbar4 = drawbar4.doubleValue
    }

    @IBAction func drawbar5Changed(_ sender: NSSlider) {
        conductor.synth.drawbar5 = drawbar5.doubleValue
    }

    @IBAction func drawbar6Changed(_ sender: NSSlider) {
        conductor.synth.drawbar6 = drawbar6.doubleValue
    }

    @IBAction func drawbar7Changed(_ sender: NSSlider) {
        conductor.synth.drawbar7 = drawbar7.doubleValue
    }

    @IBAction func drawbar8Changed(_ sender: NSSlider) {
        conductor.synth.drawbar8 = drawbar8.doubleValue
    }

    @IBAction func drawbar9Changed(_ sender: NSSlider) {
        conductor.synth.drawbar9 = drawbar9.doubleValue
    }

    @IBAction func drawbar10Changed(_ sender: NSSlider) {
        conductor.synth.drawbar10 = drawbar10.doubleValue
    }

    @IBAction func drawbar11Changed(_ sender: NSSlider) {
        conductor.synth.drawbar11 = drawbar11.doubleValue
    }

    @IBAction func drawbar12Changed(_ sender: NSSlider) {
        conductor.synth.drawbar12 = drawbar12.doubleValue
    }

    @IBAction func drawbar13Changed(_ sender: NSSlider) {
        conductor.synth.drawbar13 = drawbar13.doubleValue
    }

    @IBAction func drawbar14Changed(_ sender: NSSlider) {
        conductor.synth.drawbar14 = drawbar14.doubleValue
    }

    @IBAction func drawbar15Changed(_ sender: NSSlider) {
        conductor.synth.drawbar15 = drawbar15.doubleValue
    }

    @IBAction func drawbar16Changed(_ sender: NSSlider) {
        conductor.synth.drawbar16 = drawbar16.doubleValue
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
