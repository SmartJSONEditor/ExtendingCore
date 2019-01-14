# audiokit-synth
AudioKit extension project for a clone of AKSynth.

## New Xcode 10 project using AudioKit frameworks
* In Xcode 10, create new project, select "Cocoa App"
* In "General" under Linked Frameworks and Libraries
  * click plus sign
  * click "Add Other..." button
  * Locate *AudioKit.framework* and *AudioKitUI.framework* and click "Open"
* In "Build Settings":
  * default selection at top is "Basic"; switch to "All"
  * enter "search" in search box at top right
  * double-click beside "Framework Search Paths"; an empty box will open with +/- buttons at bottom
  * locate *AudioKit/Frameworks/AudioKit-macOS* folder using Finder, and drag into the open box
  * click anywhere outside the box to dismiss it
  * At this point you can build the project with Cmd+B.
  * use the same drag/drop approach to 
* optional: In "General" set application category to "Music"
* optional: In "Capabilities", turn off App Sandbox
