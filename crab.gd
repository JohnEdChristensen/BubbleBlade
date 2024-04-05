extends Enemy

const SPEED = 300.0
const JUMP_VELOCITY = -800.0
const MAX_GRAVITY = 300
const GRAVITY = 8

func setup(player: Player, new_position: Vector2, enemy_type: E.EnemyType = E.EnemyType.CRAB):
	super(player, new_position, enemy_type)

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

func _on_attack_area_entered(body):
	super(body)

func _on_vulnerable_area_area_entered(area):
	super(area)
