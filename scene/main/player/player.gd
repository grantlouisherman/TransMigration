extends CharacterBody2D
var speed = 400
signal player_shrink
signal player_grow
signal player_moved
signal win_cond
signal red_touched
signal blue_touched
var is_touched_red = false
var is_touched_blue = false
var win_screen = preload("res://GUI/win_screen.tscn").instantiate()
var target: Node2D

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var path_line: Line2D = $Line2D

func _ready() -> void:
	print("POINT A POS", Global.point_a_position)
	agent.set_target_position(Global.point_a_position)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.as_text() == "Q":
			player_shrink.emit()
		if event.as_text() == "G":
			player_grow.emit()
	if event is InputEventMouse:
		if event.button_mask == 1:
			print("click clack")
			
func get_input() -> void:
	velocity.x = 0
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	player_moved.emit()
	
func _physics_process(delta):
	get_input()
	var collision = move_and_slide()
	if collision:
		var obj = get_last_slide_collision()
		var collision_object = obj.get_collider().to_string()
		if collision_object.find("Red") != -1:
			is_touched_red = true
			red_touched.emit()
		if collision_object.find("Blue") != -1:
			is_touched_blue = true
			blue_touched.emit()
	if is_touched_blue and is_touched_red:
		win_cond.emit()
		

func _process(delta):
	agent.get_next_path_position()

	# Get current path from NavigationAgent2D
	var path = agent.get_current_navigation_path()
	#print(agent.distance_to_target())
	#print(agent.get_current_navigation_path())
	# Draw the path with Line2D
	if path.size() > 0:
		path_line.points = path
	else:
		path_line.points = []
	
	
