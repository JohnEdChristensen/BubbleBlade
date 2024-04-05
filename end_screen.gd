extends Control

var death_text: String
var distance_text: String
var enemy_texture: Texture2D

func setup(win: bool, enemy_type: E.EnemyType, distance: int):
	$VBoxContainer/DeathLabel.text = ""
	$VBoxContainer/DistanceLabel.text = ""
	if win:
		death_text = "You died to nothing because you're one slippery fish!"
		distance_text = "You made it home!"
		$VBoxContainer/TextureRect.hide()
	else:
		death_text = "You died to " + enemy_type_to_string(enemy_type) + "."
		distance_text = "You were " + str(distance) + " meters from home."
		enemy_texture = get_enemy_texture(enemy_type)

func _enter_tree():
	await get_tree().create_timer(0.5).timeout
	for character in death_text:
		$VBoxContainer/DeathLabel.text = $VBoxContainer/DeathLabel.text + character
		await get_tree().create_timer(0.050).timeout
	await get_tree().create_timer(0.5).timeout
	for character in distance_text:
		$VBoxContainer/DistanceLabel.text = $VBoxContainer/DistanceLabel.text + character
		await get_tree().create_timer(0.050).timeout
	await get_tree().create_timer(0.5).timeout
	$VBoxContainer/TextureRect.texture = enemy_texture
	$VBoxContainer/Button.show()

func back_to_menu():
	var main_menu_template = load("res://main_menu.tscn")
	var main_menu = main_menu_template.instantiate()
	get_parent().add_child(main_menu)
	queue_free()

func enemy_type_to_string(enemy_type: E.EnemyType) -> String:
	var readable_string: String = ""
	match enemy_type:
		E.EnemyType.CRAB:
			readable_string = "a jumpy crab"
		E.EnemyType.PUFFERFISH:
			readable_string = "a poofy pufferfish"
		E.EnemyType.JELLYFISH:
			readable_string = "a floaty jellyfish"
		_:
			readable_string = "an unknown and unlabeled fishy"
	return readable_string

func get_enemy_texture(enemy_type: E.EnemyType) -> Texture2D:
	var texture: Texture2D
	match enemy_type:
		E.EnemyType.CRAB:
			texture = load("res://assets/Crab.webp")
		E.EnemyType.PUFFERFISH:
			texture = load("res://assets/PufferfishExpanded.webp")
		E.EnemyType.JELLYFISH:
			texture = load("res://assets/Jellyfish.webp")
		_:
			texture = null
	return texture
