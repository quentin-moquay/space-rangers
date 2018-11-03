extends Area2D

signal hit
signal combo
signal kill_all
signal bonus
signal restart
signal shaking
signal game_over
signal mute_music

export (int) var speed = 800
export (int) var speed_boost = 200
export (int) var boost_limit = 400
var speed_bonus = 0

var screensize

var speed_text
var bomb_text

var colors = ['color_1','color_2']
var color
var bomb

func _ready():
	bomb = 0
	screensize = get_viewport_rect().size
	color = colors[0]
	speed_text = get_tree().get_root().get_node("root/viewport/travelling/hud2/speed")
	bomb_text =  get_tree().get_root().get_node("root/viewport/travelling/hud2/bomb")
	self.show_speed()
	self.show_bomb()
	_switch_color()
	set_physics_process(true)
	pass

func _physics_process(delta):
	var velocity = Vector2()
		
	if self.is_visible_in_tree():
		if Input.is_action_just_pressed('ui_bomb') && bomb > 0:
			bomb = bomb - 1
			self.show_bomb()
			emit_signal("kill_all")
			emit_signal("shaking",1.70, 15, 25)
			$bomb.play()
		if Input.is_action_pressed('ui_left'):
			velocity.x -= 1
		if Input.is_action_pressed('ui_right'):
			velocity.x += 1
		if Input.is_action_just_pressed('ui_mute'):
			emit_signal("mute_music")
		if Input.is_action_just_pressed('ui_select'):
			var fx = [$switch_fx,$switch_fx2]
			var idx = range(0,fx.size())[randi()%range(0,fx.size()).size()]
			fx[idx].play()
			if color == 'color_1':
				color = 'color_2'
			else:
				color = 'color_1'
			_switch_color()
	
	if Input.is_action_just_pressed('ui_accept') && !self.is_visible_in_tree():
		# restart
		_restart()
	if Input.is_action_pressed('ui_cancel'):
			emit_signal("game_over")
			queue_free()
			get_tree().quit()
		
	velocity.x = velocity.normalized().x * (speed + speed_bonus)
	
	self.position += velocity * delta
	# bordures
	position.x = clamp(position.x, 0, screensize.x - 100) #hardcoded width
	
	pass

func _switch_color():
	if color == 'color_1':
		$red.show()
		$green.hide()
	else:
		$green.show()
		$red.hide()
	

func _on_heros_body_entered(body):
	if body.is_destroy == false:
		if body.type == 'enemy':
			if body.color == self.color:
				emit_signal("combo")
				body.kill()
			elif body.is_destroy == false:
				$gameover_fx.play()
				hide()
				$collision.set_disabled(true)
				emit_signal("hit")
		elif body.type == 'bonus':
			emit_signal("bonus")
			body.kill()
			var old_speed = speed_bonus
			speed_bonus = speed_bonus + speed_boost
			speed_bonus = clamp(speed_bonus, 0, boost_limit)
			if speed_bonus > old_speed:
				$bomb.play()
				$reactor_left.amount = 10 + (speed_bonus / 5)
				$reactor_left.speed_scale += 1
				$reactor_right.amount = 10 + (speed_bonus / 5)
				$reactor_right.speed_scale += 1
				emit_signal("shaking", 2, $reactor_left.amount, $reactor_left.speed_scale + 7)
				self.show_speed()
		elif body.type == 'bomb':
			bomb = bomb + 1
			body.kill()
			self.show_bomb()
	pass # replace with function body
	
func _restart():
	emit_signal("restart")
	speed_bonus = 0
	$reactor_left.amount = 10
	$reactor_left.speed_scale = 1
	$reactor_right.amount = 10
	$reactor_right.speed_scale = 1
	bomb = 0
	$collision.set_disabled(false)
	self.show()
	show_speed()
	show_bomb()
	
func show_speed():
	var curr_speed = speed + speed_bonus
	if curr_speed == speed + boost_limit:
		speed_text.set_bbcode("[center]SPEED\nMAXIMUM[/center]")
	else:
		speed_text.set_bbcode("[center]SPEED\n" + str(speed + speed_bonus) + "[/center]")

func show_bomb():
		bomb_text.set_bbcode("[center]BOMB\n" + str(bomb) + "[/center]")