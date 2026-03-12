extend sprite2D


func worldswap():
	var truth: bool = false
	
	
	if Input.is_action_pressed("ui_left"):
		truth = true
		
	if Input.is_action_pressed("ui_right"):
		truth = false
	
	visible = truth
