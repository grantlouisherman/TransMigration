extends CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_size = get_viewport().size
	var viewport_height = viewport_size.y * 2
	var rect = shape as RectangleShape2D
	rect.extents = Vector2(10, viewport_height)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
