class_name Ore
extends CharacterBody2D

@export var ore_type: String = "Iron"
@export var base_value: int = 1
@export var value: int = 1
@export var tags: Array[String] = []
@export var sprite_path: String = ""

var target_position: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	add_to_group("ore")
	value = base_value
	if sprite_path != "" and ResourceLoader.exists(sprite_path):
		sprite.texture = load(sprite_path)


func apply_multiplier(mult: float) -> void:
	value = int(value * mult)


func reset() -> void:
	value = base_value
	tags.clear()


func set_target_position(target: Vector2) -> void:
	target_position = target
