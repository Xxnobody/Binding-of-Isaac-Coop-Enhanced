local mod = CoopEnhanced;

local Registry = mod.Registry;
local Callbacks = mod.Callbacks;

function Registry.AddCallback(modID, callbackID, func, ...)
	if not callbackID or type(callbackID) ~= "number" or callbackID < 0 or callbackID > Callbacks.NUM_CALLBACKS or not Registry.Callbacks[callbackID] then
		mod.Debug('Invalid Callback ID ' .. (callbackID or "nil") .. " entered.");
		return;
	end
	table.insert(Registry.Callbacks[callbackID],{CallbackID = callbackID,Function = func,Params = {...},Priority = 0});
end

function Registry.AddPriorityCallback(modID, callbackID, priority, func, ...)
	priority = priority or 0;
	if not callbackID or type(callbackID) ~= "number" or callbackID < 0 or callbackID > Callbacks.NUM_CALLBACKS or not Registry.Callbacks[callbackID] then
		mod.Debug('Invalid Callback ID ' .. callbackID .. " entered.");
		return;
	end
	
	local index = 1
	for i = #Registry.Callbacks[callbackID], 1, -1 do
		local callback = Registry.Callbacks[callbackID][i];
		if priority >= callback.Priority then
			index = i + 1;
			break;
		end
	end
	table.insert(Registry.Callbacks[callbackID], index, {CallbackID = callbackID,Function = func,Params = {...},Priority = priority});
end

function Registry.RemoveCallback(modID, callbackID, func)
	if not callbackID then return; end
	if type(callbackID) ~= "number" or callbackID < 0 or callbackID > Callbacks.NUM_CALLBACKS or not Registry.Callbacks[callbackID] then
		mod.Debug('Invalid Callback ID ' .. callbackID .. " entered.");
		return;
	end
	for i = #Registry.Callbacks[callbackID], 1, -1 do
		local callback = Registry.Callbacks[callbackID][i];
		if func == callback.Function then
			table.remove(Registry.Callbacks[callbackID],i);
			return;
		end
	end
	print("Function in callback ID " .. callbackID .. " no found! Cannot remove Callback.")
end

function Registry.RegisterCallback(modID, callback_name)
	if Callbacks[callback_name] ~= nil then mod.Debug('Callback with name' .. callback_name .. " already registered!."); return; end
	local new_index = 0;
	for callback,i in pairs(Callbacks) do
		new_index = math.max(new_index,i);
	end
	Callbacks.NUM_CALLBACKS = Callbacks.NUM_CALLBACKS + 1;
	Callbacks[callback_name] = new_index;
	Registry.Callbacks[new_index] = {};
end

function Registry.ExecuteCallback(modID, callbackID, ...)
	local callbacks = Registry.Callbacks[callbackID];
	if not callbacks then return; end
	for _, callback in ipairs(callbacks) do
		callback.Function(...);
	end
end