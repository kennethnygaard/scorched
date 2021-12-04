extends Node

var terrains = []
var x_pos = 0
var module_width = 1920

export(Array, PackedScene) var Terrain_modules

onready var terrains_in_array = Terrain_modules.size()
var number_of_terrains = 10

func _ready():
	generate_terrains()
	reset_tank_positions()

func generate_terrains():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(number_of_terrains):
		var terrain_number = rng.randi_range(0, terrains_in_array-1)
		var new_terrain = Terrain_modules[terrain_number].instance()
		new_terrain.global_position.y = 2700
		new_terrain.global_position.x = x_pos
		x_pos += module_width
		terrains.append(new_terrain)
		add_child(new_terrain)

		if(i>0):
			var diff = terrains[i-1].get_right_point().y - terrains[i].get_left_point().y
			terrains[i].global_position.y += diff

func reset_tank_positions():
	$PanzerIV.global_position = terrains[0].get_tank_start_point()
	$PanzerIV.rotation = 0
	$Tank.global_position = terrains[9].get_tank_start_point()
	$Tank.rotation = 0
