extends Area2D


func body_entered(body: Node2D):
	print(body)

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("hiii")
