class_name Enemy

extends CharacterBody2D

const MAX_VELOCITY = 1000

var player_node
var enemy_type: E.EnemyType

signal hit_player(enemy_type: E.EnemyType)
signal perished(enemy_type: E.EnemyType, perish_position: Vector2)

func setup(player: Player, new_position: Vector2, new_enemy_type: E.EnemyType):
	enemy_type = new_enemy_type
	player_node = player
	position = new_position

func _physics_process(delta: float) -> void:
	if abs(position.x - player_node.position.x) < 2000:
		enemy_physics_process(delta)
		velocity.x = clamp(velocity.x, MAX_VELOCITY * -1, MAX_VELOCITY)
		velocity.y = clamp(velocity.y, MAX_VELOCITY * -1, MAX_VELOCITY)

func enemy_physics_process(delta: float) -> void:
	pass

func perish() -> void:
	perished.emit(enemy_type, position)
	queue_free()
	
func _on_attack_area_entered(body):
	if body == player_node:
		hit_player.emit(enemy_type)

func _on_vulnerable_area_area_entered(area):
	if area == player_node.attack_box_area:
		perish()
