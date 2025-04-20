class_name Building
extends Resource

@export var texture: Texture2D
@export var name: String
@export var sprites: Array[Vector2i]

var position: Vector2i
var sprite: Vector2i

func get_sprite() -> Vector2i:
	if not sprite:
		sprite = sprites.pick_random()
	return sprite
