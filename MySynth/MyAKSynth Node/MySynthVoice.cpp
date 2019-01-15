//
//  MySynthVoice.cpp
//  AudioKit Core
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

#include "MySynthVoice.hpp"
#include <stdio.h>

namespace AudioKitCore
{
    void MySynthVoice::init(double sampleRate,
                            WaveStack *pOscStack,
                            MySynthVoiceParameters *pParams)
    {
        pParameters = pParams;
        event = 0;
        noteNumber = -1;

        drawBarOsc.init(sampleRate, pOscStack);
        drawBarOsc.level = pParameters->organ.drawbars;

        ampEG.init();
    }

    void MySynthVoice::start(unsigned evt, unsigned noteNumber, float frequency, float volume)
    {
        event = evt;
        noteVolume = volume;
        drawBarOsc.setFrequency(frequency);
        ampEG.start();

        noteFrequency = frequency;
        this->noteNumber = noteNumber;
    }

    void MySynthVoice::restart(unsigned evt, float volume)
    {
        event = evt;
        newNoteNumber = -1;
        newNoteVol = volume;
        ampEG.restart();
    }

    void MySynthVoice::restart(unsigned evt, unsigned noteNumber, float frequency, float volume)
    {
        event = evt;
        newNoteNumber = noteNumber;
        newNoteVol = volume;
        noteFrequency = frequency;
        ampEG.restart();
    }

    void MySynthVoice::release(unsigned evt)
    {
        event = evt;
        ampEG.release();
    }

    void MySynthVoice::stop(unsigned evt)
    {
        event = evt;
        noteNumber = -1;
        ampEG.reset();
    }

    bool MySynthVoice::prepToGetSamples(float masterVolume, float phaseDeltaMultiplier)
    {
        if (ampEG.isIdle()) return true;

        if (ampEG.isPreStarting())
        {
            float ampeg = ampEG.getSample();
            tempGain = masterVolume * noteVolume * ampeg;
            if (!ampEG.isPreStarting())
            {
                noteVolume = newNoteVol;
                tempGain = masterVolume * noteVolume * ampeg;

                if (newNoteNumber >= 0)
                {
                    // restarting a "stolen" voice with a new note number
                    drawBarOsc.setFrequency(noteFrequency);
                    noteNumber = newNoteNumber;
                }
                ampEG.start();
            }
        }
        else
            tempGain = masterVolume * noteVolume * ampEG.getSample();

        drawBarOsc.phaseDeltaMultiplier = phaseDeltaMultiplier;

        return false;
    }

    bool MySynthVoice::getSamples(int sampleCount, float *leftOutput, float *rightOutput)
    {
        for (int i=0; i < sampleCount; i++)
        {
            float leftSample = 0.0f;
            float rightSample = 0.0f;
            drawBarOsc.getSamples(&leftSample, &rightSample, pParameters->organ.mixLevel);
            *leftOutput++ += tempGain * leftSample;
            *rightOutput++ += tempGain * rightSample;
        }
        return false;
    }
}
