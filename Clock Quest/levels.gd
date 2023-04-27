extends Node2D

var true_clock
var clocks
var clocks_entry_per_clock = 0 # set every clokc have difference clokc hand delay
var max_delay = 0.8 # set max delay, 0.8 is 1 - 0.2 (where clokc hand transformation delay from and to another clokc number), you can see that on clock > MainAnimationPlayer > 'second' Animation
var level_clock_count = 0 # this is used to identify every level clock count
var main
var seconds_arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 4]
var levels_info = {
	3:0,
	6:1,
} # this dict values is level and their info, example level 3 have info in $"root/main/info/lables/{child - 0}"

func _ready():
	main = get_node('/root/main')
	get_level_clock() 
	randomize() # call this funtion to create new random

func get_level_clock():
#	get the clock node based on level, so we can maange this level clock
	clocks = get_node('/root/main/levels/level_%s/clocks' % Global.get_real_level_state())
	level_clock_count = clocks.get_child_count()
	clocks_entry_per_clock = max_delay / level_clock_count

func setup_level():
	get_level_clock()
	
	# lets set the true clock randomly
	true_clock = clocks.get_child(randi() % level_clock_count)
	true_clock.add_to_group(Global.true_clock_group)

func clock_hand():
	var delay_now = 0.2
	var second_arr = 0
	
	seconds_arr.shuffle() # make array is random
	
#	get nodes that is on 'true_clock' group, then play the 'SoundAnimationPlayer' animation
	for clock in clocks.get_children():
		clock.on_this_level = true
		
		if clock.is_in_group(Global.true_clock_group):
			true_clock = clock
			
			clock.SoundAnimationPlayer.play("clok's hand")
			clock.play_second()
			clock.clocks_entry.start()
			Global.start_clocks_entry = true
			
		else:
			clock.start_at = delay_now 
			
		delay_now += clocks_entry_per_clock
		clock.second_anim_start_from = seconds_arr[second_arr] # we set clock.second_anim_start_from randomly based on seconds_arr
		second_arr += 1

func stop_clock_sound():
#	This function is used to stop true_clokc sound, we will use this func on game_over, time_up, finish or other
	true_clock.SoundAnimationPlayer.stop()

func next_level():
#	This function will be called when we want to stop the game, this func is used when the player select the wrong clock or to next level
	stop_clock_sound()
	main.time_left_anim.stop()
	get_node("/root/main/levels/LevelsAnimationPlayer").play('stop')
	Global.is_playing = false
	get_node('/root/main/LevelTimer').stop()

func check_level_info():
	if Global.level == 12:
		get_node('/root/main/info').show_info(2)
	elif Global.status != "game_over":
		if levels_info.has(int(Global.get_real_level_state())):
			get_node('/root/main/info').show_info(levels_info[int(Global.get_real_level_state())])
		else:
			main.start_level()

func check_level():
#	this function will check every level node, if node is not the current level, then hide it, else ? show it
	for child in get_children():
		if child.name.begins_with("level_"):
			child.hide() if child.name != "level_" + Global.get_real_level_state() else child.show()
			
	# also we will reset the 'time_left' progress bar and other where are needed
	main.time_left_prog_bar.value = 100
	main.time_left_prog_bar.get_node('./Points').reset_points()
