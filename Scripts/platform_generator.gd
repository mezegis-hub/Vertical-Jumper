extends Node2D


@export var platform_scene: PackedScene
@export var player: CharacterBody2D





const INITIAL_PLATFORM_COUNT = 1
#const GENERATION_DISTANCE = 1500.0
#onst GENERATION_AHEAD = 500.0
#const DELETE_BEHIND = 200.0
const MAX_PLATFORMS_ABOVE = 12
const MIN_PLATFORMS_ABOVE = 5

const MAX_PLATFORMS_BELOW = 10
const MIN_PLATFORMS_BELOW = 2

const MIN_VERTICAL_DISTANCE = 80.0
const MAX_VERTICAL_DISTANCE = 150.0

const MIN_HORIZONTAL_DISTANCE = 120.0
const MAX_HORIZONTAL_DISTANCE = 250.0

const DIFFICULTY_DISTANCE = 3000.0
const MAX_DIFFICULTY = 1.0

const SCREEN_LEFT = -300.0
const SCREEN_RIGHT = 300.0


var current_position = Vector2(0, 0)

func _ready() -> void:
	for i in INITIAL_PLATFORM_COUNT:
		generate_platform()
		
func _process(_delta: float) -> void:
	var difficulty = get_difficulty()
	
	var target_above = roundi(lerp(
		MAX_PLATFORMS_ABOVE,
		MIN_PLATFORMS_ABOVE,
		difficulty
	))
	
	var target_below = roundi(lerp(
		MAX_PLATFORMS_BELOW,
		MIN_PLATFORMS_BELOW,
		difficulty
	))
	
	#generate_until_height(player.position.y)
	generate_platforms_above(target_above)
	delete_platforms_below(target_below)
	#if player.position.y < current_position.y + GENERATION_DISTANCE:
		#generate_platform()
	#delete_old_platforms(player.position.y)
	
func generate_platforms_above(target_count: int) -> void:
	var above_count = 0

	for platform in get_children():
		if platform.position.y < player.position.y:
			above_count += 1

	while above_count < target_count:
		generate_platform()
		above_count += 1
		
func generate_platform() -> void:
	var platform = platform_scene.instantiate()
	add_child(platform)

	platform.position = current_position

	var difficulty = get_difficulty()

	var current_max_vertical = lerp(
		MIN_VERTICAL_DISTANCE,
		MAX_VERTICAL_DISTANCE,
		difficulty
	)

	var random_y = randf_range(
		MIN_VERTICAL_DISTANCE,
		current_max_vertical
	)

	var current_max_horizontal = lerp(
		MIN_HORIZONTAL_DISTANCE,
		MAX_HORIZONTAL_DISTANCE,
		difficulty
	)
		
	var left_wall = SCREEN_LEFT
	var left_min = current_position.x - current_max_horizontal
	var left_max = current_position.x - MIN_HORIZONTAL_DISTANCE

	var right_min = current_position.x + MIN_HORIZONTAL_DISTANCE
	var right_wall = SCREEN_RIGHT
	var right_max = current_position.x + current_max_horizontal


	var can_go_left = left_max >= left_wall
	var can_go_right = right_min <= right_wall


	if can_go_left and can_go_right:
		if randf() < 0.5:
			current_position.x = randf_range(
				left_min,
				left_max
			)
		else:
			current_position.x = randf_range(
				right_min,
				right_max
			)

	elif can_go_left:
		current_position.x = randf_range(
			left_min,
			left_max
		)

	elif can_go_right:
		current_position.x = randf_range(
			right_min,
			right_max
		)		

	current_position.y -= random_y	

func delete_platforms_below(target_count: int) -> void:
	var below_platforms = []

	for platform in get_children():
		if platform.position.y > player.position.y:
			below_platforms.append(platform)

	below_platforms.sort_custom(func(a, b):
		return a.position.y < b.position.y
	)

	while below_platforms.size() > target_count:
		var platform_to_delete = below_platforms.pop_back()
		platform_to_delete.queue_free()
		
#func generate_until_height(player_y: float) -> void:
	#while current_position.y > player_y - GENERATION_AHEAD:
		#generate_platform()
		#
#func delete_old_platforms(player_y: float) -> void:
	#for platform in get_children():
		#if platform.position.y > player_y + DELETE_BEHIND:
			#platform.queue_free()
			
func get_difficulty() -> float:
	var difficulty = abs(player.position.y) / DIFFICULTY_DISTANCE
	return clamp(difficulty, 0.0, MAX_DIFFICULTY)
