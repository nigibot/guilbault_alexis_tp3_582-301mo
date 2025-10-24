extends Label

func _input(_event):
	if Input.is_action_just_pressed("Choix1"):
		$"./AudioStreamPlayer".play()
		get_tree().change_scene_to_file("res://scenes/pieces/plaines_menthe1.tscn")
	
	if Input.is_action_just_pressed("Choix2"):
		$"./AudioStreamPlayer".play()
		get_tree().change_scene_to_file("res://scenes/pieces/lac_azur1.tscn")
