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

var rng = RandomNumberGenerator.new()

enum States {
	NORMAL,
	OFFROAD,
	BOOST
}

var speed_state = States.NORMAL

func _input(_event):
	if Input.is_action_just_pressed("Up") && hspeed != 0:
		if lane != 1 and vspeed == 0:
			lane -= 1
			$"../joueur".rotation = deg_to_rad(-15) 
			vspeed = -4
			$"./AudioStreamPlayer".play()
	
	if Input.is_action_just_pressed("Down") && hspeed != 0:
		if lane != 5 and vspeed == 0:
			lane += 1
			$"../joueur".rotation = deg_to_rad(15) 
			vspeed = 4
			$"./AudioStreamPlayer".play()
	
	if Input.is_action_pressed("Accelerate"):
		if hspeed < maxspeed:
			hspeed += 0.2
	
	if Input.is_action_pressed("Deccelerate"):
		if hspeed > minspeed:
			hspeed -= 0.3
	
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
		States.BOOST:
			maxspeed = 20
			hspeed = maxspeed
	
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
		if lap == 4:
			get_tree().change_scene_to_file("res://scenes/pieces/menu.tscn")
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

func _on_area_2d_area_exited(area):
	if area.is_in_group("horspiste") && speed_state == States.OFFROAD:
		print("Retour à la normale")
		speed_state = States.NORMAL
