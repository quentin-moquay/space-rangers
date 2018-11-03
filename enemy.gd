extends RigidBody2D

signal score

var type = 'enemy'

export (int) var min_speed = 400
export (int) var max_speed = 1000

var is_destroy

var hits
var spawn_zones = [0,25,50,75,100,125,150,175,200,225,250,275,300,325,350,375]
var colors = ['color_1','color_2']
var color
var screensize
var speed

var pos_y
var bg_speed

func _ready():
	is_destroy = false
	screensize = get_viewport_rect().size
	set_physics_process(true)
	
	hits = [$hit,$hit2,$hit3]
	#init_spawn
	speed = rand_range(min_speed,max_speed) + bg_speed
	
	var zone = range(0,spawn_zones.size())[randi()%range(0,spawn_zones.size()).size()]
	
	if zone > 0:
		self.position.x = rand_range(spawn_zones[zone-1],spawn_zones[zone])
	else:
		self.position.x = rand_range(spawn_zones[zone],spawn_zones[zone + 1])
	self.position.y = pos_y
	
	var color_idx = range(0,colors.size())[randi()%range(0,colors.size()).size()]
	color = colors[color_idx]
	
	if color == 'color_1':
		$red.show()
		$green.hide()
	else:
		$green.show()
		$red.hide()
	
	pass

func _physics_process(delta):
	var velocity = Vector2()
	velocity.y += 1
	
	if self.is_destroy:
		velocity = velocity.normalized() * 200
	else:
		velocity = velocity.normalized() * speed
	
	self.position += velocity * delta
	
	pass

func kill_all():
	kill(false)
	
func kill(var sound = true):
	if is_destroy == false:
		is_destroy = true
		$green.hide()
		$red.hide()
		if sound:
			var hit_idx = range(0,hits.size())[randi()%range(0,hits.size()).size()]
			hits[hit_idx].play()
		$score.show()
		$explosion.show()
		$explosion.frame = 0
		$explosion.play("default")
		emit_signal("score", 10)

func hit():
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	if is_destroy == false:
		emit_signal("score", 5)
	queue_free()
