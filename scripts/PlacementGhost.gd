class_name PlacementGhost
extends Node2D

@export var grid_size: int = 32
@export var outline_color: Color = Color(1, 0, 0, 0.9)
@export var blocked_color: Color = Color(1, 0, 0, 0.9)
@export var preview_tint: Color = Color(1, 1, 1, 0.5)

@onready var sprite: Sprite2D = $Sprite2D

var is_blocked: bool = false


func set_preview(texture: Texture2D) -> void:
	sprite.texture = texture
	if texture:
		sprite.modulate = preview_tint


func set_blocked(blocked: bool) -> void:
	is_blocked = blocked
	queue_redraw()


func set_grid_size(size: int) -> void:
	grid_size = size
	queue_redraw()


func _draw() -> void:
	var half := grid_size * 0.5
	var rect := Rect2(Vector2(-half, -half), Vector2(grid_size, grid_size))
	draw_rect(rect, Color(0, 0, 0, 0), false, 2.0, is_blocked ? blocked_color : outline_color)
