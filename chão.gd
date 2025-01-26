extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) :
	var sco =  get_node("/root/Main").score
	$AnimatedSprite2D.play("dia")
	if (sco > 10000):
		$AnimatedSprite2D.play("tarde")
	if (sco > 20000):
		$AnimatedSprite2D.play("dia")
