extends Label

func _process(_delta: float) -> void:
	match $"../../../joueur".boostitem:
		true:
			text = "BOOST !!"
		false:
			text = " "
