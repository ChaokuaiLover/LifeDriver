extends Label
@export var unit: Node2D

func _process(_delta: float) -> void:
	if unit.house_owner != null:
		self.text = str(unit.house_owner.goods_produce_multiplier['food']," ",unit.house_owner.goods_produce_multiplier['wood'])
	else:
		self.text = str("")
