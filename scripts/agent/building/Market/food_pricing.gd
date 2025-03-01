extends State
class_name MarketPricing
@export var market: Node2D
var data_calculate_cycle: float

func _adjust_price(change,price,plan):
	market.price_change = change * plan
	market.price += price * plan
	market.price_plan = plan
	
func Enter():
	data_calculate_cycle = market.data_calculate_cycle_start
	market.price_plan = 1

func Update(delta: float):
	data_calculate_cycle -= delta
	if  market.income_growth_statement.size() >= 2 and data_calculate_cycle <= 0 :
		if market.income_growth_statement[0] <= market.price_change:
			
			if market.price_plan == 1:
				_adjust_price(float((market.price)/10.0 + 0.5) / float(market.price),int(float((market.price)/33.3333) + 0.5),-1)
			elif market.price_plan == -1:
				_adjust_price(float((market.price)/10.0 + 0.5) / float(market.price),int(float((market.price)/33.3333) + 0.5),1)
				
		elif market.income_growth_statement[0] > market.price_change:
			
			if market.price_plan == -1:
				_adjust_price(float((market.price)/10.0 + 0.5) / float(market.price),int(float((market.price)/33.3333) + 0.5),-1)
			elif market.price_plan == 1:
				_adjust_price(float((market.price)/10.0 + 0.5) / float(market.price),int(float((market.price)/33.3333) + 0.5),1)
		market.price_offer = int(float(market.price) * (2.0 - market.margin))
		data_calculate_cycle = market.data_calculate_cycle_start
		
		
func Physics_Update(_delta: float):
	pass
