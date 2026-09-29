extends Node2D
@export var platform_scene: PackedScene


const PLATFORM_COUNT = 10
const MIN_VERTICAL_DISTANCE = 70.0
const MAX_VERTICAL_DISTANCE = 110.0
const MAX_HORIZONTAL_DISTANCE = 180.0


func _ready() -> void:
	var current_position = Vector2(400, 500)

	for i in PLATFORM_COUNT:
		var platform = platform_scene.instantiate()
		add_child(platform)

		platform.position = current_position

		var random_x = randf_range(
			-MAX_HORIZONTAL_DISTANCE,
			MAX_HORIZONTAL_DISTANCE
		)

		var random_y = randf_range(
			MIN_VERTICAL_DISTANCE,
			MAX_VERTICAL_DISTANCE
		)

		current_position += Vector2(
			random_x,
			-random_y
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
