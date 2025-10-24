extends AnimatedSprite2D
var audio_joue = true
var temps

func _ready() -> void:
	$"../AudioStreamPlayer".play()

func _input(_event):
	if Input.is_action_just_pressed("Mute"):
		if audio_joue == true:
			temps = $"../AudioStreamPlayer".get_playback_position()
			$"../AudioStreamPlayer".stop()
			audio_joue = false
			frame = 1
		else:
			$"../AudioStreamPlayer".play()
			$"../AudioStreamPlayer".seek(temps)
			audio_joue = true
			frame = 0
