local function intToIp(num)
	local ip = "";
	local int16 = string.format("%x", num);
	for i = 1, #int16 do
		if math.fmod(i, 2) == 0 then
			if ip ~= "" then
				ip = ip .. "." .. var_int;
			else
				ip = var_int;
			end;
		else
			var_int = tostring(tonumber(string.sub(int16, i, i + 1), 16));
		end;
	end;
	return ip;
end;
Boxes = {};
Boxes.myPed = function()--Ped/Int/Entity
	return player.get_player_ped(player.player_id());
end;
Boxes.myVeh = function()--Veh/Int/Entity
	return player.get_player_vehicle(player.player_id());
end;
Boxes.myPos = function()--v3
	return player.get_player_coords(player.player_id());
end;
Boxes.myHeal = function()--float
	return player.get_player_health(player.player_id());
end;
Boxes.MaxHeal = function(who)--float
	return ped.get_ped_max_health(who);
end;
Boxes.HalfGod = function(name, id)--void
	return menu.add_feature(name, "toggle", id, function(a)
		while a.on do
			system.yield(0);
			if Boxes.myHeal() ~= Boxes.MaxHeal(Boxes.myPed()) then
				ped.set_ped_health(Boxes.myPed(), Boxes.MaxHeal(Boxes.myPed()));
			end;
		end;
	end);
end;
Boxes.getIp = function(id)--str
	return intToIp(player.get_player_ip(id));
end;
Boxes.whoIsSpeMe = function() --array<int>
    local alist={};
    for pid=0,31 do
        if pid~=player.player_id() and player.is_player_valid(pid) and player.is_player_spectating(pid) and player.get_player_player_is_spectating(pid)==player.player_id() then
            alist[#alist+1]=pid;
        end;
    end;
    return alist;
end;
Boxes.whoIsAimMe=function ()--array<int>
    local alist={};
    for pid=0,31 do
        if pid~=player.player_id() and player.is_player_valid(pid) and player.is_player_free_aiming(pid) and player.get_entity_player_is_aiming_at(pid)==Boxes.myPed() then
            alist[#alist+1]=pid;
        end;
    end;
    return alist;
end;
Boxes.tokenSort=function ()--array<int>
    local alist={};
    for pid=0,31 do
        if player.is_player_valid(pid) then
            alist[player.get_player_host_priority(pid)]=pid;
        end;
    end;
    return alist;
end;