extends RichTextLabel

var timer

func _ready():
	var hero = get_tree().get_root().get_node("root/viewport/travelling/hero")
	hero.connect("restart", self, "restart")
	hero.connect("hit", self, "game_over")
	
	timer = get_child(1)
	game_over()
	pass

func restart():
	hide_message()

func game_over():
	show_message("Press Enter to start the game")


func show_message(var message):
	show()
	set_bbcode("[center]"+ message +"[/center]")
	timer.start()

func hide_message():
	hide()
	timer.stop()
	set_bbcode("")

func _on_timer_clignotant_timeout():
	if is_visible_in_tree():
		hide()
	else:
		show()
	
	pass # replace with function body
	
