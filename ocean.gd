extends Node2D

var player_template = preload("res://player.tscn")
var crab_template = preload("res://crab.tscn")

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = player_template.instantiate()
	add_child(player)
	
	spawn_crab()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hit_player(_enemy_type: E.EnemyType):
	back_to_menu()

func _on_enemy_perished(enemy_type: E.EnemyType):
	match enemy_type:
		E.EnemyType.CRAB:
			spawn_crab()

func spawn_crab():
	var crab = crab_template.instantiate()
	crab.setup(player, Vector2(1000, 500))
	crab.hit_player.connect(_on_hit_player)
	crab.perished.connect(_on_enemy_perished)
	call_deferred("add_child", crab)


func back_to_menu():
	var main_menu_template = load("res://main_menu.tscn")
	var main_menu = main_menu_template.instantiate()
	get_parent().add_child(main_menu)
	queue_free()
