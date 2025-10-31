extends Label

func _input(_event):
	if Input.is_action_just_pressed("Item"):
		$"./AudioStreamPlayer".play()
		get_tree().change_scene_to_file("res://scenes/pieces/plaines_menthe1.tscn")
