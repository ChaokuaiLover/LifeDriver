extends Label
var time: float = 0
var minute: int = 0
var second:int = 0
var hour:int = 0
var day:int = 0

func _process(delta: float) -> void:
	time += delta
	second = int(time)
	minute = int(time/60)
	hour = int(time/3600)
	day = int(time/86400)
	second -= 60 * minute
	minute -= 60 * hour
	hour -= 24 * day
	
	if time < 60:
		self.text = str(int(time),"s")
		
	elif time > 60 and time < 3600:
		self.text = str(minute,"m ",second,"s")
		
	elif time > 3600 and time <  86400:
		self.text = str(hour,"h ",minute,"m ",second,"s")
		
	elif time > 86400:
		self.text = str(day,"d ",hour,"h ",minute,"m ",second,"s")
		
