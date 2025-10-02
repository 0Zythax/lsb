local objectManager = {};
objectManager.__index = objectManager;

function objectManager.new()
	local self = setmetatable({}, objectManager);
	self.objects = {};
	return self;
end

function objectManager:_log(content : string, isWarning : boolean)
	local fn = isWarning and warn or print;
	fn(string.format("[ObjectManager] %s", content));
end

function objectManager:getCategories(stringified : boolean)
	local categories = {};
	for category, _ in next, self.objects do
		table.insert(categories, category);
	end
	
	if stringified then
		return table.concat(categories, ",");
	else
		return categories;
	end
end

function objectManager:addCategory(category : string, class : ModuleScript)
	self.objects[category] = {
		instances = {};
		class = class;
	};
	
	self:_log("Added category "..category, false);
end

function objectManager:loadObject(category : string, object : Instance)
	if self.objects[category] == nil then
		self:_log(category.." does not exist!", true)
		return false;
	end
	
	if self.objects[category].instances[object] ~= nil then
		self:_log(category.." is already loaded.", true)
	end
	
	self.objects[category].instances[object] = {};
	self.objects[category].instances[object].instance = object;
	self.objects[category].instances[object].object = self.objects[category].class.new(object);
	self:_log("Loaded object "..object.Name.." with category "..category, false);
end

function objectManager:unloadObject(category : string, object : Instance)
	if self.objects[category] == nil then
		self:_log(category.." does not exist!", true)
		return false;
	end
	
	if self.objects[category].instances[object] == nil then
		self:_log(category.." is not loaded.", true)
	end
	
	self.objects[category].instances[object].object:Destroy();
	self.objects[category].instances[object] = nil;
	self:_log("Unloaded object "..object.Name.." with category "..category, false);
end

-- i'd use some tacky __index crap here but nah
function objectManager:getObject(object : Instance)
	for category, stuff in next, self.objects do
		for _, moreStuff in next, stuff.instances do
			if moreStuff.instance == object then
				return moreStuff;
			end
		end
	end;
	
	self:_log(object.Name.." was not found!", true);
	return nil;
end

return objectManager;
