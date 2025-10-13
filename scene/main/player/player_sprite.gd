extends Sprite2D
#var Player = preload("res://sprite/PC.tscn")

var shrink_amount = 0.1 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_parent()	
	player.connect("player_shrink", _shrink_sprite)
	player.connect("player_grow", _grow)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _shrink_sprite():
	scale -= Vector2(shrink_amount, shrink_amount)

func _grow():
	scale+= Vector2(shrink_amount, shrink_amount)
	
			
