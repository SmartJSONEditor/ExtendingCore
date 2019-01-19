# Leslie effect
This code provides an emulation of the [Leslie rotating-speaker effect](https://en.wikipedia.org/wiki/Leslie_speaker) which gave the [Hammond organs](https://en.wikipedia.org/wiki/Hammond_organ) an important aspect of their characteristic sound.

## Attribution and licensing

This code is adapted from the [setBfree project](https://github.com/pantherb/setBfree) which is open-source, but *subject to the GPL license*, which does NOT permit its use in closed-source projects. The [setBfree GitHub repo](https://github.com/pantherb/setBfree) specifies the GPL2 (reproduced here in the *COPYING* file), but the actual code specifies that it may be used under the terms of any later version. For example, here is the header comment from the file *whirl.c*:

```c
/* setBfree - DSP tonewheel organ
 *
 * Copyright (C) 2003-2004 Fredrik Kilander <fk@dsv.su.se>
 * Copyright (C) 2008-2018 Robin Gareus <robin@gareus.org>
 * Copyright (C) 2010 Ken Restivo <ken@restivo.org>
 * Copyright (C) 2012 Will Panther <pantherb@setbfree.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
```

I claim the author-granted right to apply the [GPL3](https://www.gnu.org/licenses/gpl-3.0.en.html), which provides clarification for how GPL-licensed code can be used together with more permissive licenses, such as the [MIT license](https://opensource.org/licenses/MIT), which governs the rest of the code in this repo, as well as all of AudioKit.)

I have written to the original authors, asking if they might consider making at least this part of the [setBfree code](https://github.com/pantherb/setBfree) available under a more permissive license, but unless and until they choose to respond affirmatively in writing, this code remains subject to the GPL.

## Limitations of this code
To get this code to compile without errors or warnings in Visual Studio 2017 and Xcode 10, I had to make a number of changes (mostly adding type casts), with the result that the code is not quite identical to the original.

In the course of testing with JUCE by building an [Audio Unit version-2](https://developer.apple.com/library/archive/documentation/MusicAudio/Conceptual/AudioUnitProgrammingGuide/Introduction/Introduction.html) [plug-in](https://en.wikipedia.org/wiki/Audio_plug-in), I found an important limitation: the fixed-size buffers used here are essentially only suitable for operation at sampling rates at or below 48 kHz. Attempting to run the code at higher sampling rates (as Apple's **auval** plug-in validation tool does) will cause an [assert-failure exception](https://en.wikipedia.org/wiki/Assert.h) at line 571 in *whirl.c* if the code is compiled in Debug mode, and will almost certainly cause a crash in Release mode.

Most importantly, my C++ wrapper class *Leslie* does not attempt to make all of the underlying physical model's many parameters accessible to client code. Anyone wanting to do this should refer to the [original code](https://github.com/pantherb/setBfree) for clues about valid parameter ranges and how **new incoming parameter values need to be processed before being used**.
