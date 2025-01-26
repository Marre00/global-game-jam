extends CharacterBody2D

#const GRAVITY : int = 1
const JUMP_SPEED : int = -1800

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("pulasapo"):
		velocity.y -= JUMP_SPEED
	#else:
		#velocity.y += GRAVITY * delta
		 
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("parado")
		else:
			$RunCol.disabled = false
	else:
		$AnimatedSprite2D.play("up2")
		
		
	move_and_slide()
