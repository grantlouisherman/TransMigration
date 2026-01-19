extends Node2D

signal sprite_created(new_sprite: Sprite2D)

#  Util Resources
var ConvertCoord = preload("res://library/ConvertCoord.gd").new()
var GroupName = preload("res://library/GroupName.gd").new()
var Main = preload("res://scene/main/scripts/main_scene.gd").new()
var DungeonSize = preload("res://library/DungeonSize.gd").new()
var SpriteUtils = preload("res://library/SpriteUtils.gd").new()

#  Dungeon Scenes
var Wall = preload("res://sprites/wall.tscn")
var Floor = preload("res://sprites/floor.tscn")
var Boundary = preload("res://scene/main/boundaries/Boundary.tscn")
var VerticalBoundary = preload("res://scene/main/boundaries/Boundary_vertical.tscn")
var DungeonSquareObject = preload("res://scene/main/dungeon_square_object.tscn")
# Play Objects
var Player = preload("res://sprites/player.tscn")
var PointA = preload("res://scene/points/point_a.tscn")
var Weapon01 = preload("res://scene/main/items/weapon_01.tscn")

# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()
var last_wall_location
var spawn_point_x = 0
var spawn_pont_y = 0
var cooldown = 1.0
var tile_size = 32




func _ready() -> void:
	var view_size = get_viewport_rect()

	var viewport_size = view_size.size
	
	var viewport_width = viewport_size.x
	var viewport_height = viewport_size.y
	
	var grid_width = DungeonSize.WIDTH
	var grid_height = DungeonSize.HEIGHT
	
	
	var view = get_viewport_rect()
	var bounds = Rect2(Vector2.ZERO, view.size)
	var bound_x = bounds.size.x
	var bound_y = bounds.size.y
	var rand_x = randf_range(bounds.position.x, bounds.position.x + bounds.size.x)
	var rand_y = randf_range(bounds.position.y, bounds.position.y + bounds.size.y)
	
	# Player Spawn
	var player = SpriteUtils._create_spawn_point(DungeonSize.CENTER_X, DungeonSize.CENTER_Y, Player)
	add_child(player)
	# Point A + B Spawn
	var point_a = SpriteUtils._create_spawn_point(0, 0, PointA, true)
	add_child(point_a)
	# Initial Weapon
	var weapon01 = SpriteUtils._create_spawn_point(DungeonSize.CENTER_X, DungeonSize.CENTER_Y, Weapon01)
	add_child(weapon01)
	
	var dq = DungeonSquareObject.instantiate()
	var dq2 = DungeonSquareObject.instantiate()
	dq.create_dungeon_square(0,0)
	add_child(dq)
	dq2.create_dungeon_square(0,641)
	add_child(dq2)
	
	
#func _process(delta: float) -> void:
	#cooldown -= delta
	#if cooldown <= 0:
		#_create_dungeon_walls()
		#cooldown = 1.0
	

func _create_boundary(x:int, y:int, prefab: PackedScene):
	add_child(SpriteUtils._create_sprite(prefab, "Boundaries", x, y, 100, 100))


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
		SpriteUtils._create_sprite(Wall, 
			GroupName.DUNGEON,
			row,
			column,
			DungeonSize.MAX_X,
			DungeonSize.MAX_Y)
