
extends Node2D

@onready var game_over = $Canvas/GameOverPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_died() -> void:
	game_over.visible = true # Replace with function body.


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene() # Replace with function body.
