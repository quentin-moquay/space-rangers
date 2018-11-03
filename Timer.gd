extends Timer

var hud

var spawn_pos
var travelling

#only for loading purposes
onready var hero = get_tree().get_root().get_node("root/viewport/travelling/hero")

# types
onready var enemy = preload("res://enemy.tscn")
onready var bonus = preload("res://bonus.tscn")
onready var bomb = preload("res://bomb.tscn")

func _ready():
	travelling = get_tree().get_root().get_node("root/viewport/travelling")
	spawn_pos = get_tree().get_root().get_node("root/spawn_pos")
	hud = get_tree().get_root().get_node("root/viewport/travelling/hud2/hud")
	
	hero.hide()
	pass
	
	

func _on_enemy_spawn():
	
	var percent = randf()
 	
	if percent >= 0.99:
		_spawn_bonus()
		_spawn_bomb()
	elif percent >= 0.97:
		_spawn_bonus()
	elif percent >= 0.95:
		_spawn_bomb()
	elif percent >= 0.88:
		# double_enemy
		_spawn_enemy(3)
	elif percent >= 0.80:
		# double_enemy
		_spawn_enemy(2)
	else:
		_spawn_enemy(1)
	
	pass

func _spawn_bonus():
	var spawning = bonus.instance()
	spawning.pos_y = spawn_pos.position.y
	spawning.bg_speed = travelling.curr_speed
	add_child(spawning)

func _spawn_bomb():
	var spawning = bomb.instance()
	spawning.pos_y = spawn_pos.position.y
	spawning.bg_speed = travelling.curr_speed
	add_child(spawning)

func _spawn_enemy(var many):
	for i in range(many):
		var spawning = enemy.instance()
		spawning.pos_y = spawn_pos.position.y
		spawning.bg_speed = travelling.curr_speed
		hero.connect("hit", spawning, "hit")
		spawning.connect("score", hud, "score")
		hero.connect("kill_all", spawning, "kill_all")
		add_child(spawning)
	