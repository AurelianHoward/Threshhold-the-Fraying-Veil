class_name JumpComponent
extends Node


@export_subgroup("settings")
@export var Jump_velocity: float = -350

var is_jumping: bool = false

func handle_jump(body: CharacterBody2D, want_to_jump: bool) -> void:
	if want_to_jump and body.is_on_floor():
		body.velocity.y = Jump_velocity
		
	is_jumping = body.velocity.y < 0 and not body.is_on_floor()
