extends Sprite

var AnimationPlayer

func _ready():
	AnimationPlayer = get_node("AnimationPlayer")

func show_info(label_idx):
#	here we use this function to show some info
	var labels = get_node('./lables')
	
	for label in labels.get_children():
		label.hide()
		
	labels.get_child(label_idx).show()
	AnimationPlayer.play("show_info")

func _on_ok_button_down():
	AnimationPlayer.play("close_info")
