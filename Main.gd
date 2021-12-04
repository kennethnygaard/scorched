extends Node

var zoom_steps = 0.1
var ready_to_zoom = true

var active_player = 1
var missile_is_in_air = false
var explosion_cooldown = false
var max_camera_zoom_out = 20.0

var player_score = [0, 0]

onready var tanks = get_tree().get_nodes_in_group("tank")
onready var ground_modules = get_tree().get_nodes_in_group("ground")


func _ready():
	$Camera2D/Zoom_timer.connect("timeout", self, "on_zoom_timer_timeout")
	$Explosion_cooldown_timer.connect("timeout", self, "on_explosion_cooldown_timer_timeout")
	reset_positions()
	tanks[0].connect("tank_exploded", self, "on_tank_exploded")
	tanks[1].connect("tank_exploded", self, "on_tank_exploded")
	
	$Camera2D.zoom = Vector2(3.0, 3.0)
	
	update_scores()
	set_font_colors()
	
	for ground_module in ground_modules:
		ground_module.connect("hit_ground", self, "on_hit_ground")
	
func _process(delta):
	if(Input.is_action_pressed("zoom_out") && ready_to_zoom):
		$Camera2D.zoom += Vector2(zoom_steps, zoom_steps)
		$Camera2D/Zoom_timer.start(0.01)
	if(Input.is_action_pressed("zoom_in") && ready_to_zoom):
		$Camera2D.zoom -= Vector2(zoom_steps, zoom_steps)
		$Camera2D/Zoom_timer.start(0.01)
	$Camera2D.zoom.x = clamp($Camera2D.zoom.x, 1.5, max_camera_zoom_out)
	$Camera2D.zoom.y = clamp($Camera2D.zoom.y, 1.5, max_camera_zoom_out)
		
	if(Input.is_action_just_pressed("next_player")):
		active_player = 1 - active_player

	if(Input.is_action_just_pressed("debug_key")):
		$Level_001.reset_tank_positions()

	set_font_colors()

func on_zoom_timer_timeout():
	ready_to_zoom = true

func start_explosion_cooldown_timer():
	explosion_cooldown = true
	$Explosion_cooldown_timer.start(2)

func on_explosion_cooldown_timer_timeout():
	explosion_cooldown = false
	
func reset_positions():
	for tank in tanks:
		tank.visible = true
	$Level_001.reset_tank_positions()

func on_tank_exploded(tank_number):
	print("tank ", tank_number, " exploded")
	player_score[tank_number] += 1
	active_player = 1-active_player
	reset_positions()
	update_scores()

func update_scores():
	$HUD/HBoxContainer/Player1_score.text = "PLAYER 1: " + str(player_score[0])
	$HUD/HBoxContainer/Player2_score.text = "PLAYER 2: " + str(player_score[1])

func set_font_colors():
	if(active_player==0):
		$HUD/HBoxContainer/Player1_score.set("custom_colors/font_color",Color(1,1,1))
		$HUD/HBoxContainer/Player2_score.set("custom_colors/font_color",Color(0,1,0))
	else:
		$HUD/HBoxContainer/Player1_score.set("custom_colors/font_color",Color(0,1,0))
		$HUD/HBoxContainer/Player2_score.set("custom_colors/font_color",Color(1,1,1))

func on_hit_ground():
	change_player()

func change_player():
	active_player = 1 - active_player
	tanks[active_player].refill_diesel()
