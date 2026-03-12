extends Sprite2D

func _process(delta: float):
	var truth: bool = visible
	
	if Input.is_action_just_pressed("testing"):
		if truth ==true:
			truth = false
		else:if truth == false:
			truth = true
	visible = truth
