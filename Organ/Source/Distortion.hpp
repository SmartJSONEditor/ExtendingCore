//
//  Distortion.hpp
//  AudioKit Core
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#pragma once
#include "FunctionTable.hpp"

namespace AudioKitCore
{

    class Distortion
    {
    public:
        Distortion() : gain(1.0f), drive(1.0f), power(1.0f) {}

        void init(int tableSize = 1024);
        void deinit();

        float getGain() { return gain; }
        void setGain(float g) { gain = g; }

        float getDrive() { return drive; }
        void setDrive(float d) { drive = d; }

        float getPower() { return power; }
        void setPower(float p);

        void processInPlace(float* sample);

    protected:
        float gain, drive, power;

        FunctionTable ftable;
    };

}
