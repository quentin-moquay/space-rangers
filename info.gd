extends RichTextLabel

func _ready():
	var hero = get_tree().get_root().get_node("root/viewport/travelling/hero")
	hero.connect("restart", self, "restart")
	pass

func restart():
	set_bbcode("")

func show_message(var message):
	set_bbcode("[center]"+ message +"[/center]")