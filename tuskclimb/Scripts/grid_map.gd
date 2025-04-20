class_name GridManager
extends Node2D

@onready var ground: TileMapLayer = $Ground
@onready var structures: TileMapLayer = $Structures
@onready var structure_hover: TileMapLayer = $StructureHover

@export var grass_tile: Building

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
		var pos: Vector2i = structure_hover.local_to_map(get_global_mouse_position())
		#if hovered == grass_tile:
			#pos = adjust_pos(pos)
		structure_hover.set_cell(pos, 0, hovered.get_sprite())

func handle_placing() -> void:
	if not hovered:
		return
	var pos: Vector2i = structures.local_to_map(get_global_mouse_position())
	if hovered == grass_tile:
		pos = adjust_pos(pos)
		ground.set_cell(pos, 0, grass_tile.get_sprite())
	else:
		place_building(hovered, pos)

func place_building(placed_building: Building, pos: Vector2i) -> void:
	for building in buildings:
		if building.position == pos:
			return
	
	if hovered.only_grass and ground.get_cell_atlas_coords(pos) != grass_tile.get_sprite():
		return
	
	hovered = null
	
	var building: Building = placed_building.duplicate(true)
	building.position = pos
	buildings.append(building)
	
	update_grid()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		handle_placing()

func adjust_pos(pos: Vector2i) -> Vector2i:
	if pos.x % 2 == 0:
		return pos - Vector2i(0, 0)
	return pos - Vector2i(0, 0)
