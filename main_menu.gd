extends Control

var ocean_template = preload("res://ocean.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var game = ocean_template.instantiate()
	get_parent().add_child(game)
	queue_free()
