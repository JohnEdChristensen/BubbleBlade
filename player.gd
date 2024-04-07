class_name Player

extends CharacterBody2D

@export var TOP_SPEED  = 600.0
@export var MIN_SPEED  = 300.0

var SECONDS_TO_TOP_SPEED = 100
var ACCELERATION = (TOP_SPEED-MIN_SPEED)/SECONDS_TO_TOP_SPEED

@export var ROTATION_SPEED = 4*PI
@export var BOOST_FACTOR = 3

#state
var is_boosted = false
var damage: int

@onready var attack_box_area = $AttackBoxArea

const NORMAL_DAMAGE: int = 1
const SPRINT_DAMAGE: int = 2

func _ready() -> void:
	damage = NORMAL_DAMAGE

func _physics_process(delta: float) -> void:
	#input
	var input_direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
	velocity = input_direction * clamp(velocity.length()+(ACCELERATION),MIN_SPEED,TOP_SPEED)

	var target_angle = input_direction.angle()
	rotation = lerp_angle(rotation,target_angle,ROTATION_SPEED * delta)
	
	if (Input.is_action_pressed("Sprint") 
		&& $"Boost Active".is_stopped() 
		&& $"Boost Disabled".is_stopped()):
		activate_boost()
	

	#process
	if (is_boosted):
		velocity *= BOOST_FACTOR
	$AnimatedSprite2D.flip_v = abs(rotation) > PI/2
	
	# using move_and_collide
	var collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())

func activate_boost() -> void:
	$"Boost Active".start()
	$AnimatedSprite2D.play("fast")
	is_boosted = true
	damage = SPRINT_DAMAGE
	
func deactivate_boost() -> void:
	is_boosted = false;
	$AnimatedSprite2D.play("default")
	damage = NORMAL_DAMAGE
	
func _on_boost_active_timeout() -> void:
	deactivate_boost()
	$"Boost Active".stop()
	$"Boost Disabled".start()


func _on_boost_disabled_timeout() -> void:
	$"Boost Disabled".stop()
