extends Label

func _process(_delta: float) -> void:
	text = var_to_str($"../../../joueur".lap) + "/3"
