extends Node2D

var radius := 32
var segments := 48
var color := Color(0.8, 0.6, 1.0)

func _ready():
	_draw()

func _draw():
	for i in segments:
		var angle = TAU * float(i) / segments
		var x = radius * cos(angle)
		var y = radius * sin(angle) * 0.5  # squash for iso

		var brightness = 0.7 + 0.3 * cos(angle)  # simulate lighting from top-left
		var shade = Color(color.r * brightness, color.g * brightness, color.b * brightness)

		draw_line(Vector2(0, 0), Vector2(x, y), shade, 2)
