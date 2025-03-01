extends Label
@export var unit: CharacterBody2D

func _process(_delta: float) -> void:
	
	self.text = str(unit.debt)
