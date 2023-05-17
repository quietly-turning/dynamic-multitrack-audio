# Dynamic Layered Audio in StepMania

This is a proof-of-concept of a Lua-controlled multitrack audio system for
minigame use in StepMania.

This video demonstrates how moving the character avatar closer to — and further
away from — each piano changes how loudly its audio plays.

https://github.com/quietly-turning/dynamic-layered-audio-demo/assets/1253483/757c1caa-bff5-4c8b-922f-ec56c3dae012

## Supported versions of StepMania

This code should work in [StepMania 5.1.0-beta](https://github.com/stepmania/stepmania/releases/tag/v5.1.0-b2) 
and [ITGMania 0.6.1](https://github.com/itgmania/itgmania/releases/tag/v0.6.1).

## Support Tools

I used [Tiled 1.8.4](https://www.mapeditor.org/download.html) to create this tilemap and export to Lua. 
Newer versions of Tiled may work, but I haven't tested them.

## How to use

I don't have instructions on that just yet!

If you're interested in learning how you might make something like this, feel
free to [open an issue](https://github.com/quietly-turning/dynamic-layered-audio-demo/issues) and
I can probably be convinced to write some documentation.

The relevant audio code is in `dynamic-audio.lua` — it's super-hardcoded and not
generalized enough to be useful, but that's a proof-of-concept for you. :^)
