extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -430.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const DASH_SPEED = 750
var dashing = false

var can_dash = true
@onready var dash_again_time: Timer = $"timers/dash again time"
@onready var dash_time: Timer = $"timers/dash time"



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		dash_time.start()
		can_dash = false
		dash_again_time.start()
		animated_sprite_2d.play("dash")
	
	var direction := Input.get_axis("move left", "move right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if direction == 0 and dashing == false: 
			animated_sprite_2d.play("idle")
		elif direction!= 0 and dashing == false:
			animated_sprite_2d.play("run")
	elif dashing == false:
		animated_sprite_2d.play("jump")
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_dash_time_timeout() -> void:
	dashing = false
	dash_time.stop()


func _on_dash_again_time_timeout() -> void:
	can_dash = true
	dash_again_time.stop()
