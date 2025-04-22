extends Node2D
@onready var grid_map = $GridMap
@onready var bubble = $Sprite2D
@onready var resources: Control = $CanvasLayer/Screen/Resources
@onready var wind2 = $CanvasLayer/Screen/wind
@onready var wind_particles = $CanvasLayer/CPUParticles2D

var energy: int
var food: int
var culture: int
var knowledge: int
var wind_orientation: float = 0
var dir_noise: FastNoiseLite
var turn: int = 0
var wind = Vector2i(0,0)

func _on_next_turn_button_pressed() -> void:
	load_next_turn()


func load_next_turn() -> void:
	dir_noise = FastNoiseLite.new()
	dir_noise.seed = randi_range(0, 1000)
	dir_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	turn += 1
	update_wind()
	grid_map.desert()
	for building in grid_map.buildings:
		energy += building.energy_production 
		energy -= building.energy_cost
		food += building.food_production
		food -= building.food_cost
		culture += building.culture_production
		knowledge += building.knowledge_production
	
	resources.load_resources(food, energy, culture, knowledge)

func update_wind() -> void:
	wind_orientation = (dir_noise.get_noise_1d(turn) +1) *10* PI
	wind = Vector2(cos(wind_orientation),sin(wind_orientation))
	wind2.set_wind_orientation(wind_orientation)
	
	wind_particles.visible = true
	wind_particles.direction = wind
	wind_particles.speed_scale = randi_range(1,5)
	wind_particles.scale_amount_min = randi_range(0.6,1)
	wind_particles.scale_amount_max = randi_range(1,1.5)
	wind_particles.explosiveness = randi_range(0,0.4)
	wind_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	wind_particles.emission_rect_extents = Vector2(1152, 648) # Adjust to screen size
