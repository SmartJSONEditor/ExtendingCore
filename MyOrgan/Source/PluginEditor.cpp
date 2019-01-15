#include "PluginProcessor.h"
#include "PluginEditor.h"

MyOrganAudioProcessorEditor::MyOrganAudioProcessorEditor (MyOrganAudioProcessor& p)
    : AudioProcessorEditor(&p)
    , processor(p)
    , masterVolume(Slider::LinearHorizontal, Slider::NoTextBox)
    , drawBar0(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar1(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar2(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar3(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar4(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar5(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar6(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar7(Slider::LinearVertical, Slider::NoTextBox)
    , drawBar8(Slider::LinearVertical, Slider::NoTextBox)
{
    processor.addChangeListener(this);

    masterVolume.setRange(0.0, 1.0);
    masterVolume.setValue(processor.synth.getMasterVolume());
    masterVolume.onValueChange = [this] {
        processor.synth.setMasterVolume(float(masterVolume.getValue()));
    };
    addAndMakeVisible(masterVolume);

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

    setSize (400, 300);
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
    masterVolume.setBounds(area.removeFromTop(20));
    area.removeFromTop(20);
    int drawBarWidth = area.getWidth() / 9;
    drawBar0.setBounds(area.removeFromLeft(drawBarWidth));
    drawBar1.setBounds(area.removeFromLeft(drawBarWidth));
    drawBar2.setBounds(area.removeFromLeft(drawBarWidth));
    drawBar3.setBounds(area.removeFromLeft(drawBarWidth));
    drawBar4.setBounds(area.removeFromLeft(drawBarWidth));
    drawBar5.setBounds(area.removeFromLeft(drawBarWidth));
    drawBar6.setBounds(area.removeFromLeft(drawBarWidth));
    drawBar7.setBounds(area.removeFromLeft(drawBarWidth));
    drawBar8.setBounds(area.removeFromLeft(drawBarWidth));
}

void MyOrganAudioProcessorEditor::changeListenerCallback(ChangeBroadcaster*)
{
    masterVolume.setValue(processor.synth.getMasterVolume());
    drawBar0.setValue(processor.synth.getDrawBar(0));
    drawBar1.setValue(processor.synth.getDrawBar(1));
    drawBar2.setValue(processor.synth.getDrawBar(2));
    drawBar3.setValue(processor.synth.getDrawBar(3));
    drawBar4.setValue(processor.synth.getDrawBar(4));
    drawBar5.setValue(processor.synth.getDrawBar(5));
    drawBar6.setValue(processor.synth.getDrawBar(6));
    drawBar7.setValue(processor.synth.getDrawBar(7));
    drawBar8.setValue(processor.synth.getDrawBar(8));
}
