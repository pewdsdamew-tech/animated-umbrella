extends "res://Machine.gd"

@onready var input_area: Area2D = $InputArea


func _ready() -> void:
	input_area.body_entered.connect(_on_input_area_body_entered)


func _on_input_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("ore"):
		return
	if body.has_method("apply_multiplier"):
		MoneyManager.add_money(body.value)
	body.queue_free()
