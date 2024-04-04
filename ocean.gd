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
	back_to_menu()

func spawn_crab():
	var enemy = enemy_template.instantiate()
	enemy.setup(player)
	enemy.hit_player.connect(_on_hit_player)
	enemy.crab_perished.connect(spawn_crab)
	call_deferred("add_child", enemy)


func back_to_menu():
	var main_menu_template = load("res://main_menu.tscn")
	var main_menu = main_menu_template.instantiate()
	get_parent().add_child(main_menu)
	queue_free()
