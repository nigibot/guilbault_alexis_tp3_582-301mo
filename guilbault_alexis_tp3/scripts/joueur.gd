extends Node

var lane = 3
var laneSwitch = 0

var vspeed = 0
var vgoal = 0

var hspeed = 0
var maxspeed = 7
var minspeed = -7

var lap = 1

var boostitem = false
var boosttimer = 0

var accelerating = 0

var rng = RandomNumberGenerator.new()

var gravityMode = false

enum States {
	NORMAL,
	OFFROAD,
	BOOST,
	WIND,
	HOLE,
	WATER
}

var speed_state = States.NORMAL

func _ready() -> void:
	$"./AnimatedSprite2D".animation = "normal"

func _input(_event):
	if Input.is_action_just_pressed("Up") && hspeed != 0 && gravityMode == false && speed_state != States.HOLE:
		if lane != 1 and vspeed == 0:
			lane -= 1
			$"../joueur".rotation = deg_to_rad(-15) 
			vspeed = -4
			$"./AudioStreamPlayer".play()
	
	if Input.is_action_just_pressed("Down") && hspeed != 0 && gravityMode == false && speed_state != States.HOLE:
		if lane != 5 and vspeed == 0:
			lane += 1
			$"../joueur".rotation = deg_to_rad(15) 
			vspeed = 4
			$"./AudioStreamPlayer".play()
	
	if Input.is_action_pressed("Accelerate"):
		accelerating = 1
	elif Input.is_action_pressed("Deccelerate"):
		accelerating = -1
	else:
		accelerating = 0
	
	if Input.is_action_pressed("Item") && boostitem == true:
		print("BOOOOOSTTT !!!")
		boosttimer = 90
		boostitem = false
	
	if Input.is_action_pressed("Pause"):
		get_tree().change_scene_to_file("res://scenes/pieces/menu.tscn")

func _process(_delta: float) -> void:
	if boosttimer != 0:
		boosttimer -= 1
		speed_state = States.BOOST
	elif speed_state == States.BOOST:
		print("Retour à la normale")
		speed_state = States.NORMAL
	
	match speed_state:
		States.NORMAL:
			maxspeed = 7
		States.OFFROAD:
			maxspeed = 3
		States.WIND:
			maxspeed = 4
		States.HOLE:
			maxspeed = 1
		States.BOOST:
			maxspeed = 20
			hspeed = maxspeed
	
	match accelerating:
		-1:
			hspeed -= 0.15
		1:
			hspeed += 0.1
	
	if hspeed < minspeed:
		hspeed = minspeed
	
	if hspeed > maxspeed:
		hspeed = maxspeed
	
	if hspeed > 1 or hspeed < -1:
		$"./AnimatedSprite2D".speed_scale = hspeed/2
		$"./AnimatedSprite2D".play()
		if speed_state == States.NORMAL:
			$"./AudioStreamPlayer2".play()
			$"./AnimatedSprite2D".animation = "normal"
		else:
			$"./AudioStreamPlayer2".stop()
		
		if speed_state == States.OFFROAD:
			$"./AudioStreamPlayer3".play()
			$"./AnimatedSprite2D".animation = "offroad"
		else:
			$"./AudioStreamPlayer3".stop()
		
		if speed_state == States.WIND:
			$"./AudioStreamPlayer3".play()
			$"./AnimatedSprite2D".animation = "offroad"
		else:
			$"./AudioStreamPlayer3".stop()
		
		if speed_state == States.BOOST:
			$"./AudioStreamPlayer4".play()
			$"./AnimatedSprite2D".animation = "boost"
		else:
			$"./AudioStreamPlayer4".stop()
	else:
		$"./AudioStreamPlayer2".stop()
		$"./AudioStreamPlayer3".stop()
		$"./AudioStreamPlayer4".stop()
	
	match lane:
		1:
			vgoal = 287
		2:
			vgoal = 351
		3:
			vgoal = 415
		4:
			vgoal = 479
		5:
			vgoal = 543
	
	if $"../joueur".position.y == vgoal:
		$"../joueur".rotation = 0
		vspeed = 0
		gravityMode = false
	
	if gravityMode == true:
		vspeed += 0.5
	
	$"../joueur".position.y += vspeed
	$"../joueur".position.x += hspeed

func _on_area_2d_area_entered(area):
	if area.is_in_group("epine"):
		area.queue_free()
		$"../joueur".position.x -= 16
		hspeed = 0
		boosttimer = 0
		boostitem = false
		$"./CollisionEpine".play()
	
	if area.is_in_group("but") && hspeed >= 0:
		$"../joueur".position.x = 576
		lap += 1
		print(var_to_str(lap) + "/3")
		$"./LapFinished".play()
	elif area.is_in_group("but"):
		$"../joueur".position.x = 576
		lap -= 1
		print(var_to_str(lap) + "/3")
		$"./CollisionEpine".play()
	
	if area.is_in_group("horspiste") && speed_state == States.NORMAL:
		print("Hors-piste !!!!")
		speed_state = States.OFFROAD
	
	if area.is_in_group("boost"):
		print("Boost acquired")
		boostitem = true
	
	if area.is_in_group("crabe"):
		area.queue_free()
		$"../joueur".position.x -= 16
		hspeed = 0
		boosttimer = 0
		boostitem = false
		$"./CollisionCrabe".play()
	
	if area.is_in_group("crochet"):
		lane = 1
		$"../joueur".position.y = 287
		hspeed = 0
		boosttimer = 0
		boostitem = false
		$"./CollisionCrochet".play()
	
	if area.is_in_group("feuilles"):
		area.queue_free()
		if rng.randi_range(1,10) > 9:
			boostitem = true
	
	if area.is_in_group("vent"):
		print("Dans le vent !!!!")
		speed_state = States.WIND
	
	if area.is_in_group("trou") && gravityMode == false:
		print("Chute !")
		speed_state = States.HOLE
	
	if area.is_in_group("jumppad") && gravityMode == false && vspeed == 0:
		vspeed = -10
		boosttimer = 20
		$"../joueur".position.y -= 10
		gravityMode = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("horspiste") && speed_state == States.OFFROAD:
		print("Retour à la normale")
		speed_state = States.NORMAL
	
	if area.is_in_group("vent") && speed_state == States.WIND:
		print("Retour à la normale")
		speed_state = States.NORMAL
	
	if area.is_in_group("trou") && speed_state == States.HOLE:
		speed_state = States.NORMAL

func _on_animated_sprite_2d_animation_looped() -> void:
	if speed_state == States.HOLE :
		$"../joueur".position.x -= 50
		hspeed = 0
