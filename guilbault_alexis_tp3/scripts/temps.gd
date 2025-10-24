extends Label

var temps = 0

func _process(_delta: float) -> void:
	temps += 1
	text = "temps : " + var_to_str(floor(temps/60)) + "s"
