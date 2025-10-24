extends Node2D

var hspeed = 0

var xstart = 0

var speedState = 0
var stateTimer = 0

enum States {
	GAUCHE,
	ARRET,
	DROITE
}

func _process(_delta: float) -> void:
	if xstart == 0:
		xstart = position.x
		stateTimer = randi_range(45,75)
	
	match speedState:
		States.GAUCHE:
			hspeed = -1
			$"./AnimatedSprite2D".play()
		States.ARRET:
			hspeed = 0
			stateTimer -= 1
			$"./AnimatedSprite2D".stop()
		States.DROITE:
			hspeed = 1
			$"./AnimatedSprite2D".play()
	
	if position.x <= xstart - 45 || position.x >= xstart + 45:
		speedState = States.ARRET
	
	if stateTimer == 0:
		if position.x < xstart:
			speedState = States.DROITE
		else:
			speedState = States.GAUCHE
		stateTimer = randi_range(45,75)

	position.x += hspeed
