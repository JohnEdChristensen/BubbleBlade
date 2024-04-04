class_name Enemy

extends CharacterBody2D

var player_node
var enemy_type: E.EnemyType

signal hit_player(enemy_type: E.EnemyType)
signal perished(enemy_type: E.EnemyType)

func setup(player: Player, new_position: Vector2, new_enemy_type: E.EnemyType):
	enemy_type = new_enemy_type
	player_node = player
	position = new_position

func perish() -> void:
	perished.emit(enemy_type)
	queue_free()
	
func _on_attack_area_entered(body):
	if body == player_node:
		hit_player.emit(enemy_type)

func _on_vulnerable_area_area_entered(area):
	if area == player_node.attack_box_area:
		perish()
