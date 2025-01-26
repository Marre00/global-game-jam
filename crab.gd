extends Area2D
var scorep: int
var autura := [3,5,7,10]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dif = get_node("/root/Main").difficulty + 1
	scorep = $"../Jogador".position.x
	$AnimatedSprite2D.play("crab")
	
	if(position.x - scorep > -200 * dif and position.x - scorep < 0):
		position.y += 5
	if(position.x - scorep < 200 * dif and position.x - scorep > 0):
		position.y -= 5
	
