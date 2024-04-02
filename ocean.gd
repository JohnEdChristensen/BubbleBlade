extends Node2D

var player_template = preload("res://player.tscn")
var enemy_template = preload("res://enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = player_template.instantiate()
	add_child(player)
	
	var enemy = enemy_template.instantiate()
	enemy.setup(player)
	add_child(enemy)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
