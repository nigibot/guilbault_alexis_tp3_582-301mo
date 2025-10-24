extends Label

func _process(_delta: float) -> void:
	text = "tours : " + var_to_str($"../../../joueur".lap) + "/3"
