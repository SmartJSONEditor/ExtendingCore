//
//  Distortion.cpp
//  AudioKit Core
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "Distortion.hpp"

namespace AudioKitCore
{
    void Distortion::init(int tableSize)
    {
        ftable.init(tableSize);
        setGain(gain);
        setDrive(drive);
        setPower(power);
    }

    void Distortion::deinit()
    {
        ftable.deinit();
    }

    void Distortion::setPower(float p)
    {
        power = p;
        ftable.powerCurve(power);
    }

    void Distortion::processInPlace(float* sample)
    {
        float smp = *sample * drive;
        if (smp < 0.0f)
            *sample = -ftable.interp_bounded(-smp) * gain;
        else
            *sample = ftable.interp_bounded(smp) * gain;
    }

}
