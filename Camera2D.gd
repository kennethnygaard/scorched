extends Camera2D

onready var tank = get_tree().get_nodes_in_group("tank")[0]

func _ready():
	pass # Replace with function body.

func _process(delta):
	global_position = tank.global_position
