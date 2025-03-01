extends Sprite2D
class_name Bank

var money: int = 1000000
var debt: int = 0
var asset
var interest_rates = Data.InterestratesStart / 100 + 1
var debt_calculate_cycle_start: float = Data.DebtCalculateCycleStart
var debt_calculate_cycle: float

func _ready():
	debt_calculate_cycle = debt_calculate_cycle_start
	$Area2D.body_entered.connect(func(body: Node2D):
		if body.mood == "Loan" and money >= body.loan_rate:
			var loan_rate = body.loan_rate
			money -= loan_rate
			body.money += loan_rate
			body.debt_list[name] = loan_rate
			body.debt += loan_rate
			)
			
	
func _process(delta: float):
	debt_calculate_cycle -= delta
	if debt > 0 and interest_rates > 0 and debt_calculate_cycle <= 0:
		debt_calculate_cycle += debt_calculate_cycle_start
		debt = Function.debt_compounding(debt,interest_rates)
		
	

func _physics_process(_delta):
	pass
