extends Node2D

signal sprite_created(new_sprite: Sprite2D)

var ConvertCoord = preload("res://library/ConvertCoord.gd").new()
var GroupName = preload("res://library/GroupName.gd").new()
var Main = preload("res://scene/main/scripts/main_scene.gd").new()
var DungeonSize = preload("res://library/DungeonSize.gd").new()
var Player = preload("res://sprites/player.tscn")
var Wall = preload("res://sprites/wall.tscn")
var Floor = preload("res://sprites/floor.tscn")
var Dwarf = preload("res://sprites/dwarf.tscn")
var ArrowX = preload("res://sprites/arrow_x.tscn")
var ArrowY = preload("res://sprites/arrow_y.tscn")
var PointA = preload("res://scene/points/point_a.tscn")
#var PointB = preload("res://scene/points/point_b.tscn")
var Boundary = preload("res://scene/main/boundaries/Boundary.tscn")
var VerticalBoundary = preload("res://scene/main/boundaries/Boundary_vertical.tscn")
# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()
var last_wall_location
var spawn_point_x = 0
var spawn_pont_y = 0
var cooldown = 1.0


func _ready() -> void:
	var viewport_size = get_viewport().size
	var viewport_width = viewport_size.x / 2
	var viewport_height = viewport_size.y /2
	print("WIDTH: ", viewport_width,"  Height: ",  viewport_height)
	# Player Spawn
	_create_spawn_point(DungeonSize.MAX_X, DungeonSize.MAX_Y, Player)

	# Point A + B Spawn
	_create_spawn_point(DungeonSize.MAX_X, DungeonSize.MAX_Y, PointA, true)
	#_create_spawn_point(viewport_width, viewport_height * .25, PointB, true)
	
	# Create Dungeon Floor && Walls
	_create_dungeon(DungeonSize.MAX_X*2, DungeonSize.MAX_Y*2, Floor, GroupName.DUNGEON, false)
	_create_dungeon(DungeonSize.MAX_X*2, DungeonSize.MAX_Y*2, Wall, GroupName.DUNGEON, true)
	
	# Create Boundaries
	#_create_boundary(0,0, Boundary)
	#_create_boundary(0,viewport_height*.25, Boundary)
	#
	#_create_boundary(0,0, VerticalBoundary)
	#_create_boundary(viewport_width*.25,0, VerticalBoundary)
	
#func _process(delta: float) -> void:
	#cooldown -= delta
	#if cooldown <= 0:
		#_create_dungeon_walls()
		#cooldown = 1.0
	

func _create_boundary(x:int, y:int, prefab: PackedScene):
	_create_sprite(prefab, "Boundaries", x, y, 100, 100)


func _create_spawn_point(max_x: int, max_y: int, prefab: PackedScene, set_global = false):
		var rand_x = randi_range(0, max_x)
		var rand_y = randi_range(0, max_y)
		if set_global:
			if prefab == PointA:
				Global.point_a_position = Vector2(rand_x, rand_y)
		print("spawn x   :", rand_x, " spawn y  ", rand_y)
		spawn_point_x = rand_x
		spawn_pont_y = rand_y
		_create_sprite(prefab, "SpawnPoint", spawn_point_x, spawn_pont_y, 1, 1)
		
		
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
	sprite_created.emit(new_sprite)

func _create_dungeon(width:int, height:int, prefab: PackedScene, group: String, doRandom: bool):
	var xPos = 0
	var yPos = 0
	while yPos < height:
		var rand_number = rng.randi_range(0,5)
		if doRandom:
			if rand_number == 1:
				_create_sprite(prefab, group, xPos, yPos, 1, 1)
		else:
			_create_sprite(prefab, group, xPos, yPos, 1, 1)
		xPos+=1
		if xPos >= width:
			xPos = 0
			yPos+=1


func _create_dungeon_walls():
	#if last_wall_location == null:
	#var rand_x = rng.randf_range(DungeonSize.MAX_X*-1, DungeonSize.MAX_X)
	#var rand_y = rng.randf_range(DungeonSize.MAX_Y*-1,  DungeonSize.MAX_Y )
	#var row = rand_x
	#var column = rand_y
	#_create_sprite(Wall, 
			#GroupName.DUNGEON,
			#row,
			#column,
			#DungeonSize.MAX_X,
			#DungeonSize.MAX_Y)
	for i in range(100):
		var rand_x = rng.randf_range(DungeonSize.MAX_X*-1, DungeonSize.MAX_X)
		var rand_y = rng.randf_range(DungeonSize.MAX_Y*-1,  DungeonSize.MAX_Y )
		var row = rand_x
		var column = rand_y
		_create_sprite(Wall, 
			GroupName.DUNGEON,
			row,
			column,
			DungeonSize.MAX_X,
			DungeonSize.MAX_Y)
