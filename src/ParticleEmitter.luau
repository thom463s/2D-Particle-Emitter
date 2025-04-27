-- @Author: thom463s
-- @Edited: 4/27/2025 @ 9:58 PM

--------------------------------------------------------------------------------------------------
-- Dependencies

local RunService = game:GetService("RunService")

local Particle = require(script.Particle)
local Types = require(script.Types)

--------------------------------------------------------------------------------------------------
-- Private Methods

local function directionToString(enum: Enum.NormalId)
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

--------------------------------------------------------------------------------------------------
-- Class

local Constructor = {}
local ParticleEmitter = nil

--------------------------------------------------------------------------------------------------
-- Public Constructors

function Constructor.new(): Types.ParticleEmitter
	local self: Types.ParticleEmitter = setmetatable({
		
		--------------- PUBLIC PROPERTIES ---------------
		
		Color = Color3.new(1, 1, 1),
		Size = 32,
		Texture = "rbxasset://textures/particles/sparkles_main.dds",
		Transparency = 0,
		ZOffset = 1,
		
		EmissionDirection = "Top",
		Enabled = true,
		Lifetime = NumberRange.new(5, 10),
		Rate = 20,
		Rotation = 0,
		RotSpeed = 0,
		Speed = 25,
		SpreadAngle = 0,
		
		Shape = Enum.ParticleEmitterShape.Box,
		ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward,
		ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume,

		Acceleration = Vector2.zero,
		TimeScale = 1,
		
		--------------- PRIVATE PROPERTIES --------------
		
		_particles = {},
		_connection = nil,
		_elapsed = 0,
		_random = nil
		
	}, ParticleEmitter)
	
	self._connection = RunService.RenderStepped:Connect(function(dt: number)
		if self.Enabled and self.Parent then
			self._elapsed += dt
			if self._elapsed >= (1 / self.Rate) then
				self._elapsed = 0
				self:Emit(1)
			end
		else
			self._elapsed = 0
		end

		for _, particle in ipairs(self._particles) do
			if os.clock() - particle._started > particle.Lifetime then
				local index = table.find(self._particles, particle)
				table.remove(self._particles, index)

				particle:Destroy()
				continue
			end
			particle:Update(dt)
		end
	end)
	
	self._random = Random.new(DateTime.now().UnixTimestampMillis + os.clock())
	
	return self
end

function Constructor.fromParticle(particleEmitter: ParticleEmitter): Types.ParticleEmitter
	local self do
		self = Constructor.new()
		self.Color = particleEmitter.Color
		self.Size = particleEmitter.Size
		self.Texture = particleEmitter.Texture
		self.Transparency = particleEmitter.Transparency
		self.ZOffset = particleEmitter.ZOffset
		self.EmissionDirection = directionToString(particleEmitter.EmissionDirection)
		self.Enabled = particleEmitter.Enabled
		self.Lifetime = particleEmitter.Lifetime
		self.Rate = particleEmitter.Rate
		self.Rotation = particleEmitter.Rotation
		self.RotSpeed = particleEmitter.RotSpeed
		self.Speed = particleEmitter.Speed
		
		self.SpreadAngle = math.max(
			particleEmitter.SpreadAngle.X,
			particleEmitter.SpreadAngle.Y
		)
	end
	
	return self
end

--------------------------------------------------------------------------------------------------
-- Public Methods

ParticleEmitter = {}
ParticleEmitter.__index = ParticleEmitter

function ParticleEmitter.Emit(self: ParticleEmitter, particleCount: number?): ()
	for i = 1, (particleCount or 10) do
		local particle = Particle.new(self)
		table.insert(self._particles, particle)
	end
	return nil
end

function ParticleEmitter.Destroy(self: ParticleEmitter): ()
	for _, particle in ipairs(self._particles) do
		particle:Destroy()
	end
	self._connection:Disconnect()
end

--------------------------------------------------------------------------------------------------
-- Callback

return Constructor
