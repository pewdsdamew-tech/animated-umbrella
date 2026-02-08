extends "res://scripts/Machine.gd"

@export var speed: float = 100.0
@export var sprite_path: String = ""

@onready var input_area: Area2D = $InputArea
@onready var output_point: Marker2D = $OutputPoint
@onready var sprite: Sprite2D = $Sprite2D

var active_ores: Array[Ore] = []


func _ready() -> void:
	if sprite_path != "" and ResourceLoader.exists(sprite_path):
		sprite.texture = load(sprite_path)
	input_area.body_entered.connect(_on_input_area_body_entered)


func _physics_process(delta: float) -> void:
	for ore in active_ores.duplicate():
		if not is_instance_valid(ore):
			active_ores.erase(ore)
			continue
		var target: Vector2 = ore.target_position
		ore.global_position = ore.global_position.move_toward(target, speed * delta)
		if ore.global_position.distance_to(target) <= 1.0:
			active_ores.erase(ore)
			forward_ore(ore)


func _on_input_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("ore"):
		return
	var ore := body as Ore
	if ore == null:
		return
	ore.set_target_position(output_point.global_position)
	if not active_ores.has(ore):
		active_ores.append(ore)
