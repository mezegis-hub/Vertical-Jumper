extends CharacterBody2D

signal died


const SPEED = 300.0
const GRAVITY = 1200.0
const JUMP_VELOCITY = -600.0

const FALL_DISTANCE= 1000.0

const JUMP_CUT_MULTIPLIER = 0.3

var highest_y: float
var game_over := false

var current_platform = null

@onready var camera = get_tree().get_first_node_in_group("camera")

func _ready() -> void:
		highest_y = global_position.y
		print("CAMERA FOUND: ", camera)


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

		if current_platform != null:
			#print("CURRENT PLATFORM: ", current_platform.name)
			var platforms = get_tree().get_nodes_in_group("platform")

			var next_platform = null
			var closest_distance = INF

			for platform in platforms:
				if platform.global_position.y < current_platform.global_position.y:
					var distance = current_platform.global_position.y - platform.global_position.y

					if distance < closest_distance:
						closest_distance = distance
						next_platform = platform

			if next_platform != null and next_platform.is_trick and not next_platform.trick_triggered:
				next_platform.trick_triggered = true
				next_platform.trick_start_x = next_platform.position.x
				next_platform.trick_direction = [-1.0, 1.0].pick_random()
				print("NEXT TRICK PLATFORM TRIGGERED")
				
			if next_platform != null and next_platform.is_shrinking and not next_platform.shrink_triggered:
				next_platform.shrink_triggered = true
				print("NEXT SHRINKING PLATFORM TRIGGERED")
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
	#if global_position.y > highest_y + FALL_DISTANCE:
		#game_over = true
		#velocity = Vector2.ZERO
		#died.emit()
	if camera != null and global_position.y > camera.global_position.y + FALL_DISTANCE:
		game_over = true
		velocity = Vector2.ZERO
		died.emit()
	
	
	if position.x < -400:
		position.x = 400
	if position.x > 400:
		position.x = -400
		
		
	if is_on_floor():
		current_platform = null

		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)

			if collision.get_normal().y < -0.5:
				current_platform = collision.get_collider()
				break
	else:
		current_platform = null
