extends Node2D

var player_template = preload("res://player.tscn")
var crab_template = preload("res://crab.tscn")
var pufferfish_template = preload("res://pufferfish.tscn")
var jellyfish_template = preload("res://jellyfish.tscn")
var bubble_template = preload("res://bubble.tscn")
var end_screen_template = preload("res://end_screen.tscn")
var buoy_template = preload("res://buoy.tscn")
var decoration_template = preload("res://decoration.tscn")
var castle_template = preload("res://castle.tscn")

const WIN_DISTANCE = 50000
const ZONE_LENGTH = 5000

var player
var max_player_zone: int
var difficulty_points: int
var seed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = player_template.instantiate()
	add_child(player)
	max_player_zone = 0
	difficulty_points = 0
	seed = int(Time.get_unix_time_from_system())
	on_entered_new_zone()
	
	$Background/Ocean.size.x = WIN_DISTANCE
	$FarParallaxColor/Ocean.size.x = WIN_DISTANCE
	$MedParallaxColor/Ocean.size.x = WIN_DISTANCE
	$CloseParallaxColor/Ocean.size.x = WIN_DISTANCE
	$StaticBody2D/Floor.size.x = WIN_DISTANCE
	$StaticBody2D/CollisionShape2D.shape.size.x = WIN_DISTANCE
	$StaticBody2D/CollisionShape2D.position.x = WIN_DISTANCE / 2
	var castle = castle_template.instantiate()
	castle.position.x = WIN_DISTANCE
	castle.position.y = 600
	add_child(castle)
	
	spawn_bubble(Vector2(1000, 500))
	
	for i in ((WIN_DISTANCE / ZONE_LENGTH) + 1):
		spawn_buoy(i * ZONE_LENGTH)
	
	for i in (WIN_DISTANCE / 500):
		spawn_random_decoration()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.position.x > WIN_DISTANCE:
		end_game(true, E.EnemyType.NULL, 0)
	if floor(player.position.x / ZONE_LENGTH) > max_player_zone:
		max_player_zone = player.position.x / ZONE_LENGTH
		on_entered_new_zone()

func _on_hit_player(enemy_type: E.EnemyType):
	pass
	#end_game(false, enemy_type, (WIN_DISTANCE - player.position.x)/ 10)

func _on_enemy_perished(enemy_type: E.EnemyType, perish_position: Vector2):
	match enemy_type:
		E.EnemyType.BUBBLE:
			#gain bubble amount
			pass
		_:
			spawn_bubble(perish_position)

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

func spawn_bubble(location: Vector2):
	var bubble = bubble_template.instantiate()
	bubble.setup(player, location)
	bubble.hit_player.connect(_on_hit_player)
	bubble.perished.connect(_on_enemy_perished)
	call_deferred("add_child", bubble) 

func try_spawn_enemy(enemy_type: E.EnemyType, zone: int) -> bool:
	var can_spawn: bool
	var cost: int
	match enemy_type:
		E.EnemyType.CRAB:
			cost = 3
		E.EnemyType.PUFFERFISH:
			cost = 2
		E.EnemyType.JELLYFISH:
			cost = 1
		E.EnemyType.BUBBLE:
			cost = -1
	if cost <= difficulty_points:
		can_spawn = true
		var rng = RandomNumberGenerator.new()
		rng.seed = Time.get_ticks_usec()
		var x_position = rng.randf_range((zone + 1) * ZONE_LENGTH, (zone + 2) * ZONE_LENGTH)
		var y_position = rng.randf_range(400, 600)
		var new_position = Vector2(x_position, y_position)
		match enemy_type:
			E.EnemyType.CRAB:
				spawn_crab(new_position)
			E.EnemyType.PUFFERFISH:
				spawn_pufferfish(new_position)
			E.EnemyType.JELLYFISH:
				spawn_jellyfish(new_position)
			E.EnemyType.BUBBLE:
				spawn_bubble(new_position)
		difficulty_points = difficulty_points - cost
	else:
		can_spawn = false
	return can_spawn

func spawn_buoy(x_location: int):
	var buoy = buoy_template.instantiate()
	buoy.setup(x_location, x_location / ZONE_LENGTH * 100)
	$"Decorative Props".add_child(buoy)

func on_entered_new_zone():
	difficulty_points = difficulty_points + (5 * ((max_player_zone + 2) / 2))
	var spawn_success: bool = true
	var rng = RandomNumberGenerator.new()
	rng.seed = Time.get_ticks_msec()
	print("ZONE: ", max_player_zone)
	print("DIFFICULTY POINTS: ", difficulty_points)
	while(spawn_success):
		spawn_success = try_spawn_enemy(rng.randi_range(1, 4), max_player_zone)

func end_game(win: bool, enemy_death: E.EnemyType, distance_left: int):
	var end_screen = end_screen_template.instantiate()
	end_screen.setup(win, enemy_death, distance_left)
	get_parent().add_child(end_screen)
	queue_free()

func spawn_random_decoration():
	var decoration = decoration_template.instantiate()
	var rng = RandomNumberGenerator.new()
	seed = seed + 1
	rng.seed = seed
	var decoration_type = rng.randi_range(0, 6)
	var direction = rng.randi_range(0, 1)
	var x_position = rng.randf_range(0, WIN_DISTANCE)
	var y_position
	var movement
	match decoration_type:
		E.Decoration.SEAWEED:
			y_position = 900
			movement = Vector2(0, 0)
		E.Decoration.CRAB:
			y_position = 900
			match direction:
				0:
					movement = Vector2(-1, 0)
				1:
					movement = Vector2(1, 0)
		_:
			y_position = rng.randf_range(200, 800)
			match direction:
				0:
					movement = Vector2(-1, 0)
				1:
					movement = Vector2(1, 0)
	
	var distance = rng.randi_range(0, 2)
	
	var new_scale
	match distance:
		E.Parallax.CLOSE:
			new_scale = Vector2(0.3, 0.3)
			movement = movement * 3
		E.Parallax.MED:
			new_scale = Vector2(0.2, 0.2)
			movement = movement * 2
		E.Parallax.FAR:
			new_scale = Vector2(0.1, 0.1)
			movement = movement * 1
	decoration.setup(decoration_type, Vector2(x_position, y_position), movement, new_scale)
	
	match distance:
		E.Parallax.CLOSE:
			$CloseParallax.add_child(decoration)
		E.Parallax.MED:
			$MedParallax.add_child(decoration)
		E.Parallax.FAR:
			$FarParallax.add_child(decoration)
