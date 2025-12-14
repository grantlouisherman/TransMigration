extends Node
var ConvertCoord = preload("res://library/ConvertCoord.gd").new()
var PointA = preload("res://scene/points/point_a.tscn")



func _create_spawn_point(x: int, y: int, prefab: PackedScene, set_global = false)-> Node2D:
	var spawn_point_x = 0
	var spawn_pont_y = 0
	if set_global:
		if prefab == PointA:
			Global.point_a_position = Vector2(x, y)
			print("spawn x   :", x, " spawn y  ", y, "PREFAB", prefab)
		spawn_point_x = x
		spawn_pont_y = y
		print("SPAWWWNNNN", spawn_point_x, spawn_pont_y)
	return _create_sprite(prefab, "SpawnPoint", spawn_point_x, spawn_pont_y, 1, 1)
		
		
func _create_sprite(
	prefab: PackedScene, 
	group: String, 
	x: int, 
	y: int,
	x_offset: int = 0, 
	y_offset: int = 0) -> Node2D:
	var new_sprite = prefab.instantiate()
	new_sprite.position = ConvertCoord.index_to_vector(x, y, x_offset, y_offset)
	new_sprite.add_to_group(group)
	return new_sprite
