extends Node2D

var LevelTimer
var MainAnimationPlayer
var LevelsAnimationPlayer
var game_over_text
var levels
var time_left_anim
var time_left_prog_bar

func _ready():
	time_left_anim = $background/BG2/Control/time_left/AnimationPlayer
	time_left_prog_bar = $background/BG2/Control/time_left
	levels = $levels
	LevelTimer = $LevelTimer
	MainAnimationPlayer = $MainAnimationPlayer
	LevelsAnimationPlayer = $levels/LevelsAnimationPlayer
	game_over_text = load("res://image/text_gameover.png") 

func _process(delta):
#	check if game is playing, also check the time left of level timer, user will fail if the timer is finish
	if Global.is_playing:
		time_left_prog_bar.value = (LevelTimer.time_left / LevelTimer.wait_time) * 100
	
		if LevelTimer.time_left == 0:
			game_over()

func false_clock():
#	This function will be called when the player select the wrong clock
	Global.health -= 1
	$wrong.play()
	
	$background/BG2/Control/health.get_child(Global.health).get_child(0).play('queue')
	
	if Global.health <= 0:
		$background/fail_text.texture = game_over_text # if user is fail because empty health, we will set fail_text node texture with game_over_text texture
		game_over()
		
func game_over():
	Global.status = "game_over"
	Global.is_playing = false
	MainAnimationPlayer.play("game_over")
	levels.stop_clock_sound()
	LevelTimer.stop()

func start_level():
#	This function will be called when we want to start level after tutorial
	if Global.level == 12:
		result()
	else:
		LevelsAnimationPlayer.play('start')
		Global.status = 'levels'
	
func start_timer():
#	This function will be called when game is start
	LevelTimer.start(10)
	Global.is_playing = true
	
#	when level is start, lets show the level
	time_left_anim.play("time_left")
	$background/BG2/Control/level.text = "LEVEL: " + Global.get_real_level_state()
	
func result():
#	call this func to show and process the result
	var score_res = (3 * (Global.level - 2) - Global.min_score) 
	$background/result/Bg/point.text = "POINT: " + str(score_res if score_res >= 0 else 0)
	$background/result/Bg/max_level.text = "LEVEL: " + str(int(Global.get_real_level_state()) - 1)
	$background/result/Bg/score.text = "TOTAL: " +  str((score_res if score_res > 0 else 1) * int(Global.get_real_level_state()))
	MainAnimationPlayer.play("result")
	
func reload():
#	we will use this function to reload or reset the game, this will be used when the user want to retry a game
	Global.reload_var()
	get_tree().reload_current_scene()

func _on_play_button_down():
	levels.check_level()
	Global.status = 'tutorial'
	
	MainAnimationPlayer.play("tutorial")

func _on_retry_button_down():
	$MainAnimationPlayer.play("retry")
