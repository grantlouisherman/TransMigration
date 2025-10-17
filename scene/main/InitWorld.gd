extends Node2D

signal sprite_created(new_sprite: Sprite2D)

var ConvertCoord = preload("res://library/ConvertCoord.gd").new()
var GroupName = preload("res://library/GroupName.gd").new()
var Main = preload("res://scene/main/main_scene.gd").new()
var DungeonSize = preload("res://library/DungeonSize.gd").new()
var Player = preload("res://sprites/player.tscn")
var Wall = preload("res://sprites/wall.tscn")
var Floor = preload("res://sprites/floor.tscn")
var Dwarf = preload("res://sprites/dwarf.tscn")
var ArrowX = preload("res://sprites/arrow_x.tscn")
var ArrowY = preload("res://sprites/arrow_y.tscn")
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
	_create_dungeon(viewport_width/2, viewport_height/2, Floor, GroupName.DUNGEON, false)
	_create_spawn_point(viewport_width, viewport_height)
	_create_dungeon(viewport_width/2, viewport_height/2, Wall, GroupName.DUNGEON, true)

	
#func _process(delta: float) -> void:
	#cooldown -= delta
	#if cooldown <= 0:
		#_create_dungeon_walls()
		#cooldown = 1.0
	
	
func _create_spawn_point(max_x: int, max_y: int):
		var rand_x = rng.randf_range(0, max_x)
		var rand_y = rng.randf_range(0,  max_y )
		print("spawn x   :", rand_x, " spawn y  ", rand_y)
		spawn_point_x = rand_x
		spawn_pont_y = rand_y
		_create_sprite(Player, "SpawnPoint", 0, 10, 1, 1)
		
		
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
		if xPos == spawn_point_x:
			xPos+=1
		if xPos >= width:
			xPos = 0
			yPos+=1
			if yPos == spawn_pont_y:
				yPos+=1

	
