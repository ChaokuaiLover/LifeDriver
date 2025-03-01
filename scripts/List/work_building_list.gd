extends Node

var all_work_building_node: Array
var work_bilding_position: Array

func _ready() -> void:
	all_work_building_node = get_tree().get_nodes_in_group("WorkBuildingList")
	


func _process(delta: float) -> void:
	pass
