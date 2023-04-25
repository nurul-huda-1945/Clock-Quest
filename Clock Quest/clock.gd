extends Area2D

var one_rotation = 360
var seconds = 9 # there's only 9 seconds in one rotation
var per_second = one_rotation / seconds # get rotation degree in one second
var numbers_folder_path = "res://image/numbers/"
var on_hover = false
var MouseHandleAnimationPlayer
var SoundAnimationPlayer
var root_node # declare a variable that pointing to root node, then we can access the root script
var clockwise_center
var MainAnimationPlayer
var levels_node
var start_at = 0 # this variable is the point when this clock starting (clocks hand) 
var clocks_entry
var is_playing_clock_hand = false
var on_this_level = false
var second_anim_start_from = 0.0 # we set the MainAnimationPlayer 'second' animation start from

func _ready():
	randomize() # call this funtion to create new random

	SoundAnimationPlayer = $SoundAnimationPlayer
	MainAnimationPlayer = $MainAnimationPlayer
	MouseHandleAnimationPlayer = $MouseHandleAnimationPlayer
	clockwise_center = $clockwise_center
	root_node = get_node("/root/main") 
	clocks_entry = get_node('/root/main/levels/clocks_entry')
	
#	create numbers on clocks, from 1 to 9
	for second in range(1, seconds + 1):
		var clock_rotaion = second * per_second
		clockwise_center.rotation_degrees = clock_rotaion
		
#		create clock number node
		var second_number = Sprite.new()
		var number_file_path = numbers_folder_path + "number_%s.png" % str(second)
		second_number.texture = load(number_file_path)
		second_number.global_position = $clockwise_center/clock_number_position.global_position - clockwise_center.global_position
		second_number.scale = Vector2(0.568, 0.568)
		
		$numbers.add_child(second_number)

func _process(delta):
#	check if this clock isn't on true_clock group and check if clocks_entry timer is lower than start_at variable
	if on_this_level and !is_playing_clock_hand and !self.is_in_group(Global.true_clock_group) and clocks_entry.time_left <= start_at and Global.start_clocks_entry:
		play_second()
		is_playing_clock_hand = true

#	check if mouse click this clock, if the clock is true then next level, if not call fail() function
	if Input.is_action_just_pressed("left_mouse") and on_hover and Global.health > 0:
		var clock_true_false = load("res://clock_true_false.tscn").instance()
		
		if self.is_in_group(Global.true_clock_group):
			if Global.status == 'tutorial':
				root_node.MainAnimationPlayer.play("start_level")
				SoundAnimationPlayer.stop()
			else:
				get_node('/root/main/levels').next_level()

			Global.level += 1
			get_node("/root/main/correct").play() 
			clock_true_false.texture = load("res://image/correct.png")
			get_node("/root/main/background/level_info/Label").text = "LEVEL " + Global.get_real_level_state()
		else:
			if Global.status != 'tutorial':
				root_node.false_clock()
				
			get_node("/root/main/wrong").play() 
			
		add_child(clock_true_false)
			
func _on_clock_mouse_entered():
#	This function will be called when the mouse is entered the clock area
	on_hover = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	MouseHandleAnimationPlayer.play("hovered")

func _on_clock_mouse_exited():
#	This function will be called when the mouse is exited the clock area
	on_hover = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	MouseHandleAnimationPlayer.play("unhovered")
	
func clokcs_hand():
#	play clock hand audio player from float 0.76, also start the clocks_entry timer, not all clock use this function, only true clock
	$"Clocks Hand".play(0.76)
	
func play_second():
	if Global.level > 6:
		MainAnimationPlayer.play("second") if (randi() % 2) == 0 else $MainAnimationPlayer.play_backwards("second")
	elif Global.level > 3:
		$MainAnimationPlayer.play_backwards("second")
	else:
		MainAnimationPlayer.play("second")
		
	MainAnimationPlayer.seek(second_anim_start_from)
	
