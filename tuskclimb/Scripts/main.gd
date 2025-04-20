extends Node2D

@onready var grid_map: GridManager = $GridMap
@onready var resources: Control = $CanvasLayer/Screen/Resources

var energy: int
var food: int
var culture: int
var knowledge: int

func _on_next_turn_button_pressed() -> void:
	load_next_turn()

func load_next_turn() -> void:
	for building in grid_map.buildings:
		energy += building.energy_production 
		energy -= building.energy_cost
		food += building.food_production
		food -= building.food_cost
		culture += building.culture_production
		knowledge += building.knowledge_production
	
	resources.load_resources(food, energy, culture, knowledge)
