extends Enemy

const SPEED = 300.0
const EXPANDED_SPEED = 100.0
const MAX_GRAVITY = 300
const GRAVITY = 8

var large_body_shape = preload("res://shapes/pufferfish_large_body.tres")
var large_attack_shape = preload("res://shapes/pufferfish_large_attack_body.tres")
var small_body_shape = preload("res://shapes/pufferfish_small_body.tres")

var expanded: bool
var expand_start_time: int
var expand_end_time: int

func setup(player: Player, new_position: Vector2, enemy_type: E.EnemyType = E.EnemyType.PUFFERFISH):
	super(player, new_position, enemy_type)
	shrink()

func _physics_process(delta: float) -> void:
	
	var player_direction = player_node.position - position
	velocity = player_direction.normalized()
	if expanded:
		velocity = velocity * EXPANDED_SPEED
	else:
		velocity = velocity * SPEED
	
	var distance_from_player = position.distance_to(player_node.position)
	if distance_from_player < 500:
		var current_game_time = Time.get_ticks_msec()
		if current_game_time - expand_end_time > 3000:
			expand()
	
	process_shrink()

	move_and_slide()

func expand() -> void:
	if not expanded:
		expanded = true
		expand_start_time = Time.get_ticks_msec()
		$AnimatedSprite2D.animation = "large"
		$AttackArea/CollisionShape2D.shape = large_attack_shape
		$VulnerableArea/CollisionShape2D.shape = null
		$CollisionShape2D.shape = large_body_shape

func shrink() -> void:
	expanded = false
	$AnimatedSprite2D.animation = "small"
	$AttackArea/CollisionShape2D.shape = null
	$VulnerableArea/CollisionShape2D.shape = small_body_shape
	$CollisionShape2D.shape = small_body_shape
	rotation_degrees = 0

func process_shrink() -> void:
	if expanded:
		var current_game_time = Time.get_ticks_msec()
		var time_expanded = current_game_time - expand_start_time
		rotation_degrees = sin(float(time_expanded) / 150.0) * 15
		
		if time_expanded > 3000:
			shrink()
			expand_end_time = Time.get_ticks_msec()

func _on_attack_area_entered(body):
	super(body)

func _on_vulnerable_area_area_entered(area):
	super(area)
