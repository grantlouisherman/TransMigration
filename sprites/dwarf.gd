extends CharacterBody2D


const SPEED = 100.0
var _direction:Vector2 = Vector2()
var acceleration = 1.5
var should_move_this_frame = true
func _physics_process(delta: float) -> void:
	#if !should_move_this_frame:
		#pass
	_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	velocity = lerp(velocity, _direction, delta*acceleration*SPEED)
	should_move_this_frame =!should_move_this_frame
	move_and_slide()

func _process(delta):
	pass
