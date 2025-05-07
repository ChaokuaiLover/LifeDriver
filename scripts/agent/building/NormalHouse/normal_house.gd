extends Sprite2D
class_name NormalHouse
var house_owner: Node2D
var food_reserve_limit: int = 300
var food_reserve: int = 0
var wood_reserve_limit: int = 1000
var wood_reserve: int
var need_energy
var goods_produce_multiplier: Dictionary
func wood_consume(delta):
	wood_reserve -= 2 * delta
func _ready():
	$Area2D.body_entered.connect(func first_time(body: Node2D):
		if body.status == "BuyHouse" and body.current_target == self and house_owner == null:
			self.remove_from_group("House")
			body.inside_house = true
			goods_produce_multiplier = body.goods_produce_multiplier
			house_owner = body
			body.house = self
		)
	
	$Area2D.body_entered.connect(func enterhouse(body: Node2D):
		if body.status == "GoToHouse" and body.current_target == self and body == house_owner:
			body.inside_house = true
			body.visible = false
			body.work_state = "idle"
			body.buy_food_state = "idle"
		)
		
	$Area2D.body_exited.connect(func exit_house(body: Node2D):
		if body == house_owner:
			body.inside_house = false
			body.visible = true
		)
		
func _process(_delta: float):
	if house_owner != null:
		if house_owner.money < house_owner.food_price * house_owner.food_need and food_reserve < 100 - house_owner.energy:
			$"%SadFace".visible = true
		else:
			$"%SadFace".visible = false
			
		if house_owner.retire:
			%HappyFace.visible = true
		elif !house_owner.retire:
			%HappyFace.visible = false
	else:
		%HappyFace.visible = false
		$"%SadFace".visible = false
		goods_produce_multiplier = {}
		add_to_group("House")
		food_reserve = 0
		
	
