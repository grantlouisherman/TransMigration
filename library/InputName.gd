extends Node

const MOVE_LEFT: String = "move_left"
const MOVE_RIGHT: String = "move_right"
const MOVE_UP: String = "move_up"
const MOVE_DOWN: String = "move_down"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(MOVE_LEFT):
		print("move left")
