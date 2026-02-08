extends "res://Machine.gd"

@export var sprite_texture: Texture2D

@onready var input_area: Area2D = $InputArea
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	if sprite_texture:
		sprite.texture = sprite_texture
	input_area.body_entered.connect(_on_input_area_body_entered)


func _on_input_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("ore"):
		return
	var ore := body as Ore
	if ore == null:
		return
	MoneyManager.add_money(ore.value)
	ore.queue_free()
