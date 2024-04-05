class_name Player

extends CharacterBody2D

@export var TOP_SPEED  = 600.0
@export var MIN_SPEED  = 300.0

var SECONDS_TO_TOP_SPEED = 100
var ACCELERATION = (TOP_SPEED-MIN_SPEED)/SECONDS_TO_TOP_SPEED

@export var ROTATION_SPEED = 4*PI
var SPRINT_FACTOR = 3

@onready var attack_box_area = $AttackBoxArea

func update_rotation_lerp(start,end,amount) -> float:
		return lerp_angle(start,end,amount)

	

func _physics_process(delta: float) -> void:
	#input
	var input_direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
	velocity = input_direction * clamp(velocity.length()+(ACCELERATION),MIN_SPEED,TOP_SPEED)

	var target_angle = input_direction.angle()
	rotation = update_rotation_lerp(rotation,target_angle,ROTATION_SPEED * delta)
	
	if Input.is_action_pressed("Sprint"):
		velocity *= SPRINT_FACTOR
	#process

	#$AnimatedSprite2D.flip_v = velocity.x < 0
	$AnimatedSprite2D.flip_v = abs(rotation) > PI/2
	# using move_and_collide
	var collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
