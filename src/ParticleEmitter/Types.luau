-- @Author: thom463s
-- @Edited: 4/25/2025 @ 5:23 PM

--------------------------------------------------------------------------------------------------
-- Types

export type ParticleEmitter = {
	Color: ColorSequence | Color3,
	Size: NumberSequence | number,
	Texture: string,
	Transparency: NumberSequence | number,
	ZOffset: number,

	Parent: GuiBase2d,

	EmissionDirection: EmissionDirection,
	Enabled: boolean,
	Lifetime: NumberRange | number,
	Rate: number,
	Rotation: NumberRange | number,
	RotSpeed: NumberRange | number,
	Speed: NumberRange | number,
	SpreadAngle: number,

	Shape: Enum.ParticleEmitterShape,
	ShapeInOut: Enum.ParticleEmitterShapeInOut,
	ShapeStyle: Enum.ParticleEmitterShapeStyle,

	Acceleration: Vector2,
	TimeScale: number,
	
	_particles: {Particle},
	_connection: RBXScriptConnection,
	_elapsed: number,
	
	Emit: (self: ParticleEmitter, particleCount: number?) -> (),
	Destroy: (self: ParticleEmitter) -> ()
}

export type Particle = {
	Color: ColorSequence | Color3,
	Size: NumberSequence | number,
	Texture: string,
	Transparency: NumberSequence | number,
	ZOffset: number,

	EmissionDirection: EmissionDirection,
	Lifetime: number,
	Rotation: number,
	RotSpeed: number,
	Speed: number,
	SpreadAngle: number,

	Shape: Enum.ParticleEmitterShape,
	ShapeInOut: Enum.ParticleEmitterShapeInOut,
	ShapeStyle: Enum.ParticleEmitterShapeStyle,

	Acceleration: number,

	_particleEmitter: ParticleEmitter,
	_started: number,
	_position: UDim2,
	_label: ImageLabel,
	
	Update: (self: Particle, dt: number) -> (),
	Destroy: (self: Particle) -> ()
}

export type EmissionDirection = "Top" | "Bottom" | "Left" | "Right"

--------------------------------------------------------------------------------------------------
-- Callback

return nil
