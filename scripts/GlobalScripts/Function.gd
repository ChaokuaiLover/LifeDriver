extends Node

func _find_median(array):
	var target_array = array.duplicate(true)
	var num = target_array.size()
	target_array.sort()
	var median_value
	if num % 2 == 0:
		median_value = (target_array[int(num / 2)] + target_array[int(num / 2) + 1]) / 2
	else:
		median_value =  target_array[int(num / 2)]
	return median_value
	

func debt_compounding(current_debt,current_interest_rates):
	current_debt = float(current_debt) * float(current_interest_rates + 1.0)
	return int(round(current_debt))
	
	

func produce_goods(unit,worker,wage,amount,multiplier):
	unit.money -= int(float(amount * wage) * multiplier)
	worker.money += int(float(amount * wage) * multiplier)
	unit.goods_stock += floor((float(amount) * multiplier))
	worker.energy -= float(amount)
	

func profit_calculation(income,expense):
	var profit_rate: float
	if expense > 0:
		#profit = income - expense
		profit_rate = float(income - expense) / float(expense) * 100
		profit_rate = snapped(profit_rate,0.01)
	return profit_rate
	

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
	var class_goods: Dictionary = {'Farm': 'food','LumberMill': 'wood'}
	for target in target_array:
		if unit != null and target != null:
			if target.wage_offer > 0 and target.hire_status:
				direction = target.global_position - unit.global_position
				value_sum = float(float(target.wage_offer * target.goods_produce_amount * float(unit.goods_produce_multiplier[class_goods[target._get_class_name()]]))) - float(float(direction.length()) / float(speed)) * float(time_value + 1.0)
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


func _financial(agent,income,profit,expense,sales,production):
	if profit == 1:
		agent.profit = Function.profit_calculation(agent.income,agent.expense)
		agent.profit_statement.push_front(agent.profit)
		agent.profit_statement.resize(5)

	if income == 1:
		agent.income_statement.push_front(agent.income)
		agent.income_growth_statement.push_front(Function.data_growth_calculation(agent.income_statement))
		agent.income_statement.resize(5)
		agent.income_growth_statement.resize(5)
		agent.income = 0
		
	if expense == 1:
		agent.expenditure_statement.push_front(agent.expense)
		agent.expenditure_growth_statement.push_front(Function.data_growth_calculation(agent.expenditure_statement))
		agent.expenditure_statement.resize(5)
		agent.expenditure_growth_statement.resize(5)
		agent.expense = 0
		
	if sales == 1:
		agent.sales_statement.push_front(agent.sales)
		agent.sales_statement.resize(5)
		agent.sales = 0
	
	if production == 1:
		agent.production_statement.push_front(agent.production)
		agent.production_growth_statement.push_front(Function.data_growth_calculation(agent.production_statement))
		agent.production_statement.resize(5)
		agent.production_growth_statement.resize(5)
		agent.production = 0
	
