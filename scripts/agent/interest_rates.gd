extends Label


func _process(_delta: float):
	var interest_rate : float = Data.InterestratesStart
	self.text = str(interest_rate," %")
	
