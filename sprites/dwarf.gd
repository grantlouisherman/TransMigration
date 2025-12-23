extends CharacterBody2D
class_name Dwarf
const SPEED = 90.0
const ACCEL = 4.0
const DIRECTION_CHANGE_INTERVAL = 1.0  # seconds
signal player_collision
var _direction: Vector2 = Vector2.ZERO
var _time_until_change := 0.0
var bounds
func _ready() -> void:
	var view = get_viewport_rect()
	bounds = Rect2(Vector2.ZERO, view.size)

func _physics_process(delta):
	# Countdown until we pick a new direction
	_time_until_change -= delta
	if _time_until_change <= 0.0:
		# Pick a new random direction
		_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
		_time_until_change = DIRECTION_CHANGE_INTERVAL

	# Smoothly accelerate toward target direction
	velocity = lerp(velocity, _direction * SPEED, delta * ACCEL)
	var collision = move_and_slide()
	if collision:
		var obj = get_last_slide_collision()
		
		var collision_object = obj.get_collider().to_string()
		if collision_object.find("Player") != -1:
			player_collision.emit()
	global_position.x = clamp(global_position.x, bounds.position.x, bounds.position.x + bounds.size.x)
	global_position.y = clamp(global_position.y, bounds.position.y, bounds.position.y + bounds.size.y)
