extends Enemy

const MAX_GRAVITY = -300
const GRAVITY = 10
const DECCELERATION = 3
const FLOAT_TIME = 1000

var time_spawned: int

func setup(player: Player, new_position: Vector2, enemy_type: E.EnemyType = E.EnemyType.BUBBLE):
	time_spawned = Time.get_ticks_msec()
	super(player, new_position, enemy_type)

func enemy_physics_process(delta: float) -> void:
	var current_game_time = Time.get_ticks_msec()
	if current_game_time - time_spawned > FLOAT_TIME:
		process_up_velocity(delta)
		process_decceleration(delta)
	
	if position.y < 100:
		pop()

func process_decceleration(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, DECCELERATION / 2 * delta)

func process_up_velocity(delta: float) -> void:
	velocity.y = move_toward(velocity.y, MAX_GRAVITY, GRAVITY * delta)

func process_rotate() -> void:
	var current_game_time = Time.get_ticks_msec()
	var time_since_spawn = current_game_time - time_spawned
	rotation_degrees = sin(float(time_since_spawn) / 150.0) * 8

func pop() -> void:
	queue_free()

func _on_attack_area_entered(body):
	super(body)

func _on_vulnerable_area_area_entered(area):
	super(area)
