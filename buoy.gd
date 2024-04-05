extends CharacterBody2D

var x_position: int

func setup(x_position: int):
	$ColorRect/Label.text = str(x_position)
	position.x = x_position
	position.y = 100

func _physics_process(delta):
	process_float()

func process_float() -> void:
	var current_game_time = Time.get_ticks_msec()
	rotation_degrees = sin(float(current_game_time) / 375.0) * 15
	position.y = sin(float(current_game_time) / 750.0) * 15
