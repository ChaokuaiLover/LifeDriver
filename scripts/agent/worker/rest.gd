extends State
class_name WorkerRest
@export var worker: Node2D
var target
var is_need_to_buy_food: bool
var is_able_to_buy_food: bool
var need_energy
var rest_time_start: float = 3.0
var rest_time: float

func Enter():
	worker.velocity = Vector2(0,0) * 0
	rest_time = rest_time_start
	worker.energy_drain_index = 1.0

func  Exit():
	worker.energy_drain_index = 1.0
	
func Update(delta: float):
	rest_time -= delta
	need_energy = int(100.0 - worker.energy)
	if worker.house.food_reserve > 0 and need_energy >= 5:
		worker.energy += min(need_energy,worker.house.food_reserve)
		worker.house.food_reserve -= min(need_energy,worker.house.food_reserve)
		
	if rest_time <= 0:
		worker.mood = "fresh"
		rest_time = rest_time_start
	if worker.food_market:
		is_able_to_buy_food = worker.food_market.sell_status and worker.money >= worker.food_price * worker.food_limit
		is_need_to_buy_food = worker.house.food_reserve < worker.house.food_reserve_limit
		
	if is_need_to_buy_food and is_able_to_buy_food and worker.mood == "fresh":
		Transitioned.emit(self, "BuyFood")
		
	elif is_need_to_buy_food and true and worker.debt <= 30 * worker.average_income and not worker.retire and worker.money < worker.food_price * worker.food_need and worker.mood == "fresh":
		Transitioned.emit(self, "Loan")
		
	elif worker.energy > 60 and !worker.retire and worker.mood == "fresh":
		Transitioned.emit(self, "Work")
