extends Button

var building: Building


func _on_pressed() -> void:
	get_tree().get_first_node_in_group("GridManager").hovered = building
