extends Node2D

var player_template = preload("res://player.tscn")
var enemy_template = preload("res://enemy.tscn")

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = player_template.instantiate()
	add_child(player)
	
	spawn_crab()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hit_player():
	pass

func spawn_crab():
	var enemy = enemy_template.instantiate()
	enemy.setup(player)
	enemy.hit_player.connect(_on_hit_player)
	enemy.crab_perished.connect(spawn_crab)
	add_child(enemy)
