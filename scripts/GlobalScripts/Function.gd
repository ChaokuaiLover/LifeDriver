extends Node

func _find_median(array):
	var target_array = array.duplicate(true)
	var num = target_array.size()
	target_array.sort()
	var median_value
	if num % 2 == 0:
		median_value = target_array[int(num / 2)] + target_array[int(num / 2) + 1] / 2
	else:
		median_value =  target_array[int(num / 2)]
	return median_value

func debt_compounding(current_debt,current_interest_rates):
	current_debt = float(current_debt) * float(current_interest_rates + 1.0)
	return int(round(current_debt))
	
func produce_food(unit,worker,wage,multiplier):
	unit.money -= multiplier * wage
	worker.money += multiplier * wage
	unit.food_stock += roundi((float(multiplier) * 2.0))
	worker.energy -= float(multiplier)
	
func profit_calculation(income,expense):
	var profit: float
	if expense > 0:
		#profit = income - expense
		profit = float(income - expense) / float(expense) * 100
		profit = snapped(profit,0.01)
	return profit
	
func data_growth_calculation(data_statement):
	var data_growth: float
	if data_statement[1] > 0:
		data_growth = float(data_statement[0] - float(data_statement[1])) / float(data_statement[1]) * 100
		data_growth = snapped(data_growth,0.01)
	return data_growth
		
		
func find_best_length_target_buy(unit,target_array):
	var direction
	var all_target_and_length: Dictionary = {}
	var all_target_length:Array = []
	var best_length_target
	
	for target in target_array:
		direction = target.global_position - unit.global_position
		all_target_and_length[target] = direction.length()
		all_target_length.push_back(direction.length())
	best_length_target = all_target_and_length.find_key(all_target_length.min())
	
	return best_length_target
	

func find_best_price_target_buy(target_array):
	var all_target_and_price: Dictionary = {}
	var all_target_price: Array = []
	var best_price_target: Node2D
	
	for target in target_array:
		all_target_price.push_back(target.price)
		all_target_and_price[target] = target.price
	best_price_target = all_target_and_price.find_key(all_target_price.min())
	
	return best_price_target
	

func find_best_target_buy(unit,target_array,speed,time_value):
	var all_target_price_and_time_value: Dictionary = {}
	var all_value_sum: Array = []
	var value_sum: float
	var direction: Vector2
	var best_target: Node2D
	
	for target in target_array:
		if target != null:
			if target.sell_status == true and unit != null:
				all_target_price_and_time_value[target] = target.price
				direction = target.global_position - unit.global_position
				value_sum =  float(target.price_offer) + ((float(direction.length()) / float(speed)) * float(time_value + 1.0))
				all_value_sum.push_back(value_sum)
				all_target_price_and_time_value[target] = value_sum
	best_target = all_target_price_and_time_value.find_key(all_value_sum.min())
	return best_target
	

func find_best_target_work(unit,target_array,speed,time_value):
	var all_target_price_and_time_value: Dictionary = {}
	var all_value_sum: Array = []
	var value_sum: float
	var direction: Vector2
	var best_target: Node2D
	
	for target in target_array:
		if unit != null and target != null:
			if target.wage_offer > 0 and target.hire_status:
				all_target_price_and_time_value[target] = target.wage_offer
				direction = target.global_position - unit.global_position
				value_sum = float(target.wage_offer * target.food_multiplier) - (float(direction.length()) / float(speed)) * float(time_value + 1.0)
				all_value_sum.push_back(value_sum)
				all_target_price_and_time_value[target] = value_sum
	best_target = all_target_price_and_time_value.find_key(all_value_sum.max())
	return best_target

func find_best_target_sell(unit,target_array,speed,time_value):
	var all_target_price_and_time_value: Dictionary = {}
	var all_value_sum: Array = []
	var value_sum: float
	var direction: Vector2
	var best_target: Node2D
	
	for target in target_array:
		if unit != null and target != null:
			if target.price_offer > 0:
				all_target_price_and_time_value[target] = target.price_offer
				direction = target.global_position - unit.global_position
				value_sum = float(target.price_offer) - (float(direction.length()) / float(speed)) * float(time_value + 1.0)
				all_value_sum.push_back(value_sum)
				all_target_price_and_time_value[target] = value_sum
	best_target = all_target_price_and_time_value.find_key(all_value_sum.max())
	return best_target
