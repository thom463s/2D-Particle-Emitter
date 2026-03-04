local RunService = game:GetService("RunService")

local Particle = require(script.Particle)
local Types = require(script.Types)

local function evaluateEmissionDirection(enum: Enum.NormalId)
	local lookup = {
		[Enum.NormalId.Top] = "Top",
		[Enum.NormalId.Bottom] = "Bottom",
		[Enum.NormalId.Left] = "Left",
		[Enum.NormalId.Right] = "Right",
		[Enum.NormalId.Front] = "Top", -- UI has no z coordinate; default to Top
		[Enum.NormalId.Back] = "Top"   -- UI has no z coordinate; default to Top
	}
	
	return lookup[enum]
end

local function evaluateAcceleration(acceleration: Vector3)
	return Vector2.new(acceleration.X, acceleration.Y)
end

local function evaluateSpreadAngle(spreadAngle: Vector2)
	return math.max(spreadAngle.X, spreadAngle.Y)
end

local Constructor = {}
local ParticleEmitter = {}
ParticleEmitter.__index = ParticleEmitter

function Constructor.new(): Types.ParticleEmitter
	local self: Types.ParticleEmitter = {}
	setmetatable(self, ParticleEmitter)
	
	self.Color = Color3.new(1, 1, 1)
	self.Size = 32
	self.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	self.Transparency = 0
	self.ZOffset = 1
	
	self.EmissionDirection = "Top"
	self.Enabled = true
	self.Lifetime = NumberRange.new(5, 10)
	self.Rate = 20
	self.Rotation = 0
	self.RotSpeed = 0
	self.Speed = 25
	self.SpreadAngle = 0
	
	self.Shape = Enum.ParticleEmitterShape.Box
	self.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
	self.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	
	self.Acceleration = Vector2.zero
	self.AspectRatio = 1
	self.TimeScale = 1
	self.Drag = 0
	
	self._connection = nil
	self._particles = {}
	self._elapsed = 0
	
	return self
end

function Constructor.fromParticle(particleEmitter: ParticleEmitter): Types.ParticleEmitter
	local self = Constructor.new()

	self.Color = particleEmitter.Color
	self.Size = particleEmitter.Size
	self.Texture = particleEmitter.Texture
	self.Transparency = particleEmitter.Transparency
	self.ZOffset = particleEmitter.ZOffset
	
	self.Enabled = particleEmitter.Enabled
	self.Lifetime = particleEmitter.Lifetime
	self.Rate = particleEmitter.Rate
	self.Rotation = particleEmitter.Rotation
	self.RotSpeed = particleEmitter.RotSpeed
	self.Speed = particleEmitter.Speed
	
	self.Shape = particleEmitter.Shape
	self.ShapeInOut = particleEmitter.ShapeInOut
	self.ShapeStyle = particleEmitter.ShapeStyle
	
	self.TimeScale = particleEmitter.TimeScale
	self.Drag = particleEmitter.Drag
	
	self.EmissionDirection = evaluateEmissionDirection(particleEmitter.EmissionDirection)
	self.Acceleration = evaluateAcceleration(particleEmitter.Acceleration)
	self.SpreadAngle = evaluateSpreadAngle(particleEmitter.SpreadAngle)
	
	return self
end

function Constructor.clone(particleEmitter: Types.ParticleEmitter): Types.ParticleEmitter
	local self = Constructor.new()
	
	for key, value in particleEmitter do
		if not string.find(key :: any, "^_") then
			self[key] = value
		end
	end
	
	return self
end

function ParticleEmitter.Bind(self: ParticleEmitter, loop: Types.Loops): ()
	if self._connection then
		warn("This ParticleEmitter is already connected to a loop")
		return
	end
	
	if loop == "RenderStepped" then
		self._connection = RunService.RenderStepped:Connect(function(dt)
			self:Update(dt)
		end)
	elseif loop == "Stepped" then
		self._connection = RunService.Stepped:Connect(function(_, dt)
			self:Update(dt)
		end)
	elseif loop == "Heartbeat" then
		self._connection = RunService.Heartbeat:Connect(function(dt)
			self:Update(dt)
		end)
	end
end

function ParticleEmitter.Unbind(self: ParticleEmitter): ()
	if not self._connection then
		return
	end
	
	self._connection:Disconnect()
	self._connection = nil
end

function ParticleEmitter.Update(self: ParticleEmitter, deltaTime: number): ()
	deltaTime = deltaTime * self.TimeScale
	
	if self.Enabled and self.Parent then
		self._elapsed += deltaTime
		if self._elapsed >= (1 / self.Rate) then
			self._elapsed = 0
			self:Emit(1)
		end
	else
		self._elapsed = 0
	end
	
	local alive = {}

	for _, particle in self._particles do
		if particle._elapsed > particle.Lifetime then
			particle:Destroy()
			continue
		end
		
		table.insert(alive, particle)
		particle:Update(deltaTime)
	end
	
	self._particles = alive
end

function ParticleEmitter.Emit(self: ParticleEmitter, particleCount: number?): ()
	for _ = 1, (particleCount or 10) do
		local particle = Particle.new(self)
		table.insert(self._particles, particle)
	end
end

function ParticleEmitter.Destroy(self: ParticleEmitter): ()
	for _, particle in ipairs(self._particles) do
		particle:Destroy()
	end
	
	if self._connection then
		self._connection:Disconnect()
	end
	
	table.clear(self)
	setmetatable(self, nil)
end

function ParticleEmitter.BindToRenderStepped(self: ParticleEmitter): ()
	self:Bind("RenderStepped")
end

function ParticleEmitter.BindToHeartbeat(self: ParticleEmitter): ()
	self:Bind("Heartbeat")
end

function ParticleEmitter.BindToStepped(self: ParticleEmitter): ()
	self:Bind("Stepped")
end

return Constructor
