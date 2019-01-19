//
//  Organ.cpp
//  AudioKit Core
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

#include "Organ.hpp"
#include "FunctionTable.hpp"
#include "OrganVoice.hpp"
#include "WaveStack.hpp"
#include "SustainPedalLogic.hpp"
#include "VoiceManager.hpp"
#include "Distortion.hpp"
#include "Leslie.hpp"

#include <math.h>
#include <list>

#define MAX_VOICE_COUNT 16      // number of voices
#define MIDI_NOTENUMBERS 128    // MIDI offers 128 distinct note numbers

namespace AudioKitCore
{
    struct DistortionParameters
    {
        float power;    // 1.0 - 2.0 typical
        float drive;    // 1.0 - 2.5 typical
        float output;   // 1.0 - 2.5 typical
    };

    struct LeslieParameters
    {
        float speed;    // 1 .. 8 (fractional part is ignored)
    };
}

struct Organ::InternalData
{
    /// array of voice resources, and a voice manager
    AudioKitCore::OrganVoice voice[MAX_VOICE_COUNT];
    AudioKitCore::VoiceManager voiceManager;

    // resources shared by all voices
    AudioKitCore::WaveStack waveform;
    AudioKitCore::FunctionTableOscillator vibratoLFO;
    AudioKitCore::Distortion distortion;
    Leslie leslie;

    // a stereo buffer to contain voice data before effects processing
    float leftWorkBuffer[CHUNKSIZE];
    float rightWorkBuffer[CHUNKSIZE];

    // simple parameters
    AudioKitCore::OrganVoiceParameters voiceParameters;
    AudioKitCore::ADSREnvelopeParameters ampEGParameters;
    AudioKitCore::OrganModParameters modParameters;
};

Organ::Organ()
: data(new InternalData)
, pitchOffset(0.0f)
, vibratoDepth(0.0f)
{
    for (int i=0; i < MAX_VOICE_COUNT; i++)
    {
        data->voice[i].ampEG.pParameters = &data->ampEGParameters;
    }

    memset(data->voiceParameters.organ.drawbars, 0, 16 * sizeof(float));
    data->voiceParameters.organ.drawbars[1] = 1.0f; // only the 8' drawbar is out
    data->voiceParameters.organ.mixLevel = 0.25f;   // reduce mix level so adding more drawbars won't overdrive
    data->modParameters.masterVol = 0.4f;           // same thing here

    data->modParameters.phaseDeltaMul = 1.0f;       // standard initial value

    setVelocitySensitivity(0.1f);   // organ has no velocity sensitivity; let's have just a bit
    setTuningRatio(0.5f);           // tune down 1 octave, making 16' drawbar a sub-octave

    data->distortion.init(512);     // init distortion with table size of 512
    data->leslie.setSpeed(4.0);     // start Leslie at "medium" speed
}

Organ::~Organ()
{
    data->distortion.deinit();
}

int Organ::init(double sampleRate)
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

    data->leslie.init(sampleRate);

    return 0;   // no error
}

void Organ::deinit()
{
    data->leslie.deinit();
}

void Organ::playNote(unsigned noteNumber, unsigned velocity, float noteFrequency)
{
    data->voiceManager.playNote(noteNumber, velocity, noteFrequency);
}

void Organ::stopNote(unsigned noteNumber, bool immediate)
{
    data->voiceManager.stopNote(noteNumber, immediate);
}

void Organ::sustainPedal(bool down)
{
    data->voiceManager.sustainPedal(down);
}

void Organ::renderPrepCallback(void* thisPtr)
{
    Organ& self = *((Organ*)thisPtr);
    float pitchDev = self.pitchOffset + self.vibratoDepth * self.data->vibratoLFO.getSample();
    self.data->modParameters.phaseDeltaMul = powf(2.0f, pitchDev / 12.0f);
}

void Organ::render(unsigned /*channelCount*/, unsigned sampleCount, float *outBuffers[])
{
    // render voice data to work buffers
    size_t bufferLength = sampleCount * sizeof(float);
    memset(data->leftWorkBuffer, 0, bufferLength);
    float *workBufs[2] = { data->leftWorkBuffer, data->rightWorkBuffer };
    data->voiceManager.render(sampleCount, workBufs);

    // apply distortion to work buffer (left channel only, since Leslie doesn't use right channel,
    // and our voice data are mono anyway
    for (int i = 0; i < sampleCount; i++)
        data->distortion.processInPlace(data->leftWorkBuffer + i);

    //memcpy(outBuffers[0], data->leftWorkBuffer, bufferLength);
    //memcpy(outBuffers[1], data->leftWorkBuffer, bufferLength);
    // now run the result through the Leslie to the output
    const float *constWorkBufs[2] = { data->leftWorkBuffer, data->rightWorkBuffer };
    data->leslie.render(sampleCount, constWorkBufs, outBuffers);
}

void Organ::setMasterVolume(float value)
{
    data->modParameters.masterVol = value;
}

float Organ::getMasterVolume()
{
    return data->modParameters.masterVol;
}

void Organ::setVelocitySensitivity(float value)
{
    data->voiceManager.setVelocitySensitivity(value);
}

float Organ::getVelocitySensitivity()
{
    return data->voiceManager.getVelocitySensitivity();
}

void Organ::setTuningRatio(float value)
{
    data->voiceManager.setTuningRatio(value);
}

float Organ::getTuningRatio()
{
    return data->voiceManager.getTuningRatio();
}

void Organ::setAmpAttackDurationSeconds(float value)
{
    data->ampEGParameters.setAttackDurationSeconds(value);
    for (int i = 0; i < MAX_VOICE_COUNT; i++) data->voice[i].updateAmpAdsrParameters();
}
float Organ::getAmpAttackDurationSeconds(void)
{
    return data->ampEGParameters.getAttackDurationSeconds();
}
void  Organ::setAmpDecayDurationSeconds(float value)
{
    data->ampEGParameters.setDecayDurationSeconds(value);
    for (int i = 0; i < MAX_VOICE_COUNT; i++) data->voice[i].updateAmpAdsrParameters();
}
float Organ::getAmpDecayDurationSeconds(void)
{
    return data->ampEGParameters.getDecayDurationSeconds();
}
void  Organ::setAmpSustainFraction(float value)
{
    data->ampEGParameters.sustainFraction = value;
    for (int i = 0; i < MAX_VOICE_COUNT; i++) data->voice[i].updateAmpAdsrParameters();
}
float Organ::getAmpSustainFraction(void)
{
    return data->ampEGParameters.sustainFraction;
}
void  Organ::setAmpReleaseDurationSeconds(float value)
{
    data->ampEGParameters.setReleaseDurationSeconds(value);
    for (int i = 0; i < MAX_VOICE_COUNT; i++) data->voice[i].updateAmpAdsrParameters();
}

float Organ::getAmpReleaseDurationSeconds(void)
{
    return data->ampEGParameters.getReleaseDurationSeconds();
}

void Organ::setDrawBar(int index, float value)
{
    if (index < 0) index = 0;
    if (index > 8) index = 8;
    index = AudioKitCore::DrawbarsOscillator::drawBarMap[index];
    data->voiceParameters.organ.drawbars[index] = value;
}

float Organ::getDrawBar(int index)
{
    if (index < 0 || index > 8) return 0.0f;
    index = AudioKitCore::DrawbarsOscillator::drawBarMap[index];
    return data->voiceParameters.organ.drawbars[index];
}

void Organ::setHarmonicLevel(int index, float value)
{
    if (index >= 0 && index < 16)
        data->voiceParameters.organ.drawbars[index] = value;
}

float Organ::getHarmonicLevel(int index)
{
    if (index < 0 || index > 15) return 0.0f;
    return data->voiceParameters.organ.drawbars[index];
}

void Organ::setPower(float power)
{
    data->distortion.setPower(power);
}

float Organ::getPower()
{
    return data->distortion.getPower();
}

void Organ::setDrive(float drive)
{
    data->distortion.setDrive(drive);
}

float Organ::getDrive()
{
    return data->distortion.getDrive();
}

void Organ::setGain(float gain)
{
    data->distortion.setGain(gain);
}

float Organ::getGain()
{
    return data->distortion.getGain();
}

void Organ::setLeslieSpeed(float speed)
{
    data->leslie.setSpeed(speed);
}

float Organ::getLeslieSpeed()
{
    return data->leslie.getSpeed();
}
