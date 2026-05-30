extends StaticBody2D



func _process(delta: float):
	var truth: bool = visible
	
	
	if Input.is_action_just_pressed("Worldhop"):
		if truth == true:
			$CollisionShape2D.set_disabled(true)
			truth = false
		else:if truth == false:
			$CollisionShape2D.set_disabled(false)
			visible = true
			truth = true
	visible = truth
