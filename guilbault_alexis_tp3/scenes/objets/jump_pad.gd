extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("joueur"):
		$"./AnimatedSprite2D".animation = "spring"
		$"./AnimatedSprite2D".play()

func _on_animated_sprite_2d_animation_looped() -> void:
	$"./AnimatedSprite2D".animation = "idle"
