extends "res://Machine.gd"

@export var multiplier: float = 2.0

@onready var input_area: Area2D = $InputArea
@onready var output_point: Marker2D = $OutputPoint


func _ready() -> void:
	input_area.body_entered.connect(_on_input_area_body_entered)


func _on_input_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("ore"):
		return
	if body.has_method("apply_multiplier"):
		body.apply_multiplier(multiplier)
	forward_ore(body)

