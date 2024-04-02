extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 100
var player_node

func setup(player: Player):
	player_node = player
	position = Vector2(1000,500)
	
	
	
func _physics_process(delta: float) -> void:
	
	var distance = player_node.position.x- position.x
	if abs(distance) > SPEED:
		var direction = sign(distance)
		velocity.x = (direction * SPEED)
	else:
		velocity.x =0
	
	velocity.y = GRAVITY

	move_and_slide()
