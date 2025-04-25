# 2D-Particle-Emitter
A 2D particle emitter solution that aims to mimic the Roblox particle emitters.
The property descriptions listed below were mostly taken from the Roblox Documentations.

## Properties
| Name | Types | Description
| --- | --- | --- |
Color | `ColorSequence`, `number` | Determines the color of all active particles over their individual lifetimes.
Size | `NumberSequence`, `number` | Determines the offset size of all active particles over their individual lifetimes.
Texture | `string` | Determines the image rendered on particles.
Transparency | `NumberSequence`, `number` | Determines the transparency of all active particles over their individual lifetimes.
ZOffset | `number` | Determines the order in which a GuiObject renders relative to others. In other words, ZIndex.
EmissionDirection | `string` | Determines the direction in which the particle should emit from. To set a direction, write one of the following directions: `Top` \| `Bottom` \| `Left` \| `Right`
Enabled | `boolean` | Determines if particles emit from the emitter.
Lifetime | `NumberRange`, `number` | Defines the maximum and minimum ages for newly emitted particles.
Rate | `number` | Determines how many particles are emitted over the course of a second while the emitter is Enabled.
Rotation | `NumberRange`, `number` | Determines the range of rotations in degrees for newly emitted particles, measured in degrees.
RotSpeed | `NumberRange`, `number` | Determines a random range of angular speeds for newly emitted particles, measured in degrees per second.
Speed | `NumberRange`, `number` | Determines a random range of velocities (minimum to maximum) at which new particles will emit, measured in pixels (offset) per second.
SpreadAngle | `number` | Determines the random angles at which a particle may be emitted.

## Example
```luau
local ParticleEmitter = require(...)
local emitter = ParticleEmitter.new()

emitter.Color = Color3.new(1, 1, 1) -- ColorSequence supported
emitter.Size = 32 -- NumberSequence supported
emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
emitter.Transparency = 0 -- NumberSequence supported
emitter.ZOffset = 1 -- zindex of the particle image labels
emitter.EmissionDirection = "Top"
emitter.Enabled = true
emitter.Lifetime = NumberRange.new(5, 10)
emitter.Rate = 20
emitter.Rotation = 0
emitter.RotSpeed = 0
emitter.Speed = 25
emitter.SpreadAngle = 0

emitter.Parent = script.Parent -- where the image labels should be parented to 
emitter:Emit(25)
```

This is a very early demo of my 2D Particle Emitter. If you find any bugs or problems, please create an issue here!
