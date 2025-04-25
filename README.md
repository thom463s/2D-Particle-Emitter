# 2D-Particle-Emitter
A 2D particle emitter solution that aims to mimic the Roblox particle emitters.

Example Usage:
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
