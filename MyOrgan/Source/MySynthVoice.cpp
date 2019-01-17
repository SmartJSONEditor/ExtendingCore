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
                            MySynthVoiceParameters* pTimbreParameters,
                            MySynthModParameters* pModParameters)
    {
        VoiceBase::init(sampleRate, pTimbreParameters, pModParameters);

        drawBarOsc.init(sampleRate, pOscStack);
        drawBarOsc.level = pTimbreParameters->organ.drawbars;

        ampEG.init();
    }

    void MySynthVoice::start(unsigned evt, unsigned noteNum, unsigned velocity, float freqHz, float volume)
    {
        drawBarOsc.setFrequency(0.5f * freqHz);
        ampEG.start();
        VoiceBase::start(evt, noteNum, velocity, freqHz, volume);
    }

    void MySynthVoice::restart(unsigned evt, unsigned noteNum, unsigned velocity, float freqHz, float volume)
    {
        ampEG.restart();
        VoiceBase::restart(evt, noteNum, velocity, freqHz, volume);
    }

    void MySynthVoice::release(unsigned evt)
    {
        ampEG.release();
        VoiceBase::release(evt);
    }

    void MySynthVoice::stop(unsigned evt)
    {
        VoiceBase::stop(evt);
        ampEG.reset();
    }

    bool MySynthVoice::doModulation(void)
    {
        if (ampEG.isIdle()) return true;

        MySynthModParameters* pMod = (MySynthModParameters*)pModParams;

        if (ampEG.isPreStarting())
        {
            float ampeg = ampEG.getSample();
            tempGain = pMod->masterVol * noteVol * ampeg;
            if (!ampEG.isPreStarting())
            {
                noteVol = newNoteVol;
                tempGain = pMod->masterVol * noteVol * ampeg;

                if (newNoteNumber >= 0)
                {
                    // restarting a "stolen" voice with a new note number
                    drawBarOsc.setFrequency(0.5f * noteHz);
                    noteNumber = newNoteNumber;
                }
                ampEG.start();
            }
        }
        else
            tempGain = pMod->masterVol * noteVol * ampEG.getSample();

        drawBarOsc.phaseDeltaMultiplier = pMod->phaseDeltaMul;

        return false;
    }

    bool MySynthVoice::getSamples(int sampleCount, float *leftOutput, float *rightOutput)
    {
        MySynthVoiceParameters* pParams = (MySynthVoiceParameters*)pTimbreParams;

        for (int i=0; i < sampleCount; i++)
        {
            float leftSample = 0.0f;
            float rightSample = 0.0f;
            drawBarOsc.getSamples(&leftSample, &rightSample, pParams->organ.mixLevel);
            *leftOutput++ += tempGain * leftSample;
            *rightOutput++ += tempGain * rightSample;
        }
        return false;
    }
}
