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
	if next_machine == NodePath():
		return
	var machine := get_node_or_null(next_machine)
	var conveyor := machine as Conveyor
	if conveyor == null:
		return
	if not conveyor.can_accept_ore():
		return
	var ore := ore_scene.instantiate() as Ore
	if ore == null:
		return
	ore.ore_type = ore_type
	ore.base_value = base_value
	ore.value = base_value
	var input_position := conveyor.get_input_position()
	ore.global_position = input_position
	get_tree().current_scene.add_child(ore)
	conveyor.receive_ore(ore)
