extends Node2D
# Signals
signal move_walls
signal score_update(score)

# Imported Assets
var InputName = preload("res://library/InputName.gd").new()
var DungeonCoords = preload("res://library/DungeonSize.gd").new()
var Dwarves = preload("res://sprites/dwarf.tscn")
var ConvertCoord = preload("res://library/ConvertCoord.gd").new()
var SpriteUtils = preload("res://library/SpriteUtils.gd").new()
var PointA = preload("res://scene/points/point_a.tscn")

# Global Variables (Constants) 
var RNG = RandomNumberGenerator.new()
var SCORE_PER_POINT_TOUCH = 100

# Global Variables (Mutable)
var total_score = 0

var PLAYER_INVENTORY = {
	"weapon": null
}

func _ready() -> void:
	var player = get_tree().get_nodes_in_group("SpawnPoint")[0]
	player.connect('win_cond', _won)
	player.connect('red_touched', _red_touched)
	player.connect('player_attack', _player_attack)
	player.connect('item_pickup', _handle_item_pickup)
	
func _create_enemies():
	for i in range(0, 1):
		var new_x = RNG.randi_range(0, DungeonCoords.MAX_X)
		var new_y = RNG.randi_range(0, DungeonCoords.MAX_Y)
		add_child(SpriteUtils._create_sprite(Dwarves, "Enemies", new_x, new_y))
		
func _won() -> void:
	move_walls.emit()

func _red_touched():
	randomize()
	total_score += SCORE_PER_POINT_TOUCH
	score_update.emit(total_score)
	var node = (get_tree().get_nodes_in_group("SpawnPoint")[1])
	node.queue_free()
	
	var view = get_viewport_rect()
	
	var new_x = RNG.randi_range(0, DungeonCoords.MAX_X)
	var new_y = RNG.randi_range(0, DungeonCoords.MAX_Y)
	add_child(SpriteUtils._create_spawn_point(new_x, new_y, PointA, true))
	_create_enemies()

func _player_attack(collision_id: int) -> void:
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		if enemy.get_instance_id() == collision_id:
			var health_bar = enemy._handle_taken_damage()
			if health_bar == 0:
				enemy.queue_free()

func _handle_item_pickup(item: String) -> void:
	# TODO classify item
	PLAYER_INVENTORY["weapon"] = item
