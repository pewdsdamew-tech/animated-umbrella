extends "res://scripts/Machine.gd"

@export var ore_type: String = "Iron"
@export var base_value: int = 1
@export var spawn_interval: float = 1.0
@export var sprite_path: String = ""

@onready var spawn_point: Marker2D = $SpawnPoint
@onready var timer: Timer = $Timer
@onready var sprite: Sprite2D = $Sprite2D

var ore_scene: PackedScene = preload("res://scenes/Ore.tscn")


func _ready() -> void:
	if sprite_path != "" and ResourceLoader.exists(sprite_path):
		sprite.texture = load(sprite_path)
	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _on_timer_timeout() -> void:
	var ore := ore_scene.instantiate() as Ore
	if ore == null:
		return
	ore.ore_type = ore_type
	ore.base_value = base_value
	ore.value = base_value
	ore.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(ore)
	if next_machine != NodePath():
		var machine := get_node_or_null(next_machine)
		if machine and machine.has_method("get_input_position"):
			ore.set_target_position(machine.get_input_position())
