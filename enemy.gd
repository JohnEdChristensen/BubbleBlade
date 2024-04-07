class_name Enemy

extends CharacterBody2D

var hit_shader_material = preload("res://assets/hit_shader_material.tres")
var dead_shader_material = preload("res://assets/death_shader_material.tres")
var hit_crab_shader_material = preload("res://assets/hit_crab_shader_material.tres")
var dead_crab_shader_material = preload("res://assets/death_crab_shader_material.tres")

const MAX_X_VELOCITY = 2000
const MAX_Y_VELOCITY = 1000
const DECCELERATION = 300.0

var player_node
var hp: int = 0
var enemy_type: E.EnemyType
var was_hit: bool
var perishing: bool

signal hit_player(enemy_type: E.EnemyType)
signal perished(enemy_type: E.EnemyType, perish_position: Vector2)

func setup(player: Player, new_position: Vector2, new_enemy_type: E.EnemyType):
	enemy_type = new_enemy_type
	player_node = player
	position = new_position
	was_hit = false
	perishing = false

func _physics_process(delta: float) -> void:
	if abs(position.x - player_node.position.x) < 2000 and (not perishing):
		velocity.x = clamp(velocity.x, MAX_X_VELOCITY * -1, MAX_X_VELOCITY)
		velocity.y = clamp(velocity.y, MAX_Y_VELOCITY * -1, MAX_Y_VELOCITY)
		enemy_physics_process(delta)
	if perishing:
		velocity.x = clamp(velocity.x, MAX_X_VELOCITY * -1, MAX_X_VELOCITY)
		velocity.y = clamp(velocity.y, MAX_Y_VELOCITY * -1, MAX_Y_VELOCITY)
		velocity.x = move_toward(velocity.x, 0, DECCELERATION / 2.0 * delta)
		velocity.y = move_toward(velocity.y, 0, DECCELERATION * delta)
		move_and_slide()

func enemy_physics_process(delta: float) -> void:
	pass

func hit() -> void:
	was_hit = true
	var on_hit_shader_material
	
	match enemy_type:
		E.EnemyType.CRAB:
			on_hit_shader_material = hit_crab_shader_material
		_:
			on_hit_shader_material = hit_shader_material
			
	$Sprite.material = on_hit_shader_material
	$AttackArea.monitoring = false
	await get_tree().create_timer(2.0).timeout
	$AttackArea.monitoring = true
	$Sprite.material = null
	was_hit = false

func perish() -> void:
	if enemy_type != E.EnemyType.BUBBLE:
		perishing = true
		var on_dead_shader_material
		match enemy_type:
			E.EnemyType.CRAB:
				on_dead_shader_material = dead_crab_shader_material
			_:
				on_dead_shader_material = dead_shader_material
			
		$Sprite.material = on_dead_shader_material
		await get_tree().create_timer(2.0).timeout
		$Sprite.material = null
		perishing = false
	perished.emit(enemy_type, position)
	queue_free()
	
func _on_attack_area_entered(body):
	if body == player_node:
		hit_player.emit(enemy_type)

func _on_vulnerable_area_area_entered(area):
	if (area == player_node.attack_box_area) and (not was_hit):
		velocity = velocity + (player_node.velocity * 2.5)
		hp = hp - player_node.damage
		if hp <= 0:
			perish()
		else:
			hit()
