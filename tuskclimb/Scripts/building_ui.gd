extends Panel

@export var building_slot: PackedScene

@export var buildings: Array[Building]

func _ready() -> void:
	for building in buildings:
		var building_instance = building_slot.instantiate()
		
		get_child(0).add_child(building_instance)
