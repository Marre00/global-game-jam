extends CharacterBody2D

const GRAVITY : int = -100
const GRAVITY_MAX: int = -100
const JUMP_SPEED : int = 75
var VELO
var inicio : int = 1
var JUMP : int = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var sco =  get_node("/root/Main").score
	if(inicio == 1):
		_iniciou()
	var collision = move_and_collide(velocity * delta)
	if(collision):
		if(JUMP == 0):
			inicio = 1
			JUMP = 1
	if Input.is_action_just_pressed("pulobolha"):
		velocity.y = JUMP_SPEED
	else:
		if Input.is_action_just_pressed("pulasapo"):
			velocity.y = JUMP_SPEED
			JUMP = 0
		else:
			velocity.y += GRAVITY * delta
	if(velocity.y < GRAVITY_MAX):
		velocity.y = GRAVITY_MAX
	VELO = position.y
	move_and_slide()

func _iniciou():
	velocity.y = JUMP_SPEED
	inicio = 0
