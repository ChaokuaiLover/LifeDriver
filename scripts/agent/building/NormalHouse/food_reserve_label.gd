extends Label
@export var unit: Node2D

func _process(_delta: float) -> void:
	
	self.text = str(round(unit.food_reserve))
