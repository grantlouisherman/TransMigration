extends NavigationAgent2D

const move_speed = 1200.0

func _process(delta):
	var path = navigation_agent.get_current_navigation_path()
	$Line2D.points = path
