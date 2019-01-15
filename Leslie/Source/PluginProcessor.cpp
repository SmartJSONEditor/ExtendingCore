/*
  ==============================================================================

    This file was auto-generated!

    It contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
LeslieAudioProcessor::LeslieAudioProcessor()
#ifndef JucePlugin_PreferredChannelConfigurations
     : AudioProcessor (BusesProperties()
                     #if ! JucePlugin_IsMidiEffect
                      #if ! JucePlugin_IsSynth
                       .withInput  ("Input",  AudioChannelSet::stereo(), true)
                      #endif
                       .withOutput ("Output", AudioChannelSet::stereo(), true)
                     #endif
                       )
#endif
{
}

LeslieAudioProcessor::~LeslieAudioProcessor()
{
}

//==============================================================================
const String LeslieAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

bool LeslieAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool LeslieAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

bool LeslieAudioProcessor::isMidiEffect() const
{
   #if JucePlugin_IsMidiEffect
    return true;
   #else
    return false;
   #endif
}

double LeslieAudioProcessor::getTailLengthSeconds() const
{
    return 0.0;
}

int LeslieAudioProcessor::getNumPrograms()
{
    return 1;   // NB: some hosts don't cope very well if you tell them there are 0 programs,
                // so this should be at least 1, even if you're not really implementing programs.
}

int LeslieAudioProcessor::getCurrentProgram()
{
    return 0;
}

void LeslieAudioProcessor::setCurrentProgram (int)
{
}

const String LeslieAudioProcessor::getProgramName (int)
{
    return {};
}

void LeslieAudioProcessor::changeProgramName (int, const String&)
{
}

//==============================================================================
void LeslieAudioProcessor::prepareToPlay (double sampleRate, int)
{
    leslie.init(sampleRate);
}

void LeslieAudioProcessor::releaseResources()
{
    leslie.deinit();
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool LeslieAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
{
  #if JucePlugin_IsMidiEffect
    ignoreUnused (layouts);
    return true;
  #else
    // This is the place where you check if the layout is supported.
    // In this template code we only support mono or stereo.
    if (layouts.getMainOutputChannelSet() != AudioChannelSet::mono()
     && layouts.getMainOutputChannelSet() != AudioChannelSet::stereo())
        return false;

    // This checks if the input layout matches the output layout
   #if ! JucePlugin_IsSynth
    if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
        return false;
   #endif

    return true;
  #endif
}
#endif

void LeslieAudioProcessor::processBlock (AudioBuffer<float>& buffer, MidiBuffer& midiMessages)
{
    ScopedNoDenormals noDenormals;

    const float *inBuffers[2] = { buffer.getReadPointer(0), buffer.getReadPointer(1) };
    float* outBuffers[2] = { buffer.getWritePointer(0), buffer.getWritePointer(1) };

    MidiBuffer::Iterator it(midiMessages);
    MidiMessage msg;
    int samplePos;
    while (it.getNextEvent(msg, samplePos))
    {
        if (msg.isSustainPedalOn())
        {
            leslie.setSpeed(8.0f);
        }
        else if (msg.isSustainPedalOff())
        {
            leslie.setSpeed(4.0f);
        }
    }
    midiMessages.clear(0, buffer.getNumSamples());

    leslie.render(buffer.getNumSamples(), inBuffers, outBuffers);
}

//==============================================================================
bool LeslieAudioProcessor::hasEditor() const
{
    return true; // (change this to false if you choose to not supply an editor)
}

AudioProcessorEditor* LeslieAudioProcessor::createEditor()
{
    return new LeslieAudioProcessorEditor (*this);
}

//==============================================================================
void LeslieAudioProcessor::getStateInformation (MemoryBlock& destData)
{
    destData.setSize(1);    // for VSTHost
}

void LeslieAudioProcessor::setStateInformation (const void*, int)
{
}

//==============================================================================
// This creates new instances of the plugin..
AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new LeslieAudioProcessor();
}
