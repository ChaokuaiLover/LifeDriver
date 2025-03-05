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
	if worker.house.food_reserve >= need_energy and need_energy >= 5:
		worker.energy += need_energy
		worker.house.food_reserve -= need_energy
		
	if rest_time <= 0:
		worker.mood = "fresh"
		rest_time = rest_time_start
	if worker.buy_target:
		is_able_to_buy_food = worker.buy_target.sell_status and worker.money >= worker.food_price * worker.food_need
		is_need_to_buy_food = worker.house.food_reserve < worker.house.food_reserve_limit * 0.8
		
	if is_need_to_buy_food and is_able_to_buy_food and worker.mood == "fresh":
		Transitioned.emit(self, "BuyFood")
		
	elif is_need_to_buy_food and false and worker.money < worker.food_price * worker.food_need and worker.debt < 60.0 * worker.average_income and worker.mood == "fresh":
		Transitioned.emit(self, "Loan")
		
	elif worker.energy > 70 and !worker.retire and worker.mood == "fresh":
		Transitioned.emit(self, "Work")
		
