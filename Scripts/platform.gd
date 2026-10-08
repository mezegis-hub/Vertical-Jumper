extends AnimatableBody2D

#region variables
#for moving platforms
@export var is_moving := false
@export var move_speed := 100.0
@export var move_distance := 150.0
@export var max_speed_multiplier := 2.0

#for trick platforms
@export var is_trick := false
@export var trick_speed := 500.0
@export var trick_distance := 75.0

# for falling platforms
@export var is_falling := false
@export var fall_delay := 2.0
@export var fall_speed := 300.0
@export var fall_distance := 500.0
@export var recovery_speed := 75.0

# for shrinking platforms
@export var is_shrinking := false
@export var shrink_speed := 100.0
@export var minimum_width := 50.0


#moving platform vars
var direction := 1.0
var start_x := 0.0
var initialized := false
var pause_timer := 0.0
var pause_times = [0.25, 0.5, 1.0, 1.5, 2.0]

#trick platform vars
var trick_triggered := false
var trick_start_x := 0.0
var trick_direction := 1.0

#falling platform vars
var fall_triggered := false
var fall_timer := 0.0
var fall_start_y := 0.0

#shrinking platform vars
var shrink_triggered := false
var original_width := 0.0
#endregion 
func _ready() -> void:
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	
func _physics_process(delta: float) -> void:
	if not is_moving and not is_trick and not is_falling and not is_shrinking:
		return
	
	if not initialized:
		start_x = position.x
		initialized = true
		return
		
	if original_width == 0.0:
		original_width = $ColorRect.size.x

	if pause_timer > 0.0:
		pause_timer -= delta
		return

	var player = get_tree().get_first_node_in_group("player")
	
	#region moving platform
	if is_moving:
		var current_speed = move_speed

		if player != null:
			var difficulty = clamp(abs(player.position.y) / 3000.0, 0.0, 1.0)
			current_speed = lerp(
				move_speed,
				move_speed * max_speed_multiplier,
				difficulty
			)

		position.x += direction * current_speed * delta

		if position.x >= start_x + move_distance:
			position.x = start_x + move_distance
			direction = -1.0
	#		position.x += direction * move_speed * delta
			pause_timer = pause_times.pick_random()

		elif position.x <= start_x - move_distance:
			position.x = start_x - move_distance
			direction = 1.0
	#		position.x += direction * move_speed * delta
			pause_timer = pause_times.pick_random()


	#if is_trick and not trick_triggered:
		#if player != null and player.velocity.y < 0.0:
			#trick_triggered = true
			#trick_start_x = position.x
			#trick_direction = [-1.0, 1.0].pick_random()
			#print("TRICK PLATFORM TRIGGERED")
	#endregion
	
	#region trick platform
	if is_trick and trick_triggered:
		position.x += trick_direction * trick_speed * delta

		if abs(position.x - trick_start_x) >= trick_distance:
			position.x = trick_start_x + trick_direction * trick_distance
	#endregion
	
	#region falling platform
	if is_falling and not fall_triggered:
		if player != null and player.current_platform == self:
			fall_triggered = true
			fall_timer = fall_delay
			fall_start_y = position.y
			print("FALLING PLATFORM TRIGGERED")

	if is_falling and fall_triggered:
		if fall_timer > 0.0:
			fall_timer -= delta
		else:
			if player != null and player.current_platform == self:
				# Player is still on the platform — keep falling
				position.y += fall_speed * delta
			else:
				# Player has left — slowly return to the original position
				position.y = move_toward(
					position.y,
					fall_start_y,
					recovery_speed * delta
				)
				# Once fully recovered, reset the platform
				if is_equal_approx(position.y, fall_start_y):
					position.y = fall_start_y
					fall_triggered = false
					fall_timer = 0.0
					print("FALLING PLATFORM RESET")
	#endregion
	
	#region shrinking platform
	if is_shrinking and shrink_triggered:
		var old_width = $ColorRect.size.x
		var new_width = old_width - shrink_speed * delta
		new_width = max(new_width, minimum_width)
		
		var width_change = old_width - new_width
		
		$ColorRect.size.x = new_width
		$ColorRect.position.x += width_change / 2.0
		
		$CollisionShape2D.shape.size.x = new_width
		
		if new_width <= minimum_width:
			shrink_triggered = false
	#endregion
