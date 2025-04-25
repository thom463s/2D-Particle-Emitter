-- @Author: thom463s
-- @Edited: 4/25/2025 @ 5:23 PM

--------------------------------------------------------------------------------------------------
-- Dependencies

local Root = script.Parent
local Types = require(Root.Types)

--------------------------------------------------------------------------------------------------
-- Private Methods

local function initNumberRange(input: NumberRange | number)
	if typeof(input) == "NumberRange" then
		return math.random(input.Min, input.Max)
	elseif typeof(input) == "number" then
		return input
	end
	return 0
end

local function initNumberSequence(input: NumberSequence | number)
	if typeof(input) == "NumberSequence" then
		local keypoint = input.Keypoints[1]
		local envelope = keypoint.Envelope
		local size = keypoint.Value
		
		if envelope > 0 then
			size += math.random(-envelope, envelope)
		end
		
		return size
	elseif typeof(input) == "number" then
		return input
	end
	return 0
end

local function initColorSequence(input: ColorSequence | Color3)
	if typeof(input) == "ColorSequence" then
		local keypoint = input.Keypoints[1]
		return keypoint.Value
	elseif typeof(input) == "Color3" then
		return input
	end
	return Color3.new()
end

local function evalColorSequence(sequence: ColorSequence, time: number)
	if time <= 0 then
		return sequence.Keypoints[1].Value
	elseif time >= 1 then
		return sequence.Keypoints[#sequence.Keypoints].Value
	end
	
	for i = 1, #sequence.Keypoints - 1 do
		local thisKeypoint = sequence.Keypoints[i]
		local nextKeypoint = sequence.Keypoints[i + 1]
		if time >= thisKeypoint.Time and time < nextKeypoint.Time then
			local alpha = (time - thisKeypoint.Time) / (nextKeypoint.Time - thisKeypoint.Time)
			return Color3.new(
				(nextKeypoint.Value.R - thisKeypoint.Value.R) * alpha + thisKeypoint.Value.R,
				(nextKeypoint.Value.G - thisKeypoint.Value.G) * alpha + thisKeypoint.Value.G,
				(nextKeypoint.Value.B - thisKeypoint.Value.B) * alpha + thisKeypoint.Value.B
			)
		end
	end
end

local function evalNumberSequence(sequence: NumberSequence, time: number)
	if time <= 0 then
		return sequence.Keypoints[1].Value
	elseif time >= 1 then
		return sequence.Keypoints[#sequence.Keypoints].Value
	end
	
	for i = 1, #sequence.Keypoints - 1 do
		local currKeypoint = sequence.Keypoints[i]
		local nextKeypoint = sequence.Keypoints[i + 1]
		if time >= currKeypoint.Time and time < nextKeypoint.Time then
			local alpha = (time - currKeypoint.Time) / (nextKeypoint.Time - currKeypoint.Time)
			return currKeypoint.Value + (nextKeypoint.Value - currKeypoint.Value) * alpha
		end
	end
end

local function evalDirection(direction: Types.EmissionDirection)
	if direction == "Top" then
		return Vector2.new(0, -1)
	elseif direction == "Bottom" then
		return Vector2.new(0, 1)
	elseif direction == "Left" then
		return Vector2.new(-1, 0)
	elseif direction == "Right" then
		return Vector2.new(1, 0)
	end
	return Vector2.zero
end

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function lerpUDim2(a: UDim2, b: UDim2, t: number)
	local axs, axo, ays, ayo = a.X.Scale, a.X.Offset, a.Y.Scale, a.Y.Offset
	local bxs, bxo, bys, byo = b.X.Scale, b.X.Offset, b.Y.Scale, b.Y.Offset
	
	return UDim2.new(
		lerp(axs, bxs, t), lerp(axo, bxo, t),
		lerp(ays, bys, t), lerp(ayo, byo, t)
	)
end

local function Vector2toUDim2(vec: Vector2)
	return UDim2.fromOffset(vec.X, vec.Y)
end

--------------------------------------------------------------------------------------------------
-- Class

local Constructor = {}
local Particle = nil

--------------------------------------------------------------------------------------------------
-- Public Constructors

function Constructor.new(particleEmitter: Types.ParticleEmitter): Types.Particle
	local self: Types.Particle = setmetatable({

		--------------- PUBLIC PROPERTIES ---------------

		Color = particleEmitter.Color,
		Size = particleEmitter.Size,
		Texture = particleEmitter.Texture,
		Transparency = particleEmitter.Transparency,
		ZOffset = particleEmitter.ZOffset,

		EmissionDirection = particleEmitter.EmissionDirection,
		Lifetime = initNumberRange(particleEmitter.Lifetime),
		Rotation = initNumberRange(particleEmitter.Rotation),
		RotSpeed = initNumberRange(particleEmitter.RotSpeed),
		Speed = initNumberRange(particleEmitter.Speed),
		SpreadAngle = math.random(-particleEmitter.SpreadAngle, particleEmitter.SpreadAngle),
		
		Shape = particleEmitter.Shape,
		ShapeInOut = particleEmitter.ShapeInOut,
		ShapeStyle = particleEmitter.ShapeStyle,

		Acceleration = particleEmitter.Acceleration,

		--------------- PRIVATE PROPERTIES --------------

		_particleEmitter = particleEmitter,
		_started = os.clock(),
		_position = nil,
		_label = nil
		
	}, Particle)
	
	local x, y = particleEmitter.Parent.AbsoluteSize.X, particleEmitter.Parent.AbsoluteSize.Y
	local position = UDim2.fromOffset(math.random() * x, math.random() * y)
	local size = initNumberSequence(particleEmitter.Size)
	self._position = position
	
	local label = Instance.new("ImageLabel")
	label.Name = "Particle"
	label.AnchorPoint = Vector2.one / 2
	label.BackgroundTransparency = 1
	label.Position = position
	label.Rotation = initNumberRange(particleEmitter.Rotation)
	label.Size = UDim2.fromOffset(size, size)
	label.ZIndex = particleEmitter.ZOffset or 1
	label.Image = particleEmitter.Texture
	label.ImageColor3 = initColorSequence(particleEmitter.Color)
	label.Parent = particleEmitter.Parent
	self._label = label
	
	return self
end

--------------------------------------------------------------------------------------------------
-- Public Methods

Particle = {}
Particle.__index = Particle

function Particle.Update(self: Types.Particle, dt: number): ()
	local alpha = math.min(1, (os.clock() - self._started) / self.Lifetime)
	local target do
		local eval = evalDirection(self.EmissionDirection)
		local theta = math.rad(self.SpreadAngle)
		local direction = Vector2.new(
			eval.X * math.cos(theta) - eval.Y * math.sin(theta),
			eval.X * math.sin(theta) + eval.Y * math.cos(theta)
		)
		
		target = Vector2toUDim2(direction * (self.Speed * self.Lifetime))
	end
	
	do
		local offset = self._position + target
		local color = self.Color
		local size = self.Size
		
		if typeof(self.Color) == "ColorSequence" then
			color = evalColorSequence(self.Color, alpha)
		end
		
		if typeof(self.Size) == "NumberSequence" then
			size = evalNumberSequence(self.Size, alpha)
		end
		
		self._label.Size = UDim2.fromOffset(size, size)
		self._label.Position = lerpUDim2(self._position, offset, alpha)
		self._label.ImageColor3 = color
		self._label.Rotation += self.RotSpeed * dt
	end
	
	return true
end

function Particle.Destroy(self: Types.Particle): ()
	self._label:Destroy()
	setmetatable(self, nil)
end

--------------------------------------------------------------------------------------------------
-- Callback

return Constructor
