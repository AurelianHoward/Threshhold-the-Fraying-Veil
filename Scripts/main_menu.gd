extends PanelContainer

const Game = preload("res://Scene/Level1.tscn")



func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(Game)



func _on_quit_button_pressed() -> void:
	pass # Replace with function body.
