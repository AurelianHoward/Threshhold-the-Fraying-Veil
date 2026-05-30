extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	JUMP_RISE,
	JUMP_FALL,
	DASH,
	WALL_SLIDE,
	WALL_JUMP
}


@onready var animated_sprite: AnimatedSprite2D = $Sprite

@export_category("Movement")
@export var move_speed: float = 400.0
@export var jump_velocity: float = -700.0
@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.6
@export var wall_slide_speed: float = 100.0
@export var wall_jump_velocity: Vector2 = Vector2(500.0, -500.0)
@export var gravity: float = 2000.0


@export_category("Jump And Walls")
@export var wall_coyote_time: float = 0.15  
@export var jump_buffer_time: float = 0.15 
@export var short_hop_multiplier: float = 0.5 
@export var coyote_time: float = 0.1 

var wall_coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var coyote_timer: float = 0.0


var current_state: State = State.IDLE
var is_dashing: bool = false
var dash_timer: float = 0.0
var is_wall_sliding: bool = false
var facing_direction: float = 1.0

func _ready() -> void:
	animated_sprite.animation_finished.connect(_on_animation_finished)
	animated_sprite.play("Idle") 

func _physics_process(delta: float) -> void:
	if is_on_wall() and not is_on_floor():
		wall_coyote_timer = wall_coyote_time
	else:
		wall_coyote_timer = max(wall_coyote_timer - delta, 0.0)
	
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer = max(coyote_timer - delta, 0)
		
	if Input.is_action_just_pressed("Mjump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer = max(jump_buffer_timer - delta, 0)

	if not is_on_floor() and not is_wall_sliding:
		velocity.y += gravity * delta

	if is_dashing:
		_handle_dash(delta)
	else:
		_handle_movement()
		_handle_jump()
		_handle_dash_input()
		_handle_wall_slide()
		_handle_wall_jump()

	move_and_slide()

	_update_state()

	_update_animation()

	_flip_sprite()

func _handle_movement() -> void:
	var input_direction: Vector2 = Input.get_vector("Mleft","Mright", "Mup", "Mdown")
	velocity.x = input_direction.x * move_speed

func _handle_jump() -> void:
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0
		coyote_timer = 0

func _handle_dash_input() -> void:
	if Input.is_action_just_pressed("Mdash") and not is_dashing:
		is_dashing = true
		dash_timer = dash_duration
		velocity.x = facing_direction * dash_speed
		velocity.y = 0

func _handle_dash(delta: float) -> void:
	dash_timer -= delta
	if dash_timer <= 0:
		is_dashing = false
		velocity.x = 0

func _handle_wall_slide() -> void:
	is_wall_sliding = false
	if is_on_wall() and not is_on_floor() and velocity.y > 0:
		is_wall_sliding = true
		velocity.y = min(velocity.y, wall_slide_speed)

func _handle_wall_jump() -> void:
	if jump_buffer_timer > 0.0 and wall_coyote_timer > 0.0:
		var wall_normal = get_wall_normal()

		if wall_normal == Vector2.ZERO:
			wall_normal.x = -facing_direction

		velocity.x = wall_jump_velocity.x * wall_normal.x
		velocity.y = wall_jump_velocity.y

		facing_direction = sign(velocity.x)

		jump_buffer_timer = 0.0
		wall_coyote_timer = 0.0
		is_wall_sliding = false


func _update_state() -> void:
	if is_dashing:
		current_state = State.DASH
	elif is_wall_sliding:
		current_state = State.WALL_SLIDE
	elif is_on_wall() and velocity.y < 0: 
		current_state = State.WALL_JUMP
	elif not is_on_floor():
		if velocity.y < 0:
			current_state = State.JUMP_RISE
		else:
			current_state = State.JUMP_FALL
	else:
		if abs(velocity.x) > 0:
			current_state = State.RUN
		else:
			current_state = State.IDLE

func _update_animation() -> void:
	match current_state:
		State.IDLE:
			if animated_sprite.animation != "Idle":
				animated_sprite.play("Idle")
		State.RUN:
			if animated_sprite.animation != "Run":
				animated_sprite.play("Run")
		State.JUMP_RISE:
			if animated_sprite.animation != "Jump":
				animated_sprite.play("Jump")
		State.JUMP_FALL:
			if animated_sprite.animation != "Fall":
				animated_sprite.play("Fall")
		State.DASH:
			if animated_sprite.animation != "Dash":
				animated_sprite.play("Dash")
func respawn():
	self.global_position = Vector2(-3460.0, 1592.0)

func _flip_sprite() -> void:
	if velocity.x >= 1:
		animated_sprite.flip_h = false
	else: if velocity.x <= -1:
		animated_sprite.flip_h = true


func _on_animation_finished() -> void:
	match current_state:
		State.DASH:
			_update_state()  
