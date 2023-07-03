extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN, 0)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("dig"):
		var mouse_pos = get_global_mouse_position()
		var map_coord = $Ground.local_to_map(mouse_pos)
		
		var data_ground = $Ground.get_cell_tile_data(0, map_coord)
		if data_ground:
			print("Hit Ground")
