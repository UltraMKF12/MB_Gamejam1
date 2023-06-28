extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN, 0)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
