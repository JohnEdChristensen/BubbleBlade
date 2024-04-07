extends CharacterBody2D

var decoration_type: E.Decoration

func setup(new_decoration_type: E.Decoration, new_position: Vector2, new_movement: Vector2, new_scale: Vector2):
	match new_decoration_type:
		E.Decoration.BUBBLE:
			$AnimatedSprite2D.animation = "bubble"
		E.Decoration.CRAB:
			$AnimatedSprite2D.animation = "crab"
		E.Decoration.JELLYFISH:
			$AnimatedSprite2D.animation = "jellyfish"
		E.Decoration.PUFFERFISH:
			$AnimatedSprite2D.animation = "pufferfish"
		E.Decoration.SEAWEED:
			$AnimatedSprite2D.animation = "seaweed"
		E.Decoration.TURTLE:
			$AnimatedSprite2D.animation = "turtle"
	
	position = new_position
	velocity = new_movement
	scale = new_scale

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	move_and_slide()
