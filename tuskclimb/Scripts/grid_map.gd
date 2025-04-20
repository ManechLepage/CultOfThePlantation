class_name GridManager
extends Node2D

@onready var ground: TileMapLayer = $Ground
@onready var structures: TileMapLayer = $Structures
@onready var structure_hover: TileMapLayer = $StructureHover

var buildings: Array[Building]

var hovered: Building

func update_grid() -> void:
	for cell in structures.get_used_cells():
		if structures.get_cell_atlas_coords(cell) != Vector2i(1, 0):
			structures.erase_cell(cell)
	
	for building in buildings:
		structures.set_cell(building.position, 0, building.get_sprite())

func _process(delta: float) -> void:
	update_hover()

func update_hover():
	for cell in structure_hover.get_used_cells():
		structure_hover.erase_cell(cell)
	
	if hovered:
		structure_hover.set_cell(structure_hover.local_to_map(get_global_mouse_position()), 0, hovered.get_sprite())

func place_building(placed_building: Building, pos: Vector2i) -> void:
	for building in buildings:
		if building.position == pos:
			return
	
	hovered = null
	
	var building: Building = placed_building.duplicate(true)
	building.position = pos
	buildings.append(building)
	
	update_grid()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		place_building(hovered, structures.local_to_map(get_global_mouse_position()))
