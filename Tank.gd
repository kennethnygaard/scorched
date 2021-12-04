extends RigidBody2D

var move_vector = Vector2.ZERO
var engine_power = 20
onready var wheels = get_tree().get_nodes_in_group("wheel")
onready var level = get_tree().get_nodes_in_group("level")[0]
onready var main = get_tree().get_nodes_in_group("main")[0]
var engine_volume = 15
var ang_vel = 0
var gun_power = 50
var max_missile_velocity = 3000
var diesel_consumption = 0.1
var diesel = 100.0

onready var Missile = preload("res://T34-missile.tscn") 
onready var Big_Explosion = preload("res://Big_Explosion.tscn")

signal tank_exploded(tank_number)

func _ready():
	friction = 0.5
	bounce = 0.25
	$Turret/Sprite.flip_h = false
	$AudioStreamPlayer/Rev_timer.connect("timeout", self, "rev_timeout")
	$AudioStreamPlayer/Rev_timer.start(0.1)

	$CannonPower.value = gun_power
	set_engine_volume(10)
	$Hit_area.connect("area_entered", self, "on_hit_by_missile")
	$Hit_by_missile_timer.connect("timeout", self, "hit_by_missile_timeout")
	
func _process(delta):
	pass

func _physics_process(delta):
	ang_vel = 0
	move_vector.x = 0
	if(main.active_player == 0):
		get_input()

	for wheel in wheels:	
		wheel.angular_velocity = ang_vel

	update_diesel_meter()

func get_input():
	if(Input.is_action_pressed("ui_left")):
		if(diesel > 0):
			diesel -= diesel_consumption
			ang_vel -= engine_power
	if(Input.is_action_pressed("ui_right")):
		if(diesel > 0):
			diesel -= diesel_consumption
			ang_vel += engine_power
	if(Input.is_action_pressed("increase_gun_power")):
		$CannonPower.value += 1
	if(Input.is_action_pressed("decrease_gun_power")):
		$CannonPower.value -= 1

	if(Input.is_action_pressed("cannon_up")):
		$Turret/Cannon.rotation += 0.02
	if(Input.is_action_pressed("cannon_down")):
		$Turret/Cannon.rotation -= 0.02
	$Turret/Cannon.rotation = clamp($Turret/Cannon.rotation, -0.25, 0.7)
	
	if(Input.is_action_just_pressed("fire_cannon")):
		if(!main.missile_is_in_air):
			fire_cannon()
	
	if(Input.is_action_just_pressed("debug_key")):
		print("cannon rotation: ", $Turret/Cannon.rotation)

func set_engine_volume(percent):
	$AudioStreamPlayer.set_volume_db(linear2db(percent/100.0))

func rev_timeout():
	if(abs(ang_vel) > 0):
		engine_volume += 1.5
		$AudioStreamPlayer.pitch_scale += 0.02
	else:
		engine_volume -= 1.5
		$AudioStreamPlayer.pitch_scale -= 0.02

	engine_volume = clamp(engine_volume, 15, 45)
	$AudioStreamPlayer.pitch_scale = clamp($AudioStreamPlayer.pitch_scale, 1.0, 1.3)
	set_engine_volume(engine_volume)

func fire_cannon():
	main.missile_is_in_air = true
	var new_missile = Missile.instance()
	var angle = $Turret/Cannon.rotation
	new_missile.rotation = angle+rotation-PI
	var direction_vector = Vector2(cos(new_missile.rotation), sin(new_missile.rotation))

	var missile_velocity = 200 + $CannonPower.value / 100 * max_missile_velocity
	new_missile.linear_velocity = direction_vector * missile_velocity

	new_missile.global_position = $Turret/Cannon/Exit_point.global_position
	level.add_child(new_missile)

func on_hit_by_missile(area2d):
	var new_big_explosion = Big_Explosion.instance()
	new_big_explosion.global_position = global_position
	level.add_child(new_big_explosion)
	visible = false
	$Hit_by_missile_timer.start(3)

func hit_by_missile_timeout():
	emit_signal("tank_exploded", 0)

func update_diesel_meter():
	$DieselMeter.value = diesel

func refill_diesel():
	diesel = 100.0
