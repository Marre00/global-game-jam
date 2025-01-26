extends Node

#preload obstacles
var barco_scene = preload("res://barco.tscn")
var piriquito_scene = preload("res://piriquito.tscn")
var crab_scene = preload("res://crab.tscn")
var drake_scene = preload("res://drake_1.tscn")
var mergu_scene = preload("res://mergu.tscn")
var blob_scene = preload("res://blobs.tscn")
var obstacle_types := [barco_scene, crab_scene]
var obstacles : Array
var piriquito_heights:= [-100,0,100]
var fogo := [-60, -20]
var morte: int = 0;

#game variables
const POS_INI := Vector2i(-196, -32)
const CAM_START_POS := Vector2i(576, 324)
var difficulty : int = 1
const MAX_DIFFICULTY : int = 2
var score : int
const SCORE_MODIFIER : int = 10
var high_score : int
var speed : float
const START_SPEED : float = 5
const MAX_SPEED : int = 25
const SPEED_MODIFIER : int = 3000
var screen_size : Vector2i
var ground_height : int
var game_running : bool
var last_obs
var boss: int = 0
var cre: int = 0

func _ready():
	screen_size = get_window().size
	ground_height = 300
	$GameOver.get_node("Button").pressed.connect(new_game)
	if Input.is_action_just_pressed("restart"):
		new_game()
	new_game()

func new_game():
	score = 0
	show_score()
	game_running = false
	get_tree().paused = false
	difficulty = 0
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	

	morte = 0
	$Jogador.position = POS_INI
	$bolha.position = Vector2i(-199, 8)
	$Jogador.velocity = Vector2i(0, 0)
	$"chão".position = Vector2i(289, 152)
	$"chão2".position = Vector2i(577, 152)
	$"chão3".position = Vector2i(865, 152)
	$"chão4".position = Vector2i(1153, 152)
	$"chão5".position = Vector2i(1441, 152)
	$"chão6".position = Vector2i(1441, 152)
	$back.position = Vector2i(-282, 73)
	$back2.position = Vector2i(390, 73)
	$back3.position = Vector2i(1062, 73)
	$nuvem.position = Vector2i(1300, 111)
	$nuvem2.position = Vector2i(650, 111)

	#reset hud and game over screen
	$HUD.get_node("StartLabel").show()
	$GameOver.hide()
	$HUD.get_node("CreLabel").hide()
	$HUD.get_node("Cre").pressed.connect(cred)

		
func cred():
	if (cre == 0):
		$HUD.hide()
		$HUD.show()
		$HUD.get_node("StartLabel").hide()
		$HUD.get_node("CreLabel").show()
		cre = 1
	else:
		$HUD.hide()
		$HUD.show()
		$HUD.get_node("StartLabel").show()
		$HUD.get_node("CreLabel").hide()
		cre = 0


func _process(delta):
	var posib = $bolha.position.y
	#if(posib > 215 or posib < -150):
		#game_over()
	
	if game_running:
		#speed up and adjust difficulty
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		#adjust_difficulty()
		
		#generate obstacles
		generate_obs()
		
		#move dino and camera
		$Jogador.position.x += speed
		$bolha.position.x += speed  
		if(score > 1000):
			$back.position.x += 2
			$back2.position.x += 2
			$back3.position.x += 2
		
		
		var pos = $Jogador.position.x
		#update score
		score += speed
		show_score()
		
		#update ground position  
			 
		if $Jogador.position.x - $chão.position.x > screen_size.x * 0.4:
			$chão.position.x += 288*4
		if $Jogador.position.x - $chão2.position.x > screen_size.x * 0.4:
			$chão2.position.x += 288*4
		if $Jogador.position.x - $chão3.position.x > screen_size.x * 0.4:
			$chão3.position.x += 288*4
		if $Jogador.position.x - $chão4.position.x > screen_size.x * 0.4:
			$chão4.position.x += 288*4
		if $Jogador.position.x - $chão5.position.x > screen_size.x * 0.4:
			$chão5.position.x += 288*4
		if $Jogador.position.x - $chão6.position.x > screen_size.x * 0.4:
			$chão6.position.x += 288*4
			
		if $Jogador.position.x - $back.position.x > screen_size.x * 1:
			$back.position.x += 336*6
		if $Jogador.position.x - $back2.position.x > screen_size.x * 1:
			$back2.position.x += 336*6
		if $Jogador.position.x - $back3.position.x > screen_size.x * 1:
			$back3.position.x += 336*6
			
		if $Jogador.position.x - $nuvem.position.x > screen_size.x * 1:
			$nuvem.position.x += 336*6
		if $Jogador.position.x - $nuvem2.position.x > screen_size.x * 1:
			$nuvem2.position.x += 336*6
			
		#remove obstacles that have gone off screen
		for obs in obstacles:
			if obs.position.x < ($Jogador/Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()
			$HUD.get_node("CreLabel").hide()
			$HUD.get_node("Cre").hide()


func generate_obs():
	if(boss == 0):
		var obs
		if obstacles.is_empty() or randi_range(0,20-difficulty) == 1:
			var gay = randi_range(0, 1)
			if gay == 0:
				var max_obs = difficulty + 1
				for i in range(randi() % max_obs + 1):
					var ar = (randi_range(0, 20))
					if (ar <= 3):
						obs = piriquito_scene.instantiate()
					if (score > 10000 and ar >= 20 ):
						obs = drake_scene.instantiate()
					var obs_x : int = screen_size.x + score + 100
					var obs_y = piriquito_heights[randi() % piriquito_heights.size()] 
					if (ar <= 6 and ar > 3):
						obs = blob_scene.instantiate()
						obs_y = (randi_range(200, 300))
					if (score > 10000 and ar <= 8 and ar > 6):
						obs = mergu_scene.instantiate()
						obs_y = 300
					obs_x = screen_size.x + score + 100
					if(obs):
						add_obs(obs, obs_x, obs_y)
			else:
				var obs_type = obstacle_types[randi() % obstacle_types.size()]
				obs = obs_type.instantiate()
				var obs_y : int = 370
				var max_obs = 1
				for i in range(randi() % max_obs + 1):
					obs = obs_type.instantiate()
					var obs_height = obs.get_node("Sprite2D").texture.get_height()
					var obs_scale = obs.get_node("Sprite2D").scale
					var obs_x : int = screen_size.x + score + 100 + (i * 100) +  randi_range(-300, 300)
					obs_y= 380
					last_obs = obs
					add_obs(obs, obs_x, obs_y)
			

			
		

func add_obs(obs, x, y): 
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)  
	add_child(obs)
	obstacles.append(obs)
	
func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func hit_obs(body):
	if body.name == "Jogador" or "bolhas":
		morte = 1
		game_over()

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / SCORE_MODIFIER)

func check_high_score():
	if score > high_score:
		high_score = score
	$HUD.get_node("HighScoreLabel").text = "HIGH SCORE: " + str(high_score / SCORE_MODIFIER)

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY


func game_over():
	check_high_score()
	get_tree().paused = true
	game_running = false
	$GameOver.show()
