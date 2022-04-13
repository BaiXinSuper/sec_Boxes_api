menu.notify("Boxes V0.1\nhttps://github.com/BaiXinSuper/sec_Boxes_api", "Universe", 13);--开发可删，删除后必须标注来源
local function intToIp(num)
	local ip = "";
	local int16 = string.format("%x", num);
	local var_int;
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
local function escape_postype(a, b)
	if a == "pos" then
		return b;
	elseif a == "pid" then
		return player.get_player_coords(b), player.get_player_heading(b);
	elseif a == "entity" then
		return entity.get_enttiy_coords(b), entity.get_entity_heading(b);
	end;
end;
local function spawnRequest(hash, type, posc, postype)
	local pos, head = escape_postype(postype, posc);
	if not head then
		head = 0;
	end;
	local e;
	while not streaming.has_model_loaded(hash) do
		system.yield(0);
		streaming.request_model(hash);
	end;
	if type == "veh" then
		e = vehicle.create_vehicle(hash, pos, head, true, false);
	elseif type == "obj" then
		e = object.create_object(hash, pos, true, true);
	elseif type == "wobj" then
		e = object.create_world_object(hash, pos, true, true);
	else
		e = ped.create_ped(4, hash, pos, head, true, true);
	end;
	entity.set_entity_as_no_longer_needed(e);
	return e;
end;
Boxes = {};
Boxes.myPed = function()
	return player.get_player_ped(player.player_id());
end;
Boxes.myVeh = function()
	return player.get_player_vehicle(player.player_id());
end;
Boxes.myPos = function()
	return player.get_player_coords(player.player_id());
end;
Boxes.myHeal = function()
	return player.get_player_health(player.player_id());
end;
Boxes.MaxHeal = function(who)
	return ped.get_ped_max_health(who);
end;
Boxes.HalfGod = function(name, id)
	return menu.add_feature(name, "toggle", id, function(a)
		while a.on do
			system.yield(0);
			if Boxes.myHeal() ~= Boxes.MaxHeal(Boxes.myPed()) then
				ped.set_ped_health(Boxes.myPed(), Boxes.MaxHeal(Boxes.myPed()));
			end;
		end;
	end);
end;
Boxes.getIp = function(id)
	return intToIp(player.get_player_ip(id));
end;
Boxes.whoIsSpeMe = function()
	local alist = {};
	for pid = 0, 31 do
		if pid ~= player.player_id() and player.is_player_valid(pid) and player.is_player_spectating(pid) and player.get_player_player_is_spectating(pid) == player.player_id() then
			alist[(#alist) + 1] = pid;
		end;
	end;
	return alist;
end;
Boxes.whoIsAimMe = function()
	local alist = {};
	for pid = 0, 31 do
		if pid ~= player.player_id() and player.is_player_valid(pid) and player.is_player_free_aiming(pid) and player.get_entity_player_is_aiming_at(pid) == Boxes.myPed() then
			alist[(#alist) + 1] = pid;
		end;
	end;
	return alist;
end;
Boxes.tokenSort = function()
	local alist = {};
	for pid = 0, 31 do
		if player.is_player_valid(pid) then
			alist[player.get_player_host_priority(pid)] = pid;
		end;
	end;
	return alist;
end;
Boxes.spawn = function(e, pos)
	local postype, rte;
	if (tostring(pos)):match("^v3.*,.*,.*") then
		postype = "pos";
	elseif 1 <= (#tostring(pos)) and #tostring(pos) <= 2 then
		postype = "pid";
	else
		postype = "entity";
	end;
	if streaming.is_model_valid(e) then
		if streaming.is_model_a_vehicle(e) then
			rte = spawnRequest(e, "veh", pos, postype);
		elseif streaming.is_model_an_object(e) then
			rte = spawnRequest(e, "obj", pos, postype);
		elseif streaming.is_model_a_world_object(e) then
			rte = spawnRequest(e, "wobj", pos, postype);
		elseif streaming.is_model_a_ped(e) then
			rte = spawnRequest(e, "ped", pos, postype);
		end;
		return rte;
	end;
end;
