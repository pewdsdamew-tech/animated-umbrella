extends Node2D

@export var next_machine: NodePath


func get_input_position() -> Vector2:
	var input_area := get_node_or_null("InputArea")
	if input_area:
		return input_area.global_position
	return global_position


func forward_ore(ore: Node2D) -> void:
	if next_machine == NodePath():
		return
	var machine := get_node_or_null(next_machine)
	if machine == null:
		return
	if machine.has_method("get_input_position"):
		ore.global_position = machine.get_input_position()
		if ore.has_method("set_target_position"):
			ore.set_target_position(machine.get_input_position())

