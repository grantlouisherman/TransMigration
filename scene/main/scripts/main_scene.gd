extends Node2D
signal move_walls
var InputName = preload("res://library/InputName.gd").new()
var DungeonCoords = preload("res://library/DungeonSize.gd").new()
var Dwarves = preload("res://sprites/dwarf.tscn")
var ConvertCoord = preload("res://library/ConvertCoord.gd").new()
var rng = RandomNumberGenerator.new()
var p_offset_x = 100
var p_offset_y = 50
var mult = 10
func _ready() -> void:
	var player = get_tree().get_nodes_in_group("SpawnPoint")[0]
	player.connect('win_cond', _won)
	player.connect('red_touched', _red_touched)
	#player.connect('blue_touched', _blue_touched)
	
func _create_enemies():
	for i in range(0, 5):
		var new_x = rng.randi_range(0, DungeonCoords.MAX_X)
		var new_y = rng.randi_range(0, DungeonCoords.MAX_Y)
		_create_sprite(Dwarves, "Enemies", new_x, new_y)
func _won() -> void:
	#print("WINNER")
	move_walls.emit()

func _red_touched():
	randomize()
	rng = RandomNumberGenerator.new()
	var node = (get_tree().get_nodes_in_group("SpawnPoint")[1])
	var new_x = rng.randi_range((DungeonCoords.MAX_X * mult) * -1, DungeonCoords.MAX_X * mult)
	var new_y = rng.randi_range((DungeonCoords.MAX_Y * mult) * -1, DungeonCoords.MAX_Y * mult)
	print("NEW X :", new_x, " NEW_Y: ", new_y)
	var x = node.position.x
	node.position.x = new_x + p_offset_x
	node.position.y = new_y + p_offset_y
	_create_enemies()

func _create_sprite(
	prefab: PackedScene, 
	group: String, 
	x: int, 
	y: int,
	x_offset: int = 0, 
	y_offset: int = 0):
	var new_sprite = prefab.instantiate()
	new_sprite.position = ConvertCoord.index_to_vector(x, y, x_offset, y_offset)
	new_sprite.add_to_group(group)
	add_child(new_sprite)
