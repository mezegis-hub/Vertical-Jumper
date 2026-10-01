extends Label

@export var player_node: CharacterBody2D

# Current high score value
var high_score: int = 0


func _process(_delta: float) -> void:
	# 2. Check if the player node exists to prevent crash errors
	if player_node:
		# 3. Read the variable directly from player.gd and update the text every frame
		var high_score = int(player_node.highest_y * -1) - 100
		text = "High Score: " + str(high_score)
