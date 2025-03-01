extends Label
@export var unit: Node2D

func _process(_delta: float) -> void:
	if unit.house_owner != null:
		self.text = str(unit.house_owner.name)
	else:
		self.text = str("empty")
