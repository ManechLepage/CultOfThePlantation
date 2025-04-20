extends Control

@onready var knowledge_label: Label = $knowledge/Label
@onready var food_label: Label = $food/Label
@onready var culture_label: Label = $Culture/Label
@onready var energy_label: Label = $energy/Label

func load_resources(food: int, energy: int, culture: int, knowledge: int) -> void:
	food_label.text = str(food)
	energy_label.text = str(energy)
	culture_label.text = str(culture)
	knowledge_label.text = str(knowledge)
