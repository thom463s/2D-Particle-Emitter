export type ParticleEmitter = {
	Color: ColorSequence | Color3,
	Size: NumberSequence | number,
	Texture: string,
	Transparency: NumberSequence | number,
	ZOffset: NumberRange | number,

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
	Drag: number,
	TimeScale: number,
	AspectRatio: number,
	
	_connection: RBXScriptConnection?,
	_particles: {Particle},
	_elapsed: number,
	
	Bind: (self: ParticleEmitter, loop: Loops) -> (),
	BindToRenderStepped: (self: ParticleEmitter) -> (),
	BindToHeartbeat: (self: ParticleEmitter) -> (),
	BindToStepped: (self: ParticleEmitter) -> (),
	Unbind: (self: ParticleEmitter) -> (),
	Update: (self: ParticleEmitter, deltaTime: number) -> (),
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

	Acceleration: Vector2,
	AspectRatio: number,
	TimeScale: number,
	Drag: number,
	
	_currentAcceleration: Vector2,
	_particleEmitter: ParticleEmitter,
	_currentSpeed: number,
	_position: Vector2,
	_elapsed: number,
	_label: ImageLabel,
	
	Update: (self: Particle, dt: number) -> (),
	Destroy: (self: Particle) -> ()
}

export type EmissionDirection = "Top" | "Bottom" | "Left" | "Right"
export type Loops = "RenderStepped" | "Stepped" | "Heartbeat"

return nil
