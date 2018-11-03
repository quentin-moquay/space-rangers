extends RigidBody2D

signal exit

var type = 'bomb'

export (int) var min_speed = 800
export (int) var max_speed = 1000

var is_destroy

var spawn_zones = [0,100,200,300,400]
var screensize
var speed

var pos_y
var bg_speed

func _ready():
	is_destroy = false
	screensize = get_viewport_rect().size
	set_physics_process(true)
	
	#init_spawn
	speed = rand_range(min_speed,max_speed) + bg_speed
	
	var zone = range(0,5)[randi()%range(0,5).size()]
	self.position.x = rand_range(0,spawn_zones[zone])
	self.position.y = pos_y
	
	pass

func kill():
	is_destroy = true
	$bonus.play()
	$bombe.hide()
	$score.show()
	
func _physics_process(delta):
	var velocity = Vector2()
	velocity.y += 1
	
	if self.is_destroy:
		velocity = velocity.normalized() * 200
	else:
		velocity = velocity.normalized() * speed
	
	self.position += velocity * delta
	
	pass
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
