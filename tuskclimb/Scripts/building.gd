class_name Building
extends Resource

@export var texture: Texture2D
@export var name: String
@export var sprites: Array[Vector2i]

@export var only_grass: bool

@export_category("Resources")
@export var energy_cost: int
@export var energy_production: int

@export var food_cost: int
@export var food_production: int

var position: Vector2i
var sprite: Vector2i

func get_sprite() -> Vector2i:
	if not sprite:
		sprite = sprites.pick_random()
	return sprite
