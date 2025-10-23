extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var SPEED = 70.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# direction is -1,0 or 1
	var direction := Input.get_axis("move left", "move right")
	
	# LEMME TRY CREATING THE LEFT AND RIGHT FLIP
	if direction == 1:
		animated_sprite_2d.flip_h = false
	elif direction == -1:
		animated_sprite_2d.flip_h = true
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	# adding sprinting to the movement and animation
	const sprint = 130
	var sprintButton = Input.is_action_just_pressed("sprint")
	var normalSpeed = Input.is_action_just_released("sprint")
	
	if sprintButton:
		SPEED = sprint
		animated_sprite_2d.play("run")
	elif normalSpeed:
		SPEED = 70.0
		animated_sprite_2d.play("idle")
	
	# Adding the jump animation and conditions
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		elif SPEED == sprint: 
			animated_sprite_2d.play("run")
		else: 
			animated_sprite_2d.play("idle")
	else: 
		animated_sprite_2d.play("jump")
	

	move_and_slide()
