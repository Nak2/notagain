local Timers = Timers or {}

local old_timercreate  = timer.Create 
local old_timeradjust  = timer.Adjust
local old_timerremove  = timer.Remove 
local old_timerdestroy = timer.Destroy

__debug_timer_removal = function(name,time) -- can only be global :/
	if timer.Exists(name) then
		timer.Simple(time,function() __debug_timer_removal(name,time) end)
	else
		Timers[name] = nil 
	end
end

timer.Create = function(name,delay,rep,callback)
	Timers[name] = {
		Delay = delay,
		Repetitions = rep == 0 and "inf" or rep,
		Callback = callback,
	}
	
	if Timers[name].Repetitions ~= "inf" then
		timer.Simple(Timers[name].Repetitions,function() __debug_timer_removal(name,Timers[name].Repetitions) end)
	end
	
	old_timercreate(name,delay,rep,callback)
end

timer.Adjust = function(name,delay,rep,callback)
	if Timers[name] then
		Timers[name] = {
			Delay = delay,
			Repetitions = rep == 0 and "inf" or rep, 
			Callback = callback,
		}
	end
	
	return old_timeradjust(name,delay,rep,callback)

end

timer.Remove = function(name)
	if Timers[name] then
		Timers[name] = nil 
	end
	old_timerremove(name)
end

timer.Destroy = function(name)
	if Timers[name] then
		Timers[name] = nil 
	end
	old_timerdestroy(name)
end

timer.GetAll = function()
	return Timers 
end

timer.Find = function(tim)
	local found = {}
	for name,ti in pairs(Timers) do
		if string.match(tostring(name),tim,1) then
			found[name] = ti 
		end
	end
	return found 
end
