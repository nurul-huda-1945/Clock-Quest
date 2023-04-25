# this script is used for global variable (singleton)
extends Node

var true_clock_group
var status
var level
var is_playing # this variable help us to know if user is playing the game 
var start_clocks_entry
var health
var score = 0
var min_score = 0

func _ready():
	reload_var()

func reload_var():
#	we need this function because when we want to restart the game, the Global variable value isn't back automatically
	true_clock_group = 'true_clock'
	status = ''
	level = 1
	is_playing = false
	start_clocks_entry = false
	health = 3

func get_real_level_state():
	return str(level - 1)
