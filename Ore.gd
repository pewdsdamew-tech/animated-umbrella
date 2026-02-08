extends CharacterBody2D

@export var ore_type: String = "Iron"
@export var base_value: int = 1
@export var value: int = 1
@export var tags: Array[String] = []

var target_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	add_to_group("ore")
	value = base_value


func apply_multiplier(mult: float) -> void:
	value = int(value * mult)


func reset() -> void:
	value = base_value
	tags.clear()


func set_target_position(position: Vector2) -> void:
	target_position = position

