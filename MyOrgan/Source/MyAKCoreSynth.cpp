//
//  MyAKCoreSynth.cpp
//  AudioKit Core
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

#include "MyAKCoreSynth.hpp"
#include "FunctionTable.hpp"
#include "MySynthVoice.hpp"
#include "WaveStack.hpp"
#include "SustainPedalLogic.hpp"
#include "VoiceManager.hpp"

#include <math.h>
#include <list>

#define MAX_VOICE_COUNT 32      // number of voices
#define MIDI_NOTENUMBERS 128    // MIDI offers 128 distinct note numbers

struct MyAKCoreSynth::InternalData
{
    /// array of voice resources, and a voice manager
    AudioKitCore::MySynthVoice voice[MAX_VOICE_COUNT];
    AudioKitCore::VoiceManager voiceManager;
    
    AudioKitCore::WaveStack waveform;                             // WaveStacks are shared by all voice oscillators
    AudioKitCore::FunctionTableOscillator vibratoLFO;             // one vibrato LFO shared by all voices
    
    // simple parameters
    AudioKitCore::MySynthVoiceParameters voiceParameters;
    AudioKitCore::ADSREnvelopeParameters ampEGParameters;
    AudioKitCore::MySynthModParameters modParameters;
};

MyAKCoreSynth::MyAKCoreSynth()
: data(new InternalData)
, pitchOffset(0.0f)
, vibratoDepth(0.0f)
, tuningRatio(1.0f)
{
    for (int i=0; i < MAX_VOICE_COUNT; i++)
    {
        data->voice[i].ampEG.pParameters = &data->ampEGParameters;
    }

    memset(data->voiceParameters.organ.drawbars, 0, 16 * sizeof(float));
    data->voiceParameters.organ.drawbars[1] = 1.0f; // only the 8' drawbar is out
    data->voiceParameters.organ.mixLevel = 0.25f;   // reduce mix level so adding more drawbars won't overdrive
    data->modParameters.masterVol = 0.4f;           // same thing here
    data->modParameters.phaseDeltaMul = 1.0f;       // standard init value
    data->voiceManager.setVelocitySensitivity(0.1f);    // organ has no velocity sensitivity; let's have just a bit
}

MyAKCoreSynth::~MyAKCoreSynth()
{
}

int MyAKCoreSynth::init(double sampleRate)
{
    AudioKitCore::FunctionTable waveform;
    int length = 1 << AudioKitCore::WaveStack::maxBits;
    waveform.init(length);
    waveform.triangle(0.5f);
    data->waveform.initStack(waveform.pWaveTable);
    
    data->ampEGParameters.updateSampleRate((float)(sampleRate/AKSYNTH_CHUNKSIZE));
    
    data->vibratoLFO.waveTable.sinusoid();
    data->vibratoLFO.init(sampleRate/AKSYNTH_CHUNKSIZE, 5.0f);
    
    data->ampEGParameters.setAttackDurationSeconds(0.01f);
    data->ampEGParameters.setReleaseDurationSeconds(0.01f);

    AudioKitCore::VoicePointerArray vpa;
    for (int i=0; i < MAX_VOICE_COUNT; i++)
    {
        data->voice[i].init(sampleRate, &data->waveform, &data->voiceParameters, &data->modParameters);
        vpa.push_back(&(data->voice[i]));
    }
    data->voiceManager.init(vpa, MAX_VOICE_COUNT, &renderPrepCallback, this);
    
    return 0;   // no error
}

void MyAKCoreSynth::deinit()
{
}

void MyAKCoreSynth::playNote(unsigned noteNumber, unsigned velocity, float noteFrequency)
{
    data->voiceManager.playNote(noteNumber, velocity, noteFrequency);
}

void MyAKCoreSynth::stopNote(unsigned noteNumber, bool immediate)
{
    data->voiceManager.stopNote(noteNumber, immediate);
}

void MyAKCoreSynth::sustainPedal(bool down)
{
    data->voiceManager.sustainPedal(down);
}

void MyAKCoreSynth::renderPrepCallback(void* thisPtr)
{
    MyAKCoreSynth& self = *((MyAKCoreSynth*)thisPtr);
    float pitchDev = self.pitchOffset + self.vibratoDepth * self.data->vibratoLFO.getSample();
    self.data->modParameters.phaseDeltaMul = powf(2.0f, pitchDev / 12.0f);
}

void MyAKCoreSynth::render(unsigned /*channelCount*/, unsigned sampleCount, float *outBuffers[])
{
    data->voiceManager.render(sampleCount, outBuffers);
}

void MyAKCoreSynth::setMasterVolume(float value)
{
    data->modParameters.masterVol = value;
}

float MyAKCoreSynth::getMasterVolume()
{
    return data->modParameters.masterVol;
}

void MyAKCoreSynth::setAmpAttackDurationSeconds(float value)
{
    data->ampEGParameters.setAttackDurationSeconds(value);
    for (int i = 0; i < MAX_VOICE_COUNT; i++) data->voice[i].updateAmpAdsrParameters();
}
float MyAKCoreSynth::getAmpAttackDurationSeconds(void)
{
    return data->ampEGParameters.getAttackDurationSeconds();
}
void  MyAKCoreSynth::setAmpDecayDurationSeconds(float value)
{
    data->ampEGParameters.setDecayDurationSeconds(value);
    for (int i = 0; i < MAX_VOICE_COUNT; i++) data->voice[i].updateAmpAdsrParameters();
}
float MyAKCoreSynth::getAmpDecayDurationSeconds(void)
{
    return data->ampEGParameters.getDecayDurationSeconds();
}
void  MyAKCoreSynth::setAmpSustainFraction(float value)
{
    data->ampEGParameters.sustainFraction = value;
    for (int i = 0; i < MAX_VOICE_COUNT; i++) data->voice[i].updateAmpAdsrParameters();
}
float MyAKCoreSynth::getAmpSustainFraction(void)
{
    return data->ampEGParameters.sustainFraction;
}
void  MyAKCoreSynth::setAmpReleaseDurationSeconds(float value)
{
    data->ampEGParameters.setReleaseDurationSeconds(value);
    for (int i = 0; i < MAX_VOICE_COUNT; i++) data->voice[i].updateAmpAdsrParameters();
}

float MyAKCoreSynth::getAmpReleaseDurationSeconds(void)
{
    return data->ampEGParameters.getReleaseDurationSeconds();
}

void MyAKCoreSynth::setDrawBar(int index, float value)
{
    if (index < 0) index = 0;
    if (index > 8) index = 8;
    index = AudioKitCore::DrawbarsOscillator::drawBarMap[index];
    data->voiceParameters.organ.drawbars[index] = value;
}

float MyAKCoreSynth::getDrawBar(int index)
{
    if (index < 0 || index > 8) return 0.0f;
    index = AudioKitCore::DrawbarsOscillator::drawBarMap[index];
    return data->voiceParameters.organ.drawbars[index];
}

void MyAKCoreSynth::setHarmonicLevel(int index, float value)
{
    if (index >= 0 && index < 16)
        data->voiceParameters.organ.drawbars[index] = value;
}

float MyAKCoreSynth::getHarmonicLevel(int index)
{
    if (index < 0 || index > 15) return 0.0f;
    return data->voiceParameters.organ.drawbars[index];
}

void MyAKCoreSynth::setVelocitySensitivity(float value)
{
    data->voiceManager.setVelocitySensitivity(value);
}

float MyAKCoreSynth::getVelocitySensitivity()
{
    return data->voiceManager.getVelocitySensitivity();
}
