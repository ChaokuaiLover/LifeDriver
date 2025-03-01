extends State
class_name FarmPricing
@export var farm: Node2D
var data_calculate_cycle: float
var is_profitable: bool
func _adjust_wage(plan):
	farm.wage_change = (float(farm.wage_offer) * (1.0 - farm.margin)) / float(farm.wage_offer) * plan
	farm.wage_offer += roundi(float(farm.wage_offer) * (1.0 - farm.margin)) * plan
	farm.wage_plan = plan
	
func Enter():
	data_calculate_cycle = farm.data_calculate_cycle_start
	farm.wage_plan = 1

func Update(delta: float):
	data_calculate_cycle -= delta
	if  farm.production_growth_statement.size() >= 2 and data_calculate_cycle <= 0 :
		is_profitable = round(farm.sell_target.price_offer * 4.0) > round(farm.wage_offer * 1.05)
		if farm.production_statement[0] == 0 and is_profitable:
			_adjust_wage(1)
			
		elif farm.production_growth_statement[0] <= farm.wage_change:
			if farm.wage_plan == 1:
				_adjust_wage(-1)
			elif farm.wage_plan == -1 and is_profitable:
				_adjust_wage(1)
				
		elif farm.production_growth_statement[0] > farm.wage_change:
			if farm.wage_plan == -1:
				_adjust_wage(-1)
			elif farm.wage_plan == 1 and is_profitable:
				_adjust_wage(1)
				
		data_calculate_cycle = farm.data_calculate_cycle_start
func Physics_Update(_delta: float):
	pass
