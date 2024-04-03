extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -800.0
const MAX_GRAVITY = 300
const GRAVITY = 8
var player_node

signal hit_player()
signal crab_perished()

func setup(player: Player):
	player_node = player
	position = Vector2(1000,500)

func _physics_process(delta: float) -> void:
	
	var distance = player_node.position.x- position.x
	
	var direction = sign(distance)
	velocity.x = direction * clamp(abs(distance), 0, SPEED)
	if is_on_floor() and (position.y > player_node.position.y):
		jump()
	
	process_down_velocity()

	move_and_slide()

func process_down_velocity() -> void:
	velocity.y = move_toward(velocity.y, MAX_GRAVITY, GRAVITY)

func jump() -> void:
	velocity.y = JUMP_VELOCITY

func perish() -> void:
	crab_perished.emit()
	queue_free()

func _on_left_claw_area_body_entered(body):
	if body == player_node:
		hit_player.emit()

func _on_right_claw_area_body_entered(body):
	if body == player_node:
		hit_player.emit()

func _on_vulnerable_area_area_entered(area):
	if area == player_node.attack_box_area:
		perish()
