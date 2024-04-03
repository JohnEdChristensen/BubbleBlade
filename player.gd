class_name Player

extends CharacterBody2D

const SPEED = 300.0
const SPRINT_FACTOR = 3

@onready var attack_box_area = $AttackBoxArea


func _physics_process(delta: float) -> void:
	var direction = Vector2(0,0)
	if Input.is_action_pressed("Move Right"):
		direction += Vector2(1,0)
	if Input.is_action_pressed("Move Left"):
		direction += Vector2(-1,0)
	if Input.is_action_pressed("Move Up"):
		direction += Vector2(0,-1)
	if Input.is_action_pressed("Move Down"):
		direction += Vector2(0,1)
	
	
	velocity = direction * SPEED 
	if Input.is_action_pressed("Sprint"):
		velocity *= SPRINT_FACTOR
	move_and_slide()
