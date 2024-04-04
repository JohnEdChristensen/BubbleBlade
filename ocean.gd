extends Node2D

var player_template = preload("res://player.tscn")
var crab_template = preload("res://crab.tscn")
var pufferfish_template = preload("res://pufferfish.tscn")

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = player_template.instantiate()
	add_child(player)
	
	spawn_crab()
	spawn_pufferfish()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hit_player(_enemy_type: E.EnemyType):
	back_to_menu()

func _on_enemy_perished(enemy_type: E.EnemyType):
	match enemy_type:
		E.EnemyType.CRAB:
			spawn_crab()
		E.EnemyType.PUFFERFISH:
			spawn_pufferfish()

func spawn_crab():
	var crab = crab_template.instantiate()
	crab.setup(player, Vector2(1000, 500))
	crab.hit_player.connect(_on_hit_player)
	crab.perished.connect(_on_enemy_perished)
	call_deferred("add_child", crab)

func spawn_pufferfish():
	var pufferfish = pufferfish_template.instantiate()
	pufferfish.setup(player, Vector2(2000, 500))
	pufferfish.hit_player.connect(_on_hit_player)
	pufferfish.perished.connect(_on_enemy_perished)
	call_deferred("add_child", pufferfish)

func back_to_menu():
	var main_menu_template = load("res://main_menu.tscn")
	var main_menu = main_menu_template.instantiate()
	get_parent().add_child(main_menu)
	queue_free()
