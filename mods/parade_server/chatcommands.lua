minetest.register_privilege("parade_server","Can use parade_local commands")

minetest.register_chatcommand("pStart",{
	params = "",
	description = "",
	privs = {parade_server=true},
	func = function ()
		parade_server.Started = true
		if ps.camera ~= nil then
			ps.camera:setpos(ps.camera_start_pos)
		end
	end
})

minetest.register_chatcommand("pStop",{
	params = "",
	description = "",
	privs = {parade_server=true},
	func = function ()
		parade_server.Started = false
	end
})

minetest.register_chatcommand("pCamSpeed",{
	params = "speed",
	description = "",
	privs = {parade_server=true},
	func = function (name,speed)
		ps.CameraSpeed = tonumber(speed)
	end
})

minetest.register_chatcommand("pCamDeltaTime",{
	params = "",
	description = "",
	privs = {parade_server=true},
	func = function (name,deltaTime)
		ps.DeltaTime = tonumber(deltaTime)
	end
})

minetest.register_chatcommand("pRefresh",{
	params = "",
	description = "",
	privs = {parade_server=true},
	func = function (name)
		clear_last_files()
		ps.next_region = copy_table(ps.start_region)

    	worldedit.set(ps.start_air_region.pos1,ps.air_region.pos2,worldedit.normalize_nodename("air"))
    	worldedit.set(ps.start_dirt_region.pos1,ps.dirt_region.pos2,worldedit.normalize_nodename("dirt_with_grass"))
		
		ps.air_region.pos1 = copy_table(ps.start_air_region.pos1)
		ps.air_region.pos2 = copy_table(ps.start_air_region.pos2)

		ps.dirt_region.pos1 = copy_table(ps.start_dirt_region.pos1)
		ps.dirt_region.pos2 = copy_table(ps.start_dirt_region.pos2)

		ps.float_max_x = 0
		ps.float_count = 0

		for key,val in ipairs(list_dir_diff(ps.schematic_folder)) do
			worldedit.pos1["WorldController"] = ps.next_region
			loadSchematic(val)
			ps.next_region.x = ps.next_region.x + ps.step_region
			ps.air_region.pos1.x = ps.air_region.pos1.x + ps.step_region
			ps.air_region.pos2.x = ps.air_region.pos2.x + ps.step_region
			ps.dirt_region.pos1.x = ps.dirt_region.pos1.x + ps.step_region
			ps.dirt_region.pos2.x = ps.dirt_region.pos2.x + ps.step_region
			ps.float_count = ps.float_count + 1
		end

		ps.float_max_x = ps.camera_start_pos.x - ps.float_count*40 + 20

		ps.Timer = 0.0
	end
})