extends Enemy

const SPEED = 300.0
const MAX_GRAVITY = 40
const GRAVITY = 4
const DECCELERATION = 3
const FLOAT_COOLDOWN_MS = 3000

var float_direction: Vector2
var last_float_time: int

func setup(player: Player, new_position: Vector2, enemy_type: E.EnemyType = E.EnemyType.JELLYFISH):
	super(player, new_position, enemy_type)

func _physics_process(delta: float) -> void:
	
	var cur_time = Time.get_ticks_msec()
	if (cur_time - last_float_time) > FLOAT_COOLDOWN_MS:
		last_float_time = cur_time
		new_float()
	
	process_float()

	move_and_slide()

func process_down_velocity() -> void:
	velocity.y = move_toward(velocity.y, MAX_GRAVITY, GRAVITY)

func new_float() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = Time.get_ticks_msec()
	var float_direction_radians = rng.randf_range(-2.2, -0.8)
	var float_vector = Vector2.from_angle(float_direction_radians)
	velocity = float_vector * SPEED

func process_float() -> void:
	velocity.x = move_toward(velocity.x, 0, DECCELERATION / 2)
	velocity.y = move_toward(velocity.y, 0, DECCELERATION)
	velocity.y = move_toward(velocity.y, MAX_GRAVITY, GRAVITY)

func _on_attack_area_entered(body):
	print("jelly attack")
	super(body)

func _on_vulnerable_area_area_entered(area):
	print("jelly hit")
	super(area)
