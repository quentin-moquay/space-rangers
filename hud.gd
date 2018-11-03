extends RichTextLabel

var score = 0
var best_score = 0

var mute_music = false
var music
var sr
var info
var titre
var timer

func _ready():
	music = get_tree().get_root().get_node("root/music")
	sr = get_tree().get_root().get_node("root/title_voice")
	titre = get_tree().get_root().get_node("root/viewport/travelling/hud2/titre")
	info = get_tree().get_root().get_node("root/viewport/travelling/hud2/info")
	var hero = get_tree().get_root().get_node("root/viewport/travelling/hero")
	hero.connect("restart", self, "restart")
	hero.connect("hit", self, "game_over")
	hero.connect("mute_music", self, "mute_music")
	hero.connect("bonus", self, "bonus")
	
	timer = get_tree().get_root().get_node("root/Timer")
	show_score()
	pass

func game_over():
	titre.show()
	timer.stop()
	if(score > best_score):
		best_score = score
		info.show_message("New Highscore !")
	else:
		info.show_message("Game Over")
	
	show_score()

func score(points):
	if !timer.is_stopped():
		score = score + points
		show_score()
  
func bonus():     
	score(100)

func mute_music():
	mute_music = !mute_music
	if mute_music:
		music.stop()
	else:
		music.play()
	

func restart():
	sr.play()
	if music.is_playing() == false && mute_music == false:
		get_tree().get_root().get_node("root/menu").stop()
		music.play()
	score = 0
	timer.start()
	titre.hide()
	show_score()

func show_score():
	set_bbcode("[center]SCORE\n"+str(score)+"[/center]")
	show_best_score()
	
func show_best_score():
	set_bbcode(get_bbcode() + "\n[center]HIGHSCORE\n"+str(best_score)+"[/center]")