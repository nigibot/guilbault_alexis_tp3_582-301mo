extends Label

@onready var joueur = get_node("../../../joueur")
var temps = 0

func _process(_delta: float) -> void:
	var current_scene = get_tree().current_scene.name
	var time_limit = 0
	var next_scene = ""
	
	match current_scene:
		"plaines_menthes1":
			time_limit = 60 * 90
			next_scene = "res://scenes/pieces/lac_azur1.tscn"
		"lac_azur1":
			time_limit = 60 * 100
			next_scene = "res://scenes/pieces/foret_cramoisie1.tscn"
		"foret_cramoisie1":
			time_limit = 60 * 100
			next_scene = "res://scenes/pieces/nuage_vanille.tscn"
		"nuage_vanille":
			time_limit = 60 * 115
			next_scene = "res://scenes/pieces/menu.tscn"
		_:
			return
	
	if joueur.lap < 4:
		temps += 1
		text = str(floor(temps / 60)) + "s / " + str(time_limit/60) + "s"
	
	if joueur.lap >= 4:
		if temps < time_limit:
			add_theme_color_override("font_color", Color.GREEN)
			text = "SUCCÈS !"
			if Input.is_action_just_pressed("Item"):
				get_tree().change_scene_to_file(next_scene)
		else:
			set("theme_override_colors/font_color", Color.GREEN)
			text = "ÉCHEC !"
			if Input.is_action_just_pressed("Item"):
				get_tree().reload_current_scene()
