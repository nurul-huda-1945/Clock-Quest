extends Node2D

func queue_point(idx):
#	This function will remove "Point" node based on idx argument when time_left of timer is equal with specific time
	get_child(idx).get_child(0).play("queue")
	Global.min_score += 1

func reset_points():
	for point in get_children():
		point.scale = Vector2(0.113, 0.113)
