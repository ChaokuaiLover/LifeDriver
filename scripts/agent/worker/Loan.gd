extends State
class_name WorkerLoan
@export var worker: Node2D

func Enter():
	var need_money = int(float(worker.food_need) * float(worker.food_price) * 1.1)
	worker.money += need_money
	worker.debt += int(need_money * float(1 + worker.interest_rates))
	
func Update(_delta: float):
	if worker.money >= worker.food_need * worker.food_price:
		Transitioned.emit(self, "Rest")
