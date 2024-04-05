extends Node2D

var player_template = preload("res://player.tscn")
var crab_template = preload("res://crab.tscn")
var pufferfish_template = preload("res://pufferfish.tscn")
var jellyfish_template = preload("res://jellyfish.tscn")
var end_screen_template = preload("res://end_screen.tscn")

var player
var win_distance = 10000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = player_template.instantiate()
	add_child(player)
	
	spawn_crab(Vector2(1000, 500))
	spawn_pufferfish(Vector2(2000, 500))
	spawn_jellyfish(Vector2(3000, 500))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.position.x > win_distance:
		end_game(true, E.EnemyType.NULL, 0)

func _on_hit_player(enemy_type: E.EnemyType):
	end_game(false, enemy_type, win_distance - player.position.x)

func _on_enemy_perished(enemy_type: E.EnemyType):
	match enemy_type:
		E.EnemyType.CRAB:
			spawn_crab(Vector2(1000, 500))
		E.EnemyType.PUFFERFISH:
			spawn_pufferfish(Vector2(2000, 500))
		E.EnemyType.JELLYFISH:
			spawn_jellyfish(Vector2(3000, 500))

func spawn_crab(location: Vector2):
	var crab = crab_template.instantiate()
	crab.setup(player, location)
	crab.hit_player.connect(_on_hit_player)
	crab.perished.connect(_on_enemy_perished)
	call_deferred("add_child", crab)

func spawn_pufferfish(location: Vector2):
	var pufferfish = pufferfish_template.instantiate()
	pufferfish.setup(player, location)
	pufferfish.hit_player.connect(_on_hit_player)
	pufferfish.perished.connect(_on_enemy_perished)
	call_deferred("add_child", pufferfish)

func spawn_jellyfish(location: Vector2):
	var jellyfish = jellyfish_template.instantiate()
	jellyfish.setup(player, location)
	jellyfish.hit_player.connect(_on_hit_player)
	jellyfish.perished.connect(_on_enemy_perished)
	call_deferred("add_child", jellyfish)

func end_game(win: bool, enemy_death: E.EnemyType, distance_left: int):
	var end_screen = end_screen_template.instantiate()
	end_screen.setup(win, enemy_death, distance_left)
	get_parent().add_child(end_screen)
	queue_free()
