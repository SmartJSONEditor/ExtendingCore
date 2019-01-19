//
//  AKOrganDSP.mm
//  AudioKit
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#import "AKOrganDSP.hpp"
#include <math.h>

extern "C" void *createAKOrganDSP(int channelCount, double sampleRate) {
    return new AKOrganDSP();
}

extern "C" void doAKOrganPlayNote(void *pDSP, UInt8 noteNumber, UInt8 velocity, float noteFrequency)
{
    ((AKOrganDSP*)pDSP)->playNote(noteNumber, velocity, noteFrequency);
}

extern "C" void doAKOrganStopNote(void *pDSP, UInt8 noteNumber, bool immediate)
{
    ((AKOrganDSP*)pDSP)->stopNote(noteNumber, immediate);
}

extern "C" void doAKOrganSustainPedal(void *pDSP, bool pedalDown)
{
    ((AKOrganDSP*)pDSP)->sustainPedal(pedalDown);
}


AKOrganDSP::AKOrganDSP() : Organ()
{
    masterVolumeRamp.setTarget(1.0, true);
    pitchBendRamp.setTarget(0.0, true);
    vibratoDepthRamp.setTarget(1.0, true);
    drawbar0Ramp.setTarget(0.0, true);
    drawbar1Ramp.setTarget(0.0, true);
    drawbar2Ramp.setTarget(1.0, true);
    drawbar3Ramp.setTarget(0.0, true);
    drawbar4Ramp.setTarget(0.0, true);
    drawbar5Ramp.setTarget(0.0, true);
    drawbar6Ramp.setTarget(0.0, true);
    drawbar7Ramp.setTarget(0.0, true);
    drawbar8Ramp.setTarget(0.0, true);
}

void AKOrganDSP::init(int channelCount, double sampleRate)
{
    AKDSPBase::init(channelCount, sampleRate);
    Organ::init(sampleRate);
}

void AKOrganDSP::deinit()
{
    Organ::deinit();
}

void AKOrganDSP::setParameter(uint64_t address, float value, bool immediate)
{
    switch (address) {
        case AKOrganParameterRampDuration:
            masterVolumeRamp.setRampDuration(value, sampleRate);
            pitchBendRamp.setRampDuration(value, sampleRate);
            vibratoDepthRamp.setRampDuration(value, sampleRate);
            drawbar0Ramp.setRampDuration(value, sampleRate);
            drawbar1Ramp.setRampDuration(value, sampleRate);
            drawbar2Ramp.setRampDuration(value, sampleRate);
            drawbar3Ramp.setRampDuration(value, sampleRate);
            drawbar4Ramp.setRampDuration(value, sampleRate);
            drawbar5Ramp.setRampDuration(value, sampleRate);
            drawbar6Ramp.setRampDuration(value, sampleRate);
            drawbar7Ramp.setRampDuration(value, sampleRate);
            drawbar8Ramp.setRampDuration(value, sampleRate);
            break;

        case AKOrganParameterMasterVolume:
            masterVolumeRamp.setTarget(value, immediate);
            break;
        case AKOrganParameterPitchBend:
            pitchBendRamp.setTarget(value, immediate);
            break;
        case AKOrganParameterVibratoDepth:
            vibratoDepthRamp.setTarget(value, immediate);
            break;
        case AKOrganParameterDrawbar0:
            drawbar0Ramp.setTarget(value, immediate);
            break;
        case AKOrganParameterDrawbar1:
            drawbar1Ramp.setTarget(value, immediate);
            break;
        case AKOrganParameterDrawbar2:
            drawbar2Ramp.setTarget(value, immediate);
            break;
        case AKOrganParameterDrawbar3:
            drawbar3Ramp.setTarget(value, immediate);
            break;
        case AKOrganParameterDrawbar4:
            drawbar4Ramp.setTarget(value, immediate);
            break;
        case AKOrganParameterDrawbar5:
            drawbar5Ramp.setTarget(value, immediate);
            break;
        case AKOrganParameterDrawbar6:
            drawbar6Ramp.setTarget(value, immediate);
            break;
        case AKOrganParameterDrawbar7:
            drawbar7Ramp.setTarget(value, immediate);
            break;
        case AKOrganParameterDrawbar8:
            drawbar8Ramp.setTarget(value, immediate);
            break;

        case AKOrganParameterAttackDuration:
            setAmpAttackDurationSeconds(value);
            break;
        case AKOrganParameterDecayDuration:
            setAmpDecayDurationSeconds(value);
            break;
        case AKOrganParameterSustainLevel:
            setAmpSustainFraction(value);
            break;
        case AKOrganParameterReleaseDuration:
            setAmpReleaseDurationSeconds(value);
            break;
        case AKOrganParameterPower:
            setPower(value);
            break;
        case AKOrganParameterDrive:
            setDrive(value);
            break;
        case AKOrganParameterOutputLevel:
            setGain(value);
            break;
        case AKOrganParameterLeslieSpeed:
            setLeslieSpeed(value);
            break;
    }
}

float AKOrganDSP::getParameter(uint64_t address)
{
    switch (address) {
        case AKOrganParameterRampDuration:
            return masterVolumeRamp.getRampDuration(sampleRate);

        case AKOrganParameterMasterVolume:
            return masterVolumeRamp.getTarget();
        case AKOrganParameterPitchBend:
            return pitchBendRamp.getTarget();
        case AKOrganParameterVibratoDepth:
            return vibratoDepthRamp.getTarget();
        case AKOrganParameterDrawbar0:
            return drawbar0Ramp.getTarget();
        case AKOrganParameterDrawbar1:
            return drawbar1Ramp.getTarget();
        case AKOrganParameterDrawbar2:
            return drawbar2Ramp.getTarget();
        case AKOrganParameterDrawbar3:
            return drawbar3Ramp.getTarget();
        case AKOrganParameterDrawbar4:
            return drawbar4Ramp.getTarget();
        case AKOrganParameterDrawbar5:
            return drawbar5Ramp.getTarget();
        case AKOrganParameterDrawbar6:
            return drawbar6Ramp.getTarget();
        case AKOrganParameterDrawbar7:
            return drawbar7Ramp.getTarget();
        case AKOrganParameterDrawbar8:
            return drawbar8Ramp.getTarget();


        case AKOrganParameterAttackDuration:
            return getAmpAttackDurationSeconds();
        case AKOrganParameterDecayDuration:
            return getAmpDecayDurationSeconds();
        case AKOrganParameterSustainLevel:
            return getAmpSustainFraction();
        case AKOrganParameterReleaseDuration:
            return getAmpReleaseDurationSeconds();
        case AKOrganParameterPower:
            return getPower();
        case AKOrganParameterDrive:
            return getDrive();
        case AKOrganParameterOutputLevel:
            return getGain();
        case AKOrganParameterLeslieSpeed:
            return getLeslieSpeed();
    }
    return 0;
}

void AKOrganDSP::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset)
{
    for (int frameIndex = 0; frameIndex < frameCount; frameIndex += 16) {
        int frameOffset = int(frameIndex + bufferOffset);
        int chunkSize = frameCount - frameIndex;
        if (chunkSize > 16) chunkSize = 16;

        // ramp parameters
        masterVolumeRamp.advanceTo(now + frameOffset);
        setMasterVolume((float)masterVolumeRamp.getValue());
        pitchBendRamp.advanceTo(now + frameOffset);
        setPitchOffset((float)pitchBendRamp.getValue());
        vibratoDepthRamp.advanceTo(now + frameOffset);
        setVibratoDepth((float)vibratoDepthRamp.getValue());
        drawbar0Ramp.advanceTo(now + frameOffset);
        setDrawBar(0, (float)drawbar0Ramp.getValue());
        drawbar1Ramp.advanceTo(now + frameOffset);
        setDrawBar(1, (float)drawbar1Ramp.getValue());
        drawbar2Ramp.advanceTo(now + frameOffset);
        setDrawBar(2, (float)drawbar2Ramp.getValue());
        drawbar3Ramp.advanceTo(now + frameOffset);
        setDrawBar(3, (float)drawbar3Ramp.getValue());
        drawbar4Ramp.advanceTo(now + frameOffset);
        setDrawBar(4, (float)drawbar4Ramp.getValue());
        drawbar5Ramp.advanceTo(now + frameOffset);
        setDrawBar(5, (float)drawbar5Ramp.getValue());
        drawbar6Ramp.advanceTo(now + frameOffset);
        setDrawBar(6, (float)drawbar6Ramp.getValue());
        drawbar7Ramp.advanceTo(now + frameOffset);
        setDrawBar(7, (float)drawbar7Ramp.getValue());
        drawbar8Ramp.advanceTo(now + frameOffset);
        setDrawBar(8, (float)drawbar8Ramp.getValue());

        // get data
        float *outBuffers[2];
        outBuffers[0] = (float *)outBufferListPtr->mBuffers[0].mData + frameOffset;
        outBuffers[1] = (float *)outBufferListPtr->mBuffers[1].mData + frameOffset;
        unsigned channelCount = outBufferListPtr->mNumberBuffers;
        Organ::render(channelCount, chunkSize, outBuffers);
    }
}
