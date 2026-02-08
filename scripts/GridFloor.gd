extends Node2D

@export var grid_size: int = 32
@export var floor_color: Color = Color(0.22, 0.22, 0.22)
@export var line_color: Color = Color(0.15, 0.15, 0.15)


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	var size := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, size), floor_color)
	for x in range(0, int(size.x) + 1, grid_size):
		draw_line(Vector2(x, 0), Vector2(x, size.y), line_color)
	for y in range(0, int(size.y) + 1, grid_size):
		draw_line(Vector2(0, y), Vector2(size.x, y), line_color)

