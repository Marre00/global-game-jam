extends CharacterBody2D

const GRAVITY : int = 100
const JUMP_SPEED : int = -100
var JUMP : int = 0;
var com : int = 1
var pos = position.x



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var sco =  get_node("/root/Main").score
	if (sco > 100):
		var collision = move_and_collide(velocity * delta)
		var morte = get_node("/root/Main").morte
		
		velocity.y += GRAVITY * delta
		if collision:
			JUMP = 1;
			if(velocity.y > -200 and velocity.y < 200):
				$AnimatedSprite2D.play("parado")
			
		if Input.is_action_just_pressed("pulasapo") and JUMP:
			if (com == 0):
				velocity.y = JUMP_SPEED
				JUMP = 0
		else:
			if velocity.y < 0 and JUMP == 0:
				$AnimatedSprite2D.play("u  p2")
			if velocity.y > 0 and JUMP == 0:
				$AnimatedSprite2D.play("Down2")
			
		move_and_slide()
		if collision:
			position.y = get_node("/root/Main/bolha").VELO - 20 
			if Input.is_action_just_pressed("pulasapo") and JUMP:
				if (com == 0):
					velocity.y = JUMP_SPEED
			com = 0;
		if(morte == 1):
			$AnimatedSprite2D.play("Morte")
