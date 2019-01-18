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
    workBuf[0] = workBuf[1] = nullptr;

    distortion.init(512);
}

MyOrganAudioProcessor::~MyOrganAudioProcessor()
{
    distortion.deinit();
    if (workBuf[0]) delete workBuf[0];
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

void MyOrganAudioProcessor::setCurrentProgram (int)
{
}

const String MyOrganAudioProcessor::getProgramName (int)
{
    return {};
}

void MyOrganAudioProcessor::changeProgramName (int, const String&)
{
}

void MyOrganAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
    synth.init(sampleRate);
    leslie.init(sampleRate);

    if (workBuf[0]) delete workBuf[0];
    workBuf[0] = new float[2 * samplesPerBlock];
    workBuf[1] = workBuf[0] + samplesPerBlock;
}

void MyOrganAudioProcessor::releaseResources()
{
    synth.deinit();
    leslie.deinit();
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
    float* workBuffers[2] = { workBuf[0], workBuf[1] };

    memset(outBuffers[0], 0, buffer.getNumSamples() * sizeof(float));
    memset(outBuffers[1], 0, buffer.getNumSamples() * sizeof(float));
    memset(workBuf[0], 0, 2 * buffer.getNumSamples() * sizeof(float));

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
            leslie.setSpeed(8.0f);
        }
        else if (msg.isSustainPedalOff())
        {
            leslie.setSpeed(4.0f);
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
            if (cn >= 16 && cn < 24)
            {
                float cv = msg.getControllerValue() / 127.0f;
                synth.setDrawBar(cn - 16, cv);
                sendChangeMessage();
            }
            else if (cn == 24)
            {
                float cv = msg.getControllerValue() / 127.0f;
                synth.setMasterVolume(cv);
                sendChangeMessage();
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
        synth.render(channelCount, chunkSize, workBuffers);
        samplesRemaining -= chunkSize;
        workBuffers[0] += chunkSize;
        workBuffers[1] += chunkSize;
    }

    int sampleCount = buffer.getNumSamples();   // left only
    float* sp = workBuf[0];
    for (int i = 0; i < sampleCount; i++) distortion.processInPlace(sp++);

    const float* workBufs[2] = { workBuf[0], workBuf[1] };
    leslie.render(buffer.getNumSamples(), workBufs, outBuffers);
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
    XmlElement xml = XmlElement("myOrgan");
    xml.setAttribute("drawBar0", synth.getDrawBar(0));
    xml.setAttribute("drawBar1", synth.getDrawBar(1));
    xml.setAttribute("drawBar2", synth.getDrawBar(2));
    xml.setAttribute("drawBar3", synth.getDrawBar(3));
    xml.setAttribute("drawBar4", synth.getDrawBar(4));
    xml.setAttribute("drawBar5", synth.getDrawBar(5));
    xml.setAttribute("drawBar6", synth.getDrawBar(6));
    xml.setAttribute("drawBar7", synth.getDrawBar(7));
    xml.setAttribute("drawBar8", synth.getDrawBar(8));
    xml.setAttribute("power", distortion.getPower());
    xml.setAttribute("drive", distortion.getDrive());
    xml.setAttribute("gain", distortion.getGain());
    copyXmlToBinary(xml, destData);
}

void MyOrganAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    ScopedPointer<XmlElement> xml = getXmlFromBinary(data, sizeInBytes);
    synth.setDrawBar(0, float(xml->getDoubleAttribute("drawBar0", 1.0)));
    synth.setDrawBar(1, float(xml->getDoubleAttribute("drawBar1", 0.0)));
    synth.setDrawBar(2, float(xml->getDoubleAttribute("drawBar2", 0.0)));
    synth.setDrawBar(3, float(xml->getDoubleAttribute("drawBar3", 0.0)));
    synth.setDrawBar(4, float(xml->getDoubleAttribute("drawBar4", 0.0)));
    synth.setDrawBar(5, float(xml->getDoubleAttribute("drawBar5", 0.0)));
    synth.setDrawBar(6, float(xml->getDoubleAttribute("drawBar6", 0.0)));
    synth.setDrawBar(7, float(xml->getDoubleAttribute("drawBar7", 0.0)));
    synth.setDrawBar(8, float(xml->getDoubleAttribute("drawBar8", 0.0)));
    distortion.setPower(float(xml->getDoubleAttribute("power", 1.0)));
    distortion.setDrive(float(xml->getDoubleAttribute("drive", 1.0)));
    distortion.setGain(float(xml->getDoubleAttribute("gain", 1.0)));
    sendChangeMessage();
}

AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new MyOrganAudioProcessor();
}
