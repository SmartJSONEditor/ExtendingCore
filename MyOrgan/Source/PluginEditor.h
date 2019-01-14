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

    Slider masterVolume;
    Slider drawBar0, drawBar1, drawBar2, drawBar3, drawBar4, drawBar5, drawBar6, drawBar7, drawBar8;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (MyOrganAudioProcessorEditor)
};
