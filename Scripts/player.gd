extends CharacterBody2D

signal died

const SPEED = 300.0
const GRAVITY = 1200.0
const JUMP_VELOCITY = -600.0

const FALL_DISTANCE= 1000.0

const JUMP_CUT_MULTIPLIER = 0.3

var highest_y: float
var game_over := false

func _ready() -> void:
		highest_y = global_position.y


func _physics_process(delta: float) -> void:
	
	if game_over:
		return
	# Add the gravity.
	if not is_on_floor(): 	
		velocity.y += GRAVITY * delta

	# Handle jump.
	#if is_on_floor():
			#velocity.y = JUMP_VELOCITY
			
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Short Press Cutoff: If the player releases the button early while moving upward
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULTIPLIER

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

	move_and_slide()
	
	#high point reach
	if global_position.y < highest_y:
		highest_y = global_position.y
		
	#fall detection
	if global_position.y > highest_y + FALL_DISTANCE:
		game_over = true
		velocity = Vector2.ZERO
		died.emit()
	
	if position.x < -400:
		position.x = 400
	if position.x > 400:
		position.x = -400
