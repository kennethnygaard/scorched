extends RigidBody2D

var move_vector = Vector2.ZERO
var engine_power = 3
onready var wheels = get_tree().get_nodes_in_group("wheel")
	
func _ready():
	friction = 0.5
	bounce = 0.25
	apply_scale(Vector2(2, 2))
	$Turret/Sprite.flip_h = false
	
func _process(delta):
	pass

func _physics_process(delta):
	var ang_vel = 0
	move_vector.x = 0
	if(Input.is_action_pressed("ui_left")):
		ang_vel -= engine_power
		move_vector.x -= 10
	if(Input.is_action_pressed("ui_right")):
		ang_vel += engine_power
		move_vector.x += 10

	for wheel in wheels:	
		wheel.angular_velocity = ang_vel
	
	move_vector.y = -1
	#apply_impulse(Vector2.ZERO, move_vector)
	
	

