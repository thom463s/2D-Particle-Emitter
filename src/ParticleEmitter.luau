-- @Author: thom463s
-- @Edited: 4/25/2025 @ 5:23 PM

--------------------------------------------------------------------------------------------------
-- Dependencies

local RunService = game:GetService("RunService")

local Particle = require(script.Particle)
local Types = require(script.Types)

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
		ZOffset = 0,

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
		
	}, ParticleEmitter)
	
	self._connection = RunService.RenderStepped:Connect(function(dt: number)
		if self.Enabled then
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
