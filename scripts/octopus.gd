# script: octopus
extends RigidBody2D

onready var state = FlyingState.new(self)
const STATE_FLYING		= 0
const STATE_FLAPPING		= 1
const STATE_HIT			= 2
const STATE_GROUNDED		= 3
const ACCELERATION = 2
const SPEED = 44

var swimingForce = 0

signal state_changed
var prev_state = STATE_FLAPPING

func _ready():
	add_to_group(game.GROUP_OCTOPI)
	connect("body_entered", self, "_on_body_entered")
	pass
func _physics_process(delta):	
	state.update(delta)
func _input(event):
	state.input(event)
	pass
func _on_body_entered(other_body):
	if state.has_method("on_body_entered"):
		state.on_body_entered(other_body)
	pass
func set_state(new_state):
	prev_state = get_state()
	state.exit()
	if new_state == STATE_FLYING:
		state = FlyingState.new(self)
	elif new_state == STATE_FLAPPING:
		state = FlappingState.new(self)
	elif new_state == STATE_HIT:
		state = HitState.new(self)
	elif new_state == STATE_GROUNDED:
		state = GroundedState.new(self)
	emit_signal("state_changed", self)
	pass
func get_state():
	if state is FlyingState:
		return  STATE_FLYING
	elif state is FlappingState:
		return  STATE_FLAPPING
	elif state is HitState:
		return  STATE_HIT
	elif state is GroundedState:
		return  STATE_GROUNDED

# state management classes
class FlyingState:
	var octopus
	#var prev_gravity_scale
	func _init(octopus):
		self.octopus = octopus
		octopus.get_node("anim").play("swimming")
		#prev_gravity_scale = octopus.get_gravity_scale()
		octopus.set_linear_velocity(Vector2(octopus.SPEED, octopus.get_linear_velocity().y))
		octopus.set_gravity_scale(0)
		pass
	func update(delta):
		pass	
	func input(event):
		pass
	func exit():
		#octopus.set_gravity_scale(prev_gravity_scale)
		octopus.get_node("anim").stop();
		octopus.get_node("anim_sprite").position  = Vector2(0,0)
		pass
		
class FlappingState:
	var octopus
	func _init(octopus):
		self.octopus = octopus
		octopus.get_node("anim").play("swimming")
		octopus.set_linear_velocity(Vector2(octopus.SPEED, octopus.get_linear_velocity().y))
		
	func update(delta):
		var newSpeed = Vector2(octopus.SPEED + game.score_current * octopus.ACCELERATION, octopus.get_linear_velocity().y * 0.97)
		octopus.set_linear_velocity(newSpeed)
			
	func input(event):
		if event is InputEventMouseMotion:
			swim(event.relative.y)
		if event.is_action_pressed("swim_up"):
			swimUp()
		if event.is_action_pressed("swim_down"):
			swimDown()
			
	func exit():
		pass
	func on_body_entered(other_body):
		if other_body.is_in_group(game.GROUP_PIPES):
			octopus.set_state(octopus.STATE_HIT)
		elif other_body.is_in_group(game.GROUP_GROUNDS):
			octopus.set_state(octopus.STATE_GROUNDED)
		pass
	func swim(force):
		octopus.swimingForce = force
		octopus.set_linear_velocity(Vector2(octopus.get_linear_velocity().x, octopus.swimingForce))
		octopus.get_node("anim").play("swim")
		
	func swimUp():
		swim(-64)
		
	func swimDown():
		swim(64)

class HitState:
	var octopus
	func _init(octopus):
		self.octopus = octopus
		octopus.set_linear_velocity(Vector2(0, octopus.SPEED + game.score_current * octopus.ACCELERATION))
		octopus.set_angular_velocity(1)
		var other_body = octopus.get_colliding_bodies()[0]
		octopus.add_collision_exception_with(other_body)
		octopus.get_node("sfx_hit").play()
		octopus.get_node("sfx_die").play()
		pass
	func update(delta):
		pass	
	func input(event):
		pass
	func on_body_entered(other_body):
		if other_body.is_in_group(game.GROUP_GROUNDS):
			octopus.set_state(octopus.STATE_GROUNDED)
		pass
	func exit():
		pass

class GroundedState:
	var octopus
	func _init(octopus):
		self.octopus = octopus
		octopus.set_linear_velocity(Vector2(0,0))
		octopus.set_angular_velocity(0)
		if octopus.prev_state != octopus.STATE_HIT:
			octopus.get_node("sfx_hit").play()
		pass
	func update(delta):
		pass	
	func input(event):
		pass
	func exit():
		pass
