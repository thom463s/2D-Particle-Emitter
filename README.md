# 2D-Particle-Emitter

A 2D particle emitter solution that aims to mimic the Roblox particle emitters.<br>Property descriptions are mostly taken from the Roblox documentation.

## Properties

| Name | Types | Description |
| --- | --- | --- |
| Color | `ColorSequence`, `Color3` | Determines the color of all active particles over their individual lifetimes. |
| Size | `NumberSequence`, `number` | Determines the offset size of all active particles over their individual lifetimes. |
| Texture | `string` | Determines the image rendered on particles. |
| Transparency | `NumberSequence`, `number` | Determines the transparency of all active particles over their individual lifetimes. |
| ZOffset | `NumberRange`, `number` | Determines the order in which a GuiObject renders relative to others. In other words, ZIndex. |
| EmissionDirection | `string` | Determines the face from which particles emit.<br>Accepts: `Top` \| `Bottom` \| `Left` \| `Right` |
| Enabled | `boolean` | Determines if particles emit from the emitter. |
| Lifetime | `NumberRange`, `number` | Defines the minimum and maximum ages for newly emitted particles. |
| Rate | `number` | Determines how many particles are emitted per second while the emitter is enabled. |
| Rotation | `NumberRange`, `number` | Determines the range of initial rotations in degrees for newly emitted particles. |
| RotSpeed | `NumberRange`, `number` | Determines a random range of angular speeds for newly emitted particles, measured in degrees per second. |
| Speed | `NumberRange`, `number` | Determines a random range of velocities at which new particles emit, measured in pixels (offset) per second. |
| SpreadAngle | `number` | Determines the random angle at which a particle may be emitted. |
| Acceleration | `Vector2` | Applies a constant acceleration to particles. X: (+) Right, (-) Left. Y: (+) Down, (-) Up. |
| Drag | `number` | Applies exponential speed decay to particles over their lifetime. A value of `0` means no drag. |
| AspectRatio | `number` | Applies an aspect ratio constraint to particles. Defaults to `1` (square). |
| TimeScale | `number` | Controls the speed of particle simulation. `1` is normal speed, `0.5` is half speed. |
| Parent | `GuiBase2d` | Where the particle image labels are parented to. |

## Methods

| Name | Description |
| --- | --- |
| `:Bind(loop: "RenderStepped" \| "Stepped" \| "Heartbeat")` | Connects the emitter to a RunService loop. |
| `:Unbind()` | Disconnects the emitter from its current loop. |
| `:Update(deltaTime: number)` | Manually steps the emitter. Use this if you want to manage updates yourself instead of using `:Bind()`. |
| `:Emit(particleCount: number?)` | Immediately emits the given number of particles. Defaults to `10`. |
| `:Destroy()` | Destroys the emitter and all active particles. |

Aliases for `:Bind()` are also available: `:BindToRenderStepped()`, `:BindToHeartbeat()`, `:BindToStepped()`.

## Constructors

| Name | Description |
| --- | --- |
| `ParticleEmitter.new()` | Creates a new emitter with default properties. |
| `ParticleEmitter.fromParticle(particleEmitter: ParticleEmitter)` | Creates a new 2D emitter from an existing Roblox `ParticleEmitter` instance. Note: `Size` and `Speed` behave differently and should be set manually after construction. |
| `ParticleEmitter.clone(particleEmitter: Types.ParticleEmitter)` | Creates a copy of an existing 2D emitter. |

## Example

```luau
local ParticleEmitter = require(...)
local emitter = ParticleEmitter.new()

emitter.Color = Color3.new(1, 1, 1)
emitter.Size = 32
emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
emitter.Transparency = 0
emitter.ZOffset = 1
emitter.EmissionDirection = "Top"
emitter.Enabled = true
emitter.Lifetime = NumberRange.new(5, 10)
emitter.Rate = 20
emitter.Rotation = 0
emitter.RotSpeed = 0
emitter.Speed = 25
emitter.SpreadAngle = 0
emitter.Acceleration = Vector2.new(0, 40)
emitter.Drag = 0.5
emitter.AspectRatio = 1
emitter.TimeScale = 1

emitter.Parent = script.Parent
emitter:Bind("RenderStepped")
emitter:Emit(25)
```

## Using `fromParticle`

```luau
local ParticleEmitter = require(...)

local emitter = ParticleEmitter.fromParticle(script.ParticleEmitter)

-- Size and Speed work differently from regular ParticleEmitters
-- Be sure to set them manually or use a scale multiplier for them

emitter.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 3.75),
    NumberSequenceKeypoint.new(0.175, 15),
    NumberSequenceKeypoint.new(1, 0),
})
emitter.Speed = 15

emitter.Parent = script.Parent
emitter:Bind("Heartbeat")
```

## Notes

- `Speed` is measured in **pixels (offset) per second**, not studs.
- `Size` is in **offset**, not scale.
- `Acceleration` uses screen-space coordinates — Y(+) is downward, Y(-) is upward.
- Emitters do **not** auto-connect to a loop on creation. You must call `:Bind()` or `:Update()` manually.
- Parenting to a `CanvasGroup` is not recommended due to it having to re-draw itself everytime a particle updates. Use at your own discretion!

If you find any bugs or problems, please [create an issue](../../issues)!
