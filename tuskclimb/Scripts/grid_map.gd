class_name GridManager
extends Node2D
@onready var water = $Ground2
@onready var ground: TileMapLayer = $Ground
@onready var structures: TileMapLayer = $Structures
@onready var structure_hover: TileMapLayer = $StructureHover
@onready var overlay: TileMapLayer = $Overlay
@export var trees: Building
@export var grass_tile: Building
@onready var jicleur = $"../GPUParticles2D"
@onready var laser = $"../GPUParticles2D2"
@onready var node_2d = $"../Node2D"
@onready var circ = $"../Sprite-0003"

var inspiration = 0
var buildings: Array[Building]
var sand = [Vector2i(0,2),Vector2i(0,3),Vector2i(0,4),Vector2i(0,5), Vector2i(0,7)]
var hovered: Building
var radius: int = 0
var jicle = []
var lase = []
func circle():
	var m = 0
	for building in buildings:
		if ground.get_cell_atlas_coords(building.position) == Vector2i(0,0):
			m = max(2*building.position.x^2+building.position.y^2, m)
	
	m = sqrt(m)
	circ.scale.x += 0.8*m
	circ.scale.y += m
	circ.position.y -= 7*m
func duplicate_jicleur():
	var new_jicleur = jicleur.duplicate()
	var pos = structures.local_to_map(get_global_mouse_position())
	new_jicleur.global_position = structures.map_to_local(pos)
	new_jicleur.emitting = true
	new_jicleur.visible = true
	add_child(new_jicleur)
	jicle.append(new_jicleur)

func duplicate_laser():
	var new_laser = laser.duplicate()
	var pos = structures.local_to_map(get_global_mouse_position())
	new_laser.global_position = structures.map_to_local(pos)
	new_laser.global_position.y += -25
	new_laser.emitting = true
	new_laser.visible = true

	add_child(new_laser)
	lase.append(new_laser)
func _ready():
	node_2d._draw()
	update_grid()
func inspired():
	inspiration = 0
	for cell in structures.get_used_cells():
		if structures.get_cell_atlas_coords(cell) == Vector2i(1,0):
			inspiration += 1
func update_grid() -> void:
	inspired()
	for building in buildings:
		structures.set_cell(building.position, 0, building.get_sprite())		
	for jic in jicle:
		var pos = structures.local_to_map(jic.position)
		if structures.get_cell_atlas_coords(pos) != Vector2i(1,0):
			jic.queue_free()
			jicle.erase(jic)
			for las in lase:
				las.queue_free()
				lase.erase(las)
	for cell in ground.get_used_cells():
		if cornball(cell, 5*sqrt(inspiration)):
			if ground.get_cell_atlas_coords(cell) in sand:
				ground.set_cell(cell, 0, Vector2i(0,0))
			if ground.get_cell_atlas_coords(cell) == Vector2i(1,2):
				ground.set_cell(cell, 0, Vector2i(0,1))
			if water.get_cell_atlas_coords(cell) == Vector2i(1,2):
				water.set_cell(cell, 0, Vector2i(0,1))
		else:
			if ground.get_cell_atlas_coords(cell) == Vector2i(0,0):
				ground.set_cell(cell, 0, Vector2i(0,2))
			if ground.get_cell_atlas_coords(cell) == Vector2i(0,1):
				ground.set_cell(cell, 0, Vector2i(1,2))
			if water.get_cell_atlas_coords(cell) == Vector2i(0,1):
				water.set_cell(cell, 0, Vector2i(1,2))
func _process(delta: float) -> void:
	update_hover()
	draw_selection()
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
		if structures.get_cell_atlas_coords(pos) == Vector2i(1,0):
			
			if randi_range(1,3) == 1:
				duplicate_jicleur()
			if randi_range(1,3) == 1:	
				duplicate_laser()
			update_grid()
			circle()
func erase() -> void:
	var pos: Vector2i = structures.local_to_map(get_global_mouse_position())

	pos = adjust_pos(pos)
	structures.erase_cell(pos)
	for building in buildings:
		if building.position == pos:
			buildings.erase(building)
	update_grid()

func place_building(placed_building: Building, pos: Vector2i) -> void:
	for building in buildings:
		if building.position == pos:
			return
	
	if hovered.only_grass and ground.get_cell_atlas_coords(pos) != Vector2i(0,0):
		return
	
	hovered = null
	
	var building: Building = placed_building.duplicate(true)
	building.position = pos
	buildings.append(building)
	
	update_grid()
func get_mouse_grid_position() -> Vector2i:
	return overlay.local_to_map(get_global_mouse_position())
	
func reset_overlay() -> void:
	for tile in overlay.get_used_cells():
		overlay.erase_cell(tile)

func draw_selection() -> void:
	reset_overlay()
	
	var tile_coords: Vector2i = get_mouse_grid_position()
	if tile_coords in ground.get_used_cells():
		overlay.set_cell(get_mouse_grid_position(), 0, Vector2i(1, 1))
"		if Game.current_selected_component:
			draw_overlay_component(Game.current_selected_component, get_mouse_grid_position())"
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		handle_placing()
	if Input.is_action_just_pressed("right"):
		erase()
func adjust_pos(pos: Vector2i) -> Vector2i:
	if pos.x % 2 == 0:
		return pos - Vector2i(0, 0)
	return pos - Vector2i(0, 0)
func desert() -> void:
	check_grass_surrounded_by_sand()

func is_surrounded_by_sand(cell: Vector2i) -> bool:
	var directions2 = [
		Vector2i(1, -1), # Up
		Vector2i(1, 1),  # Down
		Vector2i(-1, 0), # Left
		Vector2i(0, -1)   # Right
	]
	var directions = [
		Vector2i(0, -1), # Up
		Vector2i(0, 1),  # Down
		Vector2i(-1, 0), # Left
		Vector2i(1, 0)   # Right
	]
	if cell.x % 2 == 0:
		for dir in directions2:
			var neighbor = cell + dir
			if ground.get_cell_atlas_coords(neighbor) in sand: 
				if randi_range(1,6) == 1:
					return true
	else:
		for dir in directions:
			var neighbor = cell + dir
			if ground.get_cell_atlas_coords(neighbor) in sand: 
				if randi_range(1,6) == 1:
					return true
	return false

func check_grass_surrounded_by_sand() -> void:
	for cell in ground.get_used_cells():
		if ground.get_cell_atlas_coords(cell) == Vector2i(0,0):
			if is_surrounded_by_sand(cell):
				ground.set_cell(cell, 0, Vector2i(0,2))
					

func cornball(cell: Vector2i, r) -> bool:
	if (cell.x*2)**2 + cell.y**2 < r**2+32:
		return true
	return false
	
