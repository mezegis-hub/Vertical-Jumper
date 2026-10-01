extends Node2D


@export var platform_scene: PackedScene
@export var player: CharacterBody2D



const INITIAL_PLATFORM_COUNT = 1
const GENERATION_DISTANCE = 1500.0

const MIN_VERTICAL_DISTANCE = 80.0
const MAX_VERTICAL_DISTANCE = 120.0

const MIN_HORIZONTAL_DISTANCE = 100.0
const MAX_HORIZONTAL_DISTANCE = 220.0

const SCREEN_LEFT = -300.0
const SCREEN_RIGHT = 300.0


var current_position = Vector2(0, 0)

func _ready() -> void:
	for i in INITIAL_PLATFORM_COUNT:
		generate_platform()
		
func _process(_delta: float) -> void:
	if player.position.y < current_position.y + GENERATION_DISTANCE:
		generate_platform()
		
func generate_platform() -> void:
	var platform = platform_scene.instantiate()
	add_child(platform)

	platform.position = current_position

	var random_y = randf_range(
		MIN_VERTICAL_DISTANCE,
		MAX_VERTICAL_DISTANCE
	)


	var left_wall = SCREEN_LEFT
	var left_min = current_position.x - MAX_HORIZONTAL_DISTANCE
	var left_max = current_position.x - MIN_HORIZONTAL_DISTANCE

	var right_min = current_position.x + MIN_HORIZONTAL_DISTANCE
	var right_wall = SCREEN_RIGHT
	var right_max = current_position.x + MAX_HORIZONTAL_DISTANCE


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
