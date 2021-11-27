extends Node

var zoom_steps = 0.1
var ready_to_zoom = true

func _ready():
	$Camera2D/Zoom_timer.connect("timeout", self, "on_zoom_timer_timeout")
	
func _process(delta):
	if(Input.is_action_pressed("zoom_out") && ready_to_zoom):
		$Camera2D.zoom += Vector2(zoom_steps, zoom_steps)
		$Camera2D/Zoom_timer.start(0.01)
	if(Input.is_action_pressed("zoom_in") && ready_to_zoom):
		$Camera2D.zoom -= Vector2(zoom_steps, zoom_steps)
		$Camera2D/Zoom_timer.start(0.01)
	$Camera2D.zoom.x = clamp($Camera2D.zoom.x, 1.5, 10.0)
	$Camera2D.zoom.y = clamp($Camera2D.zoom.y, 1.5, 10.0)
		

func on_zoom_timer_timeout():
	ready_to_zoom = true
