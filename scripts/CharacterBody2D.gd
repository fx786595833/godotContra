extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var timer = $Timer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animation.play("jump")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("move_down") and is_on_floor():
		collision.disabled = true
		timer.start()
		
	var direction = Input.get_axis("move_left", "move_right")

	if is_on_floor():
		if direction > 0:
			animation.play("run")
			animation.flip_h = false
		elif direction == 0:
			animation.play("idle")
		else:
			animation.play("run")
			animation.flip_h = true
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_timer_timeout():
	collision.disabled = false
