#include "PluginProcessor.h"
#include "PluginEditor.h"

MyOrganAudioProcessor::MyOrganAudioProcessor()
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

MyOrganAudioProcessor::~MyOrganAudioProcessor()
{
}

const String MyOrganAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

bool MyOrganAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool MyOrganAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

bool MyOrganAudioProcessor::isMidiEffect() const
{
   #if JucePlugin_IsMidiEffect
    return true;
   #else
    return false;
   #endif
}

double MyOrganAudioProcessor::getTailLengthSeconds() const
{
    return 0.0;
}

int MyOrganAudioProcessor::getNumPrograms()
{
    return 1;
}

int MyOrganAudioProcessor::getCurrentProgram()
{
    return 0;
}

void MyOrganAudioProcessor::setCurrentProgram (int index)
{
}

const String MyOrganAudioProcessor::getProgramName (int index)
{
    return {};
}

void MyOrganAudioProcessor::changeProgramName (int index, const String& newName)
{
}

void MyOrganAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
    synth.init(sampleRate);
}

void MyOrganAudioProcessor::releaseResources()
{
    synth.deinit();
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool MyOrganAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
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

void MyOrganAudioProcessor::processBlock (AudioBuffer<float>& buffer, MidiBuffer& midiMessages)
{
    ScopedNoDenormals noDenormals;
    float* outBuffers[2] = { buffer.getWritePointer(0), buffer.getWritePointer(1) };

    MidiBuffer::Iterator it(midiMessages);
    MidiMessage msg;
    int samplePos;
    while (it.getNextEvent(msg, samplePos))
    {
        if (msg.isNoteOn())
        {
            int nn = msg.getNoteNumber();
            int vel = msg.getVelocity();
            float freq = float(msg.getMidiNoteInHertz(nn));
            synth.playNote(nn, vel, freq);
        }
        else if (msg.isNoteOff())
        {
            int nn = msg.getNoteNumber();
            synth.stopNote(nn, false);
        }
        else if (msg.isSustainPedalOn())
        {
            synth.sustainPedal(true);
        }
        else if (msg.isSustainPedalOff())
        {
            synth.sustainPedal(false);
        }
        else if (msg.isPitchWheel())
        {
            float pw = (msg.getPitchWheelValue() - 8192) / 8192.0f;
            synth.setPitchOffset(2.0f * pw);
        }
        else if (msg.isControllerOfType(1))
        {
            float cv = msg.getControllerValue() / 127.0f;
            synth.setVibratoDepth(cv);
        }
        else if (msg.isController())
        {
            int cn = msg.getControllerNumber();
            if (cn >= 16 && cn <= 24)
            {
                float cv = msg.getControllerValue() / 127.0f;
                synth.setDrawBar(cn - 16, cv);
            }
        }
    }
    midiMessages.clear(0, buffer.getNumSamples());

    int chunkSize = AKSYNTH_CHUNKSIZE;
    int channelCount = buffer.getNumChannels();
    int samplesRemaining = buffer.getNumSamples();
    while (samplesRemaining)
    {
        if (samplesRemaining < chunkSize) chunkSize = samplesRemaining;
        synth.render(channelCount, chunkSize, outBuffers);
        samplesRemaining -= chunkSize;
        outBuffers[0] += chunkSize;
        outBuffers[1] += chunkSize;
    }
}

bool MyOrganAudioProcessor::hasEditor() const
{
    return true; // (change this to false if you choose to not supply an editor)
}

AudioProcessorEditor* MyOrganAudioProcessor::createEditor()
{
    return new MyOrganAudioProcessorEditor (*this);
}

void MyOrganAudioProcessor::getStateInformation (MemoryBlock& destData)
{
    // You should use this method to store your parameters in the memory block.
    // You could do that either as raw data, or use the XML or ValueTree classes
    // as intermediaries to make it easy to save and load complex data.
}

void MyOrganAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    // You should use this method to restore your parameters from this memory block,
    // whose contents will have been created by the getStateInformation() call.
}

AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new MyOrganAudioProcessor();
}
