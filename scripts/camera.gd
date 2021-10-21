#script: camera

extends Camera2D

#onready var octopus = get_node("../Octopus")
onready var octopus = utils.get_main_node().get_node("octopus")

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position = Vector2(octopus.position.x, position.y)
	pass

func get_total_pos():
	return position + offset;
