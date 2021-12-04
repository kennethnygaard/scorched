extends StaticBody2D

signal hit_ground

func _ready():
	$Explode_area.connect("area_entered", self, "on_missile_hit_ground")

func get_left_point():
	return $Left__top_point.global_position

func get_right_point():
	return $Right_top_point.global_position
	
func get_tank_start_point():
	return $Tank_start_point.global_position

func on_missile_hit_ground(area2d):
	emit_signal("hit_ground")
