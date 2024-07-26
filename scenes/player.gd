extends CharacterBody2D


const SPEED = 300.0

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("MOVE_RIGHT", "MOVE_LEFT")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Move the character
	move_and_slide()

	# Ensure the character doesn't walk off the screen
	clamp_to_screen()

func clamp_to_screen():
	var viewport_rect = get_viewport_rect()
	position.x = clamp(position.x, 0, viewport_rect.size.x)
	position.y = clamp(position.y, 0, viewport_rect.size.y)
