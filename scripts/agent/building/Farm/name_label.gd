extends Label
@export var unit: Node2D

func _ready():
	
	self.text = str(unit.name)
