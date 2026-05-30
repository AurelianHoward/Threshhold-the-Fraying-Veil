extends Node2D


func _process(delta: float):
	var truth: bool = visible
	
	
	if Input.is_action_just_pressed("Worldhop"):
		if truth == true:
			truth = false
		else:if truth == false:
			visible = true
			truth = true
	visible = truth
