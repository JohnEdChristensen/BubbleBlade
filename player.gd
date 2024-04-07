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


#region attacks/actions
enum action_state {DEFAULT, JABBING, SPINNING, BOOSTING, COOLDOWN}
var current_action_state = action_state.DEFAULT
# Jab Attack
# DEFAULT -> JABBING
#   boost velocity in current direction
#   input is disabled till end of jab
#   hitting enemy 
#     deals damage, stuns enemy, knockback enemy in direction of jab
#     resets attack_state to default
#   Timer ends jab if no enemy is hit
@export var JAB_ACTION_SECONDS = 1
@export var JAB_COOLDOWN_SECONDS = .5
		
@export var SPIN_ACTION_SECONDS = 1
@export var SPIN_COOLDOWN_SECONDS = .5 
		
@export var BOOST_ACTION_SECONDS = 2
@export var BOOST_COOLDOWN_SECONDS = .5

func try_start_action(action: action_state)->void:
	if current_action_state != action_state.DEFAULT:
		return #only one action at a time allowed
	match action:
		action_state.JABBING:
			current_action_state = action_state.JABBING
			$"Action Timer".start(JAB_ACTION_SECONDS)
			if velocity.length() == 0:
				velocity = Vector2(1,0)
			velocity = velocity.normalized() *TOP_SPEED*BOOST_FACTOR
			$AnimatedSprite2D.play("fast")
      damage = SPRINT_DAMAGE
		action_state.SPINNING:
			current_action_state = action_state.SPINNING
			$"Action Timer".start(SPIN_ACTION_SECONDS)
			$AnimatedSprite2D.play("spinning")
			velocity = Vector2(0,0)
      damage = NORMAL_DAMAGE
		action_state.BOOSTING:
			current_action_state = action_state.BOOSTING
			$"Action Timer".start(BOOST_ACTION_SECONDS)
			$AnimatedSprite2D.play("fast")
      damage = SPRINT_DAMAGE
		action_state.DEFAULT:
			current_action_state = action_state.DEFAULT
			$AnimatedSprite2D.play("default")
      damage = NORMAL_DAMAGE
		_:
			print("tried to start unexpected action!",action)
			
func action_process(requested_velocity,requested_rotation) -> void:
	#update player based on current action
	match current_action_state:
		action_state.JABBING:
			pass # no control while jabbing
		action_state.SPINNING:
			pass # no control while spinning
		action_state.BOOSTING:
			velocity = requested_velocity * BOOST_FACTOR
			rotation = requested_rotation
		action_state.COOLDOWN:
			velocity = requested_velocity
			rotation = requested_rotation
		action_state.DEFAULT:
			velocity = requested_velocity
			rotation = requested_rotation
	
	#updates that apply to multiple actions
	if current_action_state in [action_state.DEFAULT,action_state.BOOSTING,action_state.COOLDOWN]:
		$AnimatedSprite2D.flip_v = abs(rotation) > PI/2
	
func _on_action_timer_timeout() -> void:
	match current_action_state:
		action_state.JABBING:
			$"Cooldown Timer".start(JAB_COOLDOWN_SECONDS)
		action_state.SPINNING:
			$"Cooldown Timer".start(SPIN_COOLDOWN_SECONDS)
		action_state.BOOSTING:
			$"Cooldown Timer".start(BOOST_COOLDOWN_SECONDS)
		_:
			print("Unexpected action timeout!")
	current_action_state = action_state.COOLDOWN
	$AnimatedSprite2D.play("default")
	$"Action Timer".stop()
			
func _on_cooldown_timer_timeout() -> void:
	current_action_state = action_state.DEFAULT
	$"Cooldown Timer".stop()

#region end



@onready var attack_box_area = $AttackBoxArea

const NORMAL_DAMAGE: int = 1
const SPRINT_DAMAGE: int = 2

func _ready() -> void:
	damage = NORMAL_DAMAGE

func _physics_process(delta: float) -> void:
	#handle input
	var input_direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
	var input_velocity = input_direction * clamp(velocity.length()+(ACCELERATION),MIN_SPEED,TOP_SPEED)

	var target_angle = input_direction.angle()
	var input_rotation = lerp_angle(rotation,target_angle,ROTATION_SPEED * delta)
	
	var input_action = action_state.DEFAULT
	if (Input.is_action_pressed("Attack Action 1")):
		input_action = action_state.JABBING
	elif (Input.is_action_pressed("Attack Action 2")):
		input_action = action_state.SPINNING
	elif (Input.is_action_pressed("Sprint")):
		input_action = action_state.BOOSTING
	
	#process requested actions
	try_start_action(input_action)
	action_process(input_velocity,input_rotation)

	
	# using move_and_collide
	var collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
