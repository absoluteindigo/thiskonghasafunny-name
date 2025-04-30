local k = {
	'set_object_visibility',
	'obj_check_if_facing_toward_angle',
	'create_respawner',
	'spawn_orange_number',
	'obj_find_wall_displacement',
	'obj_lava_death',
	'obj_check_floor_death',
	'OBJ_COL_FLAG_HIT_WALL',
	'is_point_within_radius_of_mario',
	'OBJ_COL_FLAG_NO_Y_VEL',
	'trigger_obj_dialog_when_facing',
	'OBJ_COL_FLAG_GROUNDED',
	'current_mario_room_check',
	'is_point_close_to_object',
	'obj_flicker_and_disappear',
	'turn_obj_away_from_surface',
	'obj_spawn_yellow_coins',
	'curr_obj_random_blink',
	'obj_find_wall',
	'OBJ_COL_FLAGS_LANDED',
	'obj_return_and_displace_home',
	'obj_return_home_if_safe',
	'obj_orient_graph',
	'turn_obj_away_from_steep_floor',
	'calc_obj_friction',
	'obj_move_xyz_using_fvel_and_yaw',
	'object_step',
	'OBJ_COL_FLAG_UNDERWATER',
	'obj_splash',
	'set_yoshi_as_not_dead',}

local v,get = '', ''
for _, k in pairs(k) do
	v = v ..     `{k},`
	get = get .. `ObjBehaviors.{k},`
end
warn(
	string.sub(v, 1, #v - 1)
		.. '=' ..
		string.sub(get, 1, #get - 1)
)