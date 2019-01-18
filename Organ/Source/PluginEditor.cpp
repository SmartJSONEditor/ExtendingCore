#include "PluginProcessor.h"
#include "PluginEditor.h"

MyOrganAudioProcessorEditor::MyOrganAudioProcessorEditor (MyOrganAudioProcessor& p)
    : AudioProcessorEditor(&p)
    , processor(p)
    , drawBar0(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar1(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar2(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar3(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar4(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar5(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar6(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar7(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar8(Slider::LinearVertical, Slider::NoTextBox)
    , power(Slider::LinearHorizontal, Slider::NoTextBox)
    , drive(Slider::LinearHorizontal, Slider::NoTextBox)
    , gain(Slider::LinearHorizontal, Slider::NoTextBox)
{
    processor.addChangeListener(this);

    bar0Lbl.setText("16'", NotificationType::dontSendNotification);
    bar0Lbl.setJustificationType(Justification::centred);
    addAndMakeVisible(bar0Lbl);

    bar1Lbl.setText("5 1/3'", NotificationType::dontSendNotification);
    bar1Lbl.setJustificationType(Justification::centred);
    addAndMakeVisible(bar1Lbl);

    bar2Lbl.setText("8'", NotificationType::dontSendNotification);
    bar2Lbl.setJustificationType(Justification::centred);
    addAndMakeVisible(bar2Lbl);

    bar3Lbl.setText("4'", NotificationType::dontSendNotification);
    bar3Lbl.setJustificationType(Justification::centred);
    addAndMakeVisible(bar3Lbl);

    bar4Lbl.setText("2 2/3'", NotificationType::dontSendNotification);
    bar4Lbl.setJustificationType(Justification::centred);
    addAndMakeVisible(bar4Lbl);

    bar5Lbl.setText("2'", NotificationType::dontSendNotification);
    bar5Lbl.setJustificationType(Justification::centred);
    addAndMakeVisible(bar5Lbl);

    bar6Lbl.setText("1 3/5'", NotificationType::dontSendNotification);
    bar6Lbl.setJustificationType(Justification::centred);
    addAndMakeVisible(bar6Lbl);

    bar7Lbl.setText("1 1/3'", NotificationType::dontSendNotification);
    bar7Lbl.setJustificationType(Justification::centred);
    addAndMakeVisible(bar7Lbl);

    bar8Lbl.setText("1'", NotificationType::dontSendNotification);
    bar8Lbl.setJustificationType(Justification::centred);
    addAndMakeVisible(bar8Lbl);

    powerLbl.setText("Power", NotificationType::dontSendNotification);
    powerLbl.setJustificationType(Justification::right);
    addAndMakeVisible(powerLbl);

    driveLbl.setText("Drive", NotificationType::dontSendNotification);
    driveLbl.setJustificationType(Justification::right);
    addAndMakeVisible(driveLbl);

    gainLbl.setText("Volume", NotificationType::dontSendNotification);
    gainLbl.setJustificationType(Justification::right);
    addAndMakeVisible(gainLbl);

    drawBar0.setRange(0.0, 1.0);
    drawBar0.setValue(processor.synth.getDrawBar(0));
    drawBar0.onValueChange = [this] {
        processor.synth.setDrawBar(0, float(drawBar0.getValue()));
    };
    addAndMakeVisible(drawBar0);

    drawBar1.setRange(0.0, 1.0);
    drawBar1.setValue(processor.synth.getDrawBar(1));
    drawBar1.onValueChange = [this] {
        processor.synth.setDrawBar(1, float(drawBar1.getValue()));
    };
    addAndMakeVisible(drawBar1);

    drawBar2.setRange(0.0, 1.0);
    drawBar2.setValue(processor.synth.getDrawBar(2));
    drawBar2.onValueChange = [this] {
        processor.synth.setDrawBar(2, float(drawBar2.getValue()));
    };
    addAndMakeVisible(drawBar2);

    drawBar3.setRange(0.0, 1.0);
    drawBar3.setValue(processor.synth.getDrawBar(3));
    drawBar3.onValueChange = [this] {
        processor.synth.setDrawBar(3, float(drawBar3.getValue()));
    };
    addAndMakeVisible(drawBar3);

    drawBar4.setRange(0.0, 1.0);
    drawBar4.setValue(processor.synth.getDrawBar(4));
    drawBar4.onValueChange = [this] {
        processor.synth.setDrawBar(4, float(drawBar4.getValue()));
    };
    addAndMakeVisible(drawBar4);

    drawBar5.setRange(0.0, 1.0);
    drawBar5.setValue(processor.synth.getDrawBar(5));
    drawBar5.onValueChange = [this] {
        processor.synth.setDrawBar(5, float(drawBar5.getValue()));
    };
    addAndMakeVisible(drawBar5);

    drawBar6.setRange(0.0, 1.0);
    drawBar6.setValue(processor.synth.getDrawBar(6));
    drawBar6.onValueChange = [this] {
        processor.synth.setDrawBar(6, float(drawBar6.getValue()));
    };
    addAndMakeVisible(drawBar6);

    drawBar7.setRange(0.0, 1.0);
    drawBar7.setValue(processor.synth.getDrawBar(7));
    drawBar7.onValueChange = [this] {
        processor.synth.setDrawBar(7, float(drawBar7.getValue()));
    };
    addAndMakeVisible(drawBar7);

    drawBar8.setRange(0.0, 1.0);
    drawBar8.setValue(processor.synth.getDrawBar(8));
    drawBar8.onValueChange = [this] {
        processor.synth.setDrawBar(8, float(drawBar8.getValue()));
    };
    addAndMakeVisible(drawBar8);

    power.setRange(1.0, 2.0);
    power.setValue(processor.distortion.getPower());
    power.onValueChange = [this] {
        processor.distortion.setPower(float(power.getValue()));
    };
    addAndMakeVisible(power);

    drive.setRange(1.0, 2.5);
    drive.setValue(processor.distortion.getDrive());
    drive.onValueChange = [this] {
        processor.distortion.setDrive(float(drive.getValue()));
    };
    addAndMakeVisible(drive);

    gain.setRange(1.0, 2.5);
    gain.setValue(processor.distortion.getGain());
    gain.onValueChange = [this] {
        processor.distortion.setGain(float(gain.getValue()));
    };
    addAndMakeVisible(gain);

    setSize (400, 360);
}

MyOrganAudioProcessorEditor::~MyOrganAudioProcessorEditor()
{
}

void MyOrganAudioProcessorEditor::paint (Graphics& g)
{
    // (Our component is opaque, so we must completely fill the background with a solid colour)
    g.fillAll (getLookAndFeel().findColour (ResizableWindow::backgroundColourId));
}

void MyOrganAudioProcessorEditor::resized()
{
    auto area = getLocalBounds().reduced(20);

    auto barsArea = area.removeFromTop(200);
    int drawBarWidth = barsArea.getWidth() / 9;
    auto column = barsArea.removeFromLeft(drawBarWidth);
    bar0Lbl.setBounds(column.removeFromBottom(20));
    drawBar0.setBounds(column);
    column = barsArea.removeFromLeft(drawBarWidth);
    bar1Lbl.setBounds(column.removeFromBottom(20));
    drawBar1.setBounds(column);
    column = barsArea.removeFromLeft(drawBarWidth);
    bar2Lbl.setBounds(column.removeFromBottom(20));
    drawBar2.setBounds(column);
    column = barsArea.removeFromLeft(drawBarWidth);
    bar3Lbl.setBounds(column.removeFromBottom(20));
    drawBar3.setBounds(column);
    column = barsArea.removeFromLeft(drawBarWidth);
    bar4Lbl.setBounds(column.removeFromBottom(20));
    drawBar4.setBounds(column);
    column = barsArea.removeFromLeft(drawBarWidth);
    bar5Lbl.setBounds(column.removeFromBottom(20));
    drawBar5.setBounds(column);
    column = barsArea.removeFromLeft(drawBarWidth);
    bar6Lbl.setBounds(column.removeFromBottom(20));
    drawBar6.setBounds(column);
    column = barsArea.removeFromLeft(drawBarWidth);
    bar7Lbl.setBounds(column.removeFromBottom(20));
    drawBar7.setBounds(column);
    column = barsArea.removeFromLeft(drawBarWidth);
    bar8Lbl.setBounds(column.removeFromBottom(20));
    drawBar8.setBounds(column);

    area.removeFromTop(20);

    auto row = area.removeFromTop(20);
    powerLbl.setBounds(row.removeFromLeft(60));
    power.setBounds(row);
    area.removeFromTop(15);

    row = area.removeFromTop(20);
    driveLbl.setBounds(row.removeFromLeft(60));
    drive.setBounds(row);
    area.removeFromTop(15);
    
    row = area.removeFromTop(20);
    gainLbl.setBounds(row.removeFromLeft(60));
    gain.setBounds(row);
}

void MyOrganAudioProcessorEditor::changeListenerCallback(ChangeBroadcaster*)
{
    drawBar0.setValue(processor.synth.getDrawBar(0));
    drawBar1.setValue(processor.synth.getDrawBar(1));
    drawBar2.setValue(processor.synth.getDrawBar(2));
    drawBar3.setValue(processor.synth.getDrawBar(3));
    drawBar4.setValue(processor.synth.getDrawBar(4));
    drawBar5.setValue(processor.synth.getDrawBar(5));
    drawBar6.setValue(processor.synth.getDrawBar(6));
    drawBar7.setValue(processor.synth.getDrawBar(7));
    drawBar8.setValue(processor.synth.getDrawBar(8));
    power.setValue(processor.distortion.getPower());
    drive.setValue(processor.distortion.getDrive());
    gain.setValue(processor.distortion.getGain());
}
