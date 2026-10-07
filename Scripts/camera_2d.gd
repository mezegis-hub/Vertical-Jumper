extends Camera2D

@export var scroll_speed := 50.0
@export var max_scroll_speed := 250.0
@export var speed_increase_height := 5000.0

@onready var player := get_tree().get_first_node_in_group("player")

var is_game_over := false


func _process(delta: float) -> void:
	if is_game_over:
		return

	var difficulty = clamp(
		abs(player.position.y) / speed_increase_height,
		0.0,
		1.0
	)

	var current_speed = lerp(
		scroll_speed,
		max_scroll_speed,
		difficulty
	)

	position.y -= current_speed * delta

#extends Camera2D
#
#func _process(delta: float) -> void:
	#position.y -= 100.0 * delta


func _on_player_died() -> void:
	is_game_over = true
