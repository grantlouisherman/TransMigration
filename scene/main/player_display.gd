extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	parent.connect("score_update", _handle_score_update)
	add_text("Current Score : 0")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _handle_score_update(score: int):
	clear()
	var new_score_text = "Current Score: {score}".format({"score": score})
	add_text(new_score_text)
