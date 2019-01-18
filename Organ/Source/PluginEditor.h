#pragma once

#include "JuceHeader.h"
#include "PluginProcessor.h"

class MyOrganAudioProcessorEditor : public AudioProcessorEditor,
                                    public ChangeListener
{
public:
    MyOrganAudioProcessorEditor (MyOrganAudioProcessor&);
    ~MyOrganAudioProcessorEditor();

    void paint (Graphics&) override;
    void resized() override;

    void changeListenerCallback(ChangeBroadcaster*) override;

private:
    MyOrganAudioProcessor& processor;

    Slider drawBar0, drawBar1, drawBar2, drawBar3, drawBar4, drawBar5, drawBar6, drawBar7, drawBar8;
    Label bar0Lbl, bar1Lbl, bar2Lbl, bar3Lbl, bar4Lbl, bar5Lbl, bar6Lbl, bar7Lbl, bar8Lbl;
    Slider power, drive, gain;
    Label powerLbl, driveLbl, gainLbl;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (MyOrganAudioProcessorEditor)
};
