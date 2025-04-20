extends Node2D

@onready var grid_map: GridManager = $GridMap

var energy: int
var food: int

func _on_next_turn_button_pressed() -> void:
	load_next_turn()

func load_next_turn() -> void:
	for building in grid_map.buildings:
		energy += building.energy_production - building.energy_cost
		food += building.food_production - building.food_cost
