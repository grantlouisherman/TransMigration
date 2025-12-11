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
var tile_size = 32


func _draw():
	var rect =  get_viewport_rect()
	draw_rect(rect, Color.BLACK, false, 2.0)

func _ready() -> void:
	var view_size = get_viewport_rect()

	var viewport_size = view_size.size
	
	var viewport_width = viewport_size.x
	var viewport_height = viewport_size.y
	
	var grid_width = int(viewport_width / tile_size)
	var grid_height = int(viewport_height / tile_size)
	
	print("WIDTH: ", viewport_width,"  Height: ",  viewport_height)
	var view = get_viewport_rect()
	var bounds = Rect2(Vector2.ZERO, view.size)
	var bound_x = bounds.size.x
	var bound_y = bounds.size.y
	var rand_x = randf_range(bounds.position.x, bounds.position.x + bounds.size.x)
	var rand_y = randf_range(bounds.position.y, bounds.position.y + bounds.size.y)
	# Player Spawn
	_create_spawn_point(rand_x, rand_y, Player)

	# Point A + B Spawn
	_create_spawn_point(0, 0, PointA, true)
	
	# Create Dungeon Floor && Walls
	#_create_dungeon(DungeonSize.MAX_X*2, DungeonSize.MAX_Y*2, Floor, GroupName.DUNGEON, false)
	_create_dungeon(grid_width, grid_height, Wall, GroupName.DUNGEON, true)
	
	
#func _process(delta: float) -> void:
	#cooldown -= delta
	#if cooldown <= 0:
		#_create_dungeon_walls()
		#cooldown = 1.0
	

func _create_boundary(x:int, y:int, prefab: PackedScene):
	_create_sprite(prefab, "Boundaries", x, y, 100, 100)


func _create_spawn_point(x: int, y: int, prefab: PackedScene, set_global = false):
		
		if set_global:
			if prefab == PointA:
				Global.point_a_position = Vector2(x, y)
				print("spawn x   :", x, " spawn y  ", y, "PREFAB", prefab)
		spawn_point_x = x
		spawn_pont_y = y
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
