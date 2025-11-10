extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var player = get_tree().get
	var n = get_parent()
	n.connect("move_walls", _receive_wall_move_signal)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _receive_wall_move_signal():
	print("received")
