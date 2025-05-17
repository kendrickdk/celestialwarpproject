extends Label

func _process(delta):
	var world_pos = get_global_mouse_position()
	text = "Mouse Position: " + str(world_pos)
