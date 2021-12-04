extends Camera2D

onready var tanks = get_tree().get_nodes_in_group("tank")
onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	if(main.explosion_cooldown):
		pass
	elif(main.missile_is_in_air):
		var missile = get_tree().get_nodes_in_group("missile")[0]
		global_position = missile.global_position
	else:
		var target_x
		if(main.active_player == 1):
			target_x = tanks[main.active_player].global_position.x -500 + 1920*zoom.x/4.2

		else:
			target_x = tanks[main.active_player].global_position.x +500 - 1920*zoom.x/4.2
		
		global_position.x = move_toward(global_position.x, target_x, 250)
			
		global_position.y = move_toward(global_position.y, tanks[main.active_player].global_position.y, 250)
