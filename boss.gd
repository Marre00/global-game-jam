extends Area2D
var screen_size : Vector2i
var i : int = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is   the elapsed time since the previous frame.
func _process(delta):
	i += 1
	$AnimatedSprite2D.play("bafo")
	if( i > 20 and i < 120):
		position.x -= get_parent().speed * -1
		

	
		
		
