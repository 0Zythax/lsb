-- probably could have made this better but oh well
local playerCooldownManager = {};
playerCooldownManager.__index = playerCooldownManager;

local staticCooldownManager = {};
staticCooldownManager.__index = staticCooldownManager;

local cooldownManager = {};
cooldownManager.__index = cooldownManager;

function cooldownManager.new(type : string)
	local tbl = type == "player" and playerCooldownManager or staticCooldownManager;
	local self = setmetatable({}, tbl);
	self.cooldowns = {};
	return self;
end

-- static

function staticCooldownManager:add(item : string, time : number)
	self.cooldowns[item] = tick() + time;
end

function staticCooldownManager:onCooldown(item : string)
	if self.cooldowns[item] == nil or self.cooldowns[item] < tick() then
		if self.cooldowns[item] then
			self.cooldowns[item] = nil;
		end
		return false;
	end
	return true;
end

-- player

function playerCooldownManager:register(player : Player)
	self.cooldowns[player] = {};
end

function playerCooldownManager:deregister(player : Player)
	if self.cooldowns[player] then
		self.cooldowns[player] = nil;
	end
end

function playerCooldownManager:isOnCooldown(player : Player, item : string)
	if self.cooldowns[player] == nil then return false end;
	
	if self.cooldowns[player][item] == nil or self.cooldowns[player][item] < tick() then
		if self.cooldowns[player][item] then
			self.cooldowns[player][item] = nil;
		end
		return false;
	end
	return true;
end

return cooldownManager;
