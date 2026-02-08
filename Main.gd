extends Node2D

@export var grid_size: int = 32

@onready var world: Node2D = $World
@onready var panel: Panel = $UI/Panel
@onready var money_label: Label = $UI/Panel/VBoxContainer/MoneyLabel

var placement_scene: PackedScene
var grid_map: Dictionary = {}

var dropper_scene: PackedScene = preload("res://Dropper.tscn")
var conveyor_scene: PackedScene = preload("res://Conveyor.tscn")
var furnace_scene: PackedScene = preload("res://Furnace.tscn")


func _ready() -> void:
	_update_money_label()


func _process(_delta: float) -> void:
	_update_money_label()


func _unhandled_input(event: InputEvent) -> void:
	if placement_scene == null:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos := event.position
		if panel.get_global_rect().has_point(mouse_pos):
			return
		_place_at(mouse_pos)


func _place_at(position: Vector2) -> void:
	var cell := Vector2i(int(position.x / grid_size), int(position.y / grid_size))
	if grid_map.has(cell):
		return
	var instance := placement_scene.instantiate()
	instance.position = Vector2(cell.x * grid_size + grid_size * 0.5, cell.y * grid_size + grid_size * 0.5)
	world.add_child(instance)
	grid_map[cell] = instance
	_refresh_links()


func _refresh_links() -> void:
	for cell in grid_map.keys():
		var node := grid_map[cell]
		if not node.has_variable("next_machine"):
			continue
		var next_cell := cell + Vector2i(1, 0)
		if grid_map.has(next_cell):
			var next_node := grid_map[next_cell]
			node.next_machine = node.get_path_to(next_node)
		else:
			node.next_machine = NodePath()


func _update_money_label() -> void:
	money_label.text = "Money: %d" % MoneyManager.money


func _on_select_dropper_pressed() -> void:
	placement_scene = dropper_scene


func _on_select_conveyor_pressed() -> void:
	placement_scene = conveyor_scene


func _on_select_furnace_pressed() -> void:
	placement_scene = furnace_scene


func _on_select_clear_pressed() -> void:
	placement_scene = null

