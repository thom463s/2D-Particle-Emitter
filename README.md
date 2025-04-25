# 2D-Particle-Emitter
Example Usage:
```luau
local ParticleEmitter = require(...)
local emitter = ParticleEmitter.new()

emitter.Color = Color3.fromRGB(255, 0, 0)
emitter.Texture = "rbxassetid://0"
emitter.Parent = script.Parent

emitter:Emit(25)
```
