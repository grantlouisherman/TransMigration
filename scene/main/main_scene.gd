extends Node2D
signal move_walls
var InputName = preload("res://library/InputName.gd").new()

func _ready() -> void:
	var player = get_tree().get_nodes_in_group("SpawnPoint")[0]
	player.connect('win_cond', _won)
	player.connect('red_touched', _red_touched)
	player.connect('blue_touched', _blue_touched)
	
#func _process(delta: float) -> void:
	#var button_node = get_node("Player")
	#print(button_node)
func _won() -> void:
	print("WINNER")
	move_walls.emit()

func _red_touched():
	print("READ")

func _blue_touched():
	print("BLUE")
