extends CharacterBody2D

var speed = 400
var DungeonCoords = preload("res://library/DungeonSize.gd").new()
signal player_shrink
signal player_grow
signal player_moved
signal player_attack(collision_id: int)
signal win_cond
signal red_touched
signal blue_touched

var health_points = 100
var is_touched_red = false
var is_touched_blue = false
var win_screen = preload("res://GUI/win_screen.tscn").instantiate()
var target: Node2D

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var path_line: Line2D = $Line2D
var bounds
var is_player_attacking: bool = false

func get_camera_world_rect() -> Rect2:
	var viewport := get_viewport()
	var screen_rect := viewport.get_visible_rect()

	# Canvas transform converts world → screen
	# We invert it to convert screen → world
	var canvas_xform := viewport.get_canvas_transform().affine_inverse()

	var top_left := canvas_xform * screen_rect.position
	var bottom_right := canvas_xform * (screen_rect.position + screen_rect.size)

	return Rect2(top_left, bottom_right - top_left)
	
func _ready() -> void:
	agent.set_target_position(Global.point_a_position)
	var viewport = get_viewport()
	var screen_rect = viewport.get_visible_rect()
	bounds = Rect2(Vector2.ZERO, screen_rect.size)



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.as_text() == "Q":
			player_shrink.emit()
		if event.as_text() == "G":
			player_grow.emit()
		if event.as_text() == "Space":
			is_player_attacking = true
	if event is InputEventMouse:
		if event.button_mask == 1:
			print("click clack")
			
func get_input() -> void:
	velocity.x = 0
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	player_moved.emit()

func _handle_enemy_collision(collision_string: String, collider_id: int):
	if collision_string.find("Dwarf") != -1 || collision_string.find("CharacterBody") != -1:
		if is_player_attacking:
			player_attack.emit(collider_id)
		else:
			health_points -= 1

func _handle_goal_touch(collision_string:String):
	if collision_string.find("Red") != -1:
			is_touched_red = true
			red_touched.emit()
			
func _physics_process(delta):
	get_input()
	var collision = move_and_slide()
	if collision:
		var obj = get_last_slide_collision()
		var collision_object = obj.get_collider().to_string()
		
		_handle_enemy_collision(collision_object, obj.get_collider_id())
				
		_handle_goal_touch(collision_object)
		
	if is_touched_red:
		win_cond.emit()
	global_position.x = clamp(global_position.x, bounds.position.x, bounds.position.x + bounds.size.x)
	global_position.y = clamp(global_position.y, bounds.position.y, bounds.position.y + bounds.size.y)
	is_player_attacking = false
	is_touched_red = false
		

func _process(delta):
	agent.get_next_path_position()
	var world_rect = get_camera_world_rect()
	# Get current path from NavigationAgent2D
	var path = agent.get_current_navigation_path()
	#print(agent.distance_to_target())
	#print(agent.get_current_navigation_path())
	# Draw the path with Line2D
	if path.size() > 0:
		path_line.points = path
	else:
		path_line.points = []
	
