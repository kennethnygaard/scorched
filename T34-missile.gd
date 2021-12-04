extends RigidBody2D

#var already_collided_with_something = false
onready var levels = get_tree().get_nodes_in_group("level")
onready var main = get_tree().get_nodes_in_group("main")[0]
onready var Explosion = preload("res://Explosion_normal.tscn")

func _ready():
	$Explode_collision_area2.connect("area_entered", self, "on_explode")
	
func _physics_process(delta):
	rotation = linear_velocity.angle()
	if(global_position.y > 5000):
		on_explode(null)
		main.change_player()

func on_explode(area2d):
	var new_explosion = Explosion.instance()
	new_explosion.global_position = global_position
	levels[0].add_child(new_explosion)
	
	main.missile_is_in_air = false
	main.start_explosion_cooldown_timer()
	queue_free()
