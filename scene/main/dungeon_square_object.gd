extends Node2D
var rng = RandomNumberGenerator.new()
var SpriteUtils = preload("res://library/SpriteUtils.gd").new()
var DungeonSize = preload("res://library/DungeonSize.gd").new()
var GroupName = preload("res://library/GroupName.gd").new()
var Wall = preload("res://sprites/wall.tscn")
var start_pos_x:float
var start_pos_y:float

func _draw():
	var rect =  get_viewport_rect()
	#800,640
	var r = Rect2(Vector2(start_pos_x, start_pos_y),Vector2(800.0, 640.0))
	draw_rect(r, Color.BLACK, false, 2.0)
	

func create_dungeon_square(start_pos_x: int, start_pos_y: int):
		print(start_pos_x, start_pos_y)
		start_pos_x=start_pos_x
		start_pos_y=start_pos_y
		_create_dungeon(DungeonSize.WIDTH, DungeonSize.HEIGHT, Wall, GroupName.DUNGEON, true)

func _create_dungeon(width:int, height:int, prefab: PackedScene, group: String, doRandom: bool):
	var xPos = start_pos_x
	var yPos = start_pos_y
	while yPos < height:
		var rand_number = rng.randi_range(0,5)
		if doRandom:
			if rand_number == 1:
				add_child(SpriteUtils._create_sprite(prefab, group, xPos, yPos, 1, 1))
		else:
			add_child(SpriteUtils._create_sprite(prefab, group, xPos, yPos, 1, 1))
		xPos+=1
		if xPos >= width:
			xPos = 0
			yPos+=1
