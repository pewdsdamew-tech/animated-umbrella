extends Node2D

@export var grid_size: int = 32

@onready var world: Node2D = $World
@onready var panel: Panel = $UI/Panel
@onready var placement_ghost: PlacementGhost = $World/PlacementGhost
@onready var money_label: Label = $UI/Panel/VBoxContainer/MoneyLabel

var placement_scene: PackedScene
var grid_map: Dictionary = {}
var ghost_scene: PackedScene

var dropper_scene: PackedScene = preload("res://scenes/Dropper.tscn")
var conveyor_scene: PackedScene = preload("res://scenes/Conveyor.tscn")
var furnace_scene: PackedScene = preload("res://scenes/Furnace.tscn")


func _ready() -> void:
	_update_money_label()
	placement_ghost.set_grid_size(grid_size)
	_update_ghost_sprite()


func _process(_delta: float) -> void:
	_update_money_label()
	_update_ghost()


func _unhandled_input(event: InputEvent) -> void:
	if placement_scene == null:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos: Vector2 = event.position
		if panel.get_global_rect().has_point(mouse_pos):
			return
		_place_at(mouse_pos)


func _update_ghost() -> void:
	if placement_scene == null:
		placement_ghost.visible = false
		return
	var mouse_pos := get_viewport().get_mouse_position()
	if panel.get_global_rect().has_point(mouse_pos):
		placement_ghost.visible = false
		return
	var cell: Vector2i = Vector2i(int(mouse_pos.x / grid_size), int(mouse_pos.y / grid_size))
	var world_pos := Vector2(cell.x * grid_size + grid_size * 0.5, cell.y * grid_size + grid_size * 0.5)
	placement_ghost.position = world_pos
	var is_blocked := grid_map.has(cell)
	placement_ghost.set_blocked(is_blocked)
	if placement_ghost.visible == false:
		placement_ghost.visible = true


func _update_ghost_sprite() -> void:
	if placement_scene == null:
		placement_ghost.set_preview(null)
		return
	if ghost_scene == placement_scene:
		return
	ghost_scene = placement_scene
	var temp := placement_scene.instantiate()
	if temp == null:
		return
	var preview_texture: Texture2D = null
	if temp.has_method("get"):
		var path := temp.get("sprite_path")
		if path is String and path != "" and ResourceLoader.exists(path):
			preview_texture = load(path)
	placement_ghost.set_preview(preview_texture)
	temp.queue_free()


func _place_at(world_position: Vector2) -> void:
	var cell: Vector2i = Vector2i(int(world_position.x / grid_size), int(world_position.y / grid_size))
	if grid_map.has(cell):
		return
	var instance: Node2D = placement_scene.instantiate()
	instance.position = Vector2(cell.x * grid_size + grid_size * 0.5, cell.y * grid_size + grid_size * 0.5)
	world.add_child(instance)
	grid_map[cell] = instance
	_refresh_links()


func _refresh_links() -> void:
	for cell in grid_map.keys():
		var node: Node2D = grid_map[cell]
		if not (node is Machine):
			continue
		var next_cell: Vector2i = cell + Vector2i(1, 0)
		if grid_map.has(next_cell):
			var next_node: Node2D = grid_map[next_cell]
			(node as Machine).next_machine = node.get_path_to(next_node)
		else:
			(node as Machine).next_machine = NodePath()


func _update_money_label() -> void:
	money_label.text = "Money: %d" % MoneyManager.money


func _on_select_dropper_pressed() -> void:
	_set_placement_scene(dropper_scene)


func _on_select_conveyor_pressed() -> void:
	_set_placement_scene(conveyor_scene)


func _on_select_furnace_pressed() -> void:
	_set_placement_scene(furnace_scene)


func _on_select_clear_pressed() -> void:
	_set_placement_scene(null)


func _set_placement_scene(scene: PackedScene) -> void:
	placement_scene = scene
	ghost_scene = null
	_update_ghost_sprite()
