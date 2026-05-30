extends Node2D

@onready var camera: Camera2D = $"."
@export var player: CharacterBody2D = get_parent()
@onready var camera_target : Node2D = player.get_node("CameraTarget")


@export var base_zoom: Vector2 = Vector2(0.95, 0.95)
@export var zoom_speed: float = 2.0
@export var offset_base: Vector2 = Vector2(0, -50)
@export var transition_speed: float = 5.0

var target_limits: Dictionary = {}
var is_transitioning: bool = false

func _ready() -> void:
	camera.zoom = base_zoom
	camera.offset = offset_base
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0

func _physics_process(delta: float) -> void:

	global_position = camera_target.global_position


	if is_transitioning:
		_update_camera_limits(delta)

	
	var target_zoom = base_zoom
	if player.velocity.length() > 400:
		target_zoom = base_zoom * 0.9
	camera.zoom = camera.zoom.lerp(target_zoom, zoom_speed * delta)

func _update_camera_limits(delta: float) -> void:
	camera.limit_left = lerp(camera.limit_left, float(target_limits["left"]), transition_speed * delta)
	camera.limit_right = lerp(camera.limit_right, float(target_limits["right"]), transition_speed * delta)
	camera.limit_top = lerp(camera.limit_top, float(target_limits["top"]), transition_speed * delta)
	camera.limit_bottom = lerp(camera.limit_bottom, float(target_limits["bottom"]), transition_speed * delta)
	
	if abs(camera.limit_left - target_limits["left"]) < 1.0:
		is_transitioning = false

func set_room_limits(left: float, right: float, top: float, bottom: float) -> void:
	target_limits = {
		"left": left,
		"right": right,
		"top": top,
		"bottom": bottom
	}
	is_transitioning = true
