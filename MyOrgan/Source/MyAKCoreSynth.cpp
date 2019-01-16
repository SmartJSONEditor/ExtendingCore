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

#include <math.h>
#include <list>

#define MAX_VOICE_COUNT 32      // number of voices
#define MIDI_NOTENUMBERS 128    // MIDI offers 128 distinct note numbers

struct MyAKCoreSynth::InternalData
{
    /// array of voice resources
    AudioKitCore::MySynthVoice voice[MAX_VOICE_COUNT];
    
    AudioKitCore::WaveStack waveform;                             // WaveStacks are shared by all voice oscillators
    AudioKitCore::FunctionTableOscillator vibratoLFO;             // one vibrato LFO shared by all voices
    AudioKitCore::SustainPedalLogic pedalLogic;
    
    // simple parameters
    AudioKitCore::MySynthVoiceParameters voiceParameters;
    AudioKitCore::ADSREnvelopeParameters ampEGParameters;
    AudioKitCore::ADSREnvelopeParameters filterEGParameters;
};

MyAKCoreSynth::MyAKCoreSynth()
: data(new InternalData)
, eventCounter(0)
, masterVolume(0.2f)
, pitchOffset(0.0f)
, vibratoDepth(0.0f)
, velocitySensitivity(0.1f)
{
    for (int i=0; i < MAX_VOICE_COUNT; i++)
    {
        data->voice[i].event = 0;
        data->voice[i].noteNumber = -1;
        data->voice[i].ampEG.pParameters = &data->ampEGParameters;
    }
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
    data->filterEGParameters.updateSampleRate((float)(sampleRate/AKSYNTH_CHUNKSIZE));
    
    data->vibratoLFO.waveTable.sinusoid();
    data->vibratoLFO.init(sampleRate/AKSYNTH_CHUNKSIZE, 5.0f);
    
    memset(data->voiceParameters.organ.drawbars, 0, 16 * sizeof(float));
    data->voiceParameters.organ.drawbars[0] = 1.0f;
    data->voiceParameters.organ.mixLevel = 0.4f;

    data->ampEGParameters.setAttackDurationSeconds(0.01f);
    data->ampEGParameters.setReleaseDurationSeconds(0.01f);

    for (int i=0; i < MAX_VOICE_COUNT; i++)
    {
        data->voice[i].init(sampleRate, &data->waveform, &data->voiceParameters);
    }
    
    return 0;   // no error
}

void MyAKCoreSynth::deinit()
{
}

void MyAKCoreSynth::playNote(unsigned noteNumber, unsigned velocity, float noteFrequency)
{
    eventCounter++;
    data->pedalLogic.keyDownAction(noteNumber);
    play(noteNumber, velocity, noteFrequency);
}

void MyAKCoreSynth::stopNote(unsigned noteNumber, bool immediate)
{
    eventCounter++;
    if (immediate || data->pedalLogic.keyUpAction(noteNumber))
        stop(noteNumber, immediate);
}

void MyAKCoreSynth::sustainPedal(bool down)
{
    eventCounter++;
    if (down) data->pedalLogic.pedalDown();
    else {
        for (int nn=0; nn < MIDI_NOTENUMBERS; nn++)
        {
            if (data->pedalLogic.isNoteSustaining(nn))
                stop(nn, false);
        }
        data->pedalLogic.pedalUp();
    }
}

AudioKitCore::MySynthVoice *MyAKCoreSynth::voicePlayingNote(unsigned noteNumber)
{
    AudioKitCore::MySynthVoice *pVoice = data->voice;
    for (int i=0; i < MAX_VOICE_COUNT; i++, pVoice++)
    {
        if (pVoice->noteNumber == int(noteNumber)) return pVoice;
    }
    return 0;
}

float MyAKCoreSynth::velToLevel(int midiVelocity)
{
    return (1.0f - velocitySensitivity) + velocitySensitivity * midiVelocity / 127.0f;
}

void MyAKCoreSynth::play(unsigned noteNumber, unsigned velocity, float noteFrequency)
{
    //printf("playNote nn=%d vel=%d %.2f Hz\n", noteNumber, velocity, noteFrequency);
    
    // is any voice already playing this note?
    AudioKitCore::MySynthVoice *pVoice = voicePlayingNote(noteNumber);
    if (pVoice)
    {
        // re-start the note
        pVoice->restart(eventCounter, velToLevel(velocity));
        //printf("Restart note %d as %d\n", noteNumber, pVoice->noteNumber);
        return;
    }
    
    // find a free voice (with noteNumber < 0) to play the note
    for (int i=0; i < MAX_VOICE_COUNT; i++)
    {
        pVoice = &data->voice[i];
        if (pVoice->noteNumber < 0)
        {
            // found a free voice: assign it to play this note
            pVoice->start(eventCounter, noteNumber, noteFrequency, velToLevel(velocity));
            //printf("Play note %d (%.2f Hz) vel %d\n", noteNumber, noteFrequency, velocity);
            return;
        }
    }
    
    // all oscillators in use: find "stalest" voice to steal
    unsigned greatestDiffOfAll = 0;
    AudioKitCore::MySynthVoice *pStalestVoiceOfAll = 0;
    unsigned greatestDiffInRelease = 0;
    AudioKitCore::MySynthVoice *pStalestVoiceInRelease = 0;
    for (int i=0; i < MAX_VOICE_COUNT; i++)
    {
        pVoice = &data->voice[i];
        unsigned diff = eventCounter - pVoice->event;
        if (pVoice->ampEG.isReleasing())
        {
            if (diff > greatestDiffInRelease)
            {
                greatestDiffInRelease = diff;
                pStalestVoiceInRelease = pVoice;
            }
        }
        if (diff > greatestDiffOfAll)
        {
            greatestDiffOfAll = diff;
            pStalestVoiceOfAll = pVoice;
        }
    }
    
    if (pStalestVoiceInRelease != 0)
    {
        // We have a stalest note in its release phase: restart that one
        //printf("Restart note %d in release phase as %d\n", noteNumber, pVoice->noteNumber);
        pStalestVoiceInRelease->restart(eventCounter, noteNumber, noteFrequency, velToLevel(velocity));
    }
    else
    {
        // No notes in release phase: restart the "stalest" one we could find
        //printf("Restart stalest note %d as %d\n", noteNumber, pVoice->noteNumber);
        pStalestVoiceOfAll->restart(eventCounter, noteNumber, noteFrequency, velToLevel(velocity));
    }
}

void MyAKCoreSynth::stop(unsigned noteNumber, bool immediate)
{
    //printf("stopNote nn=%d %s\n", noteNumber, immediate ? "immediate" : "release");
    AudioKitCore::MySynthVoice *pVoice = voicePlayingNote(noteNumber);
    if (pVoice == 0) return;
    //printf("stopNote pVoice is %p\n", pVoice);
    
    if (immediate)
    {
        pVoice->stop(eventCounter);
        //printf("Stop note %d immediate\n", noteNumber);
    }
    else
    {
        pVoice->release(eventCounter);
        //printf("Stop note %d release\n", noteNumber);
    }
}

void MyAKCoreSynth::render(unsigned /*channelCount*/, unsigned sampleCount, float *outBuffers[])
{
    float *pOutLeft = outBuffers[0];
    float *pOutRight = outBuffers[1];
    
    float pitchDev = pitchOffset + vibratoDepth * data->vibratoLFO.getSample();
    float phaseDeltaMultiplier = powf(2.0f, pitchDev / 12.0f);
    
    AudioKitCore::MySynthVoice *pVoice = &data->voice[0];
    for (int i=0; i < MAX_VOICE_COUNT; i++, pVoice++)
    {
        int nn = pVoice->noteNumber;
        if (nn >= 0)
        {
            if (pVoice->prepToGetSamples(masterVolume, phaseDeltaMultiplier) ||
                pVoice->getSamples(sampleCount, pOutLeft, pOutRight))
            {
                stopNote(nn, true);
            }
        }
    }
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
