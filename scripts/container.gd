extends Container

func _ready():
	hide()
	var octopus = utils.get_main_node().get_node("octopus");
	if octopus:
		octopus.connect("state_changed", self, "_on_octopus_state_changed")
	pass # Replace with function body.

func _on_octopus_state_changed(octopus):
	if octopus.get_state() == octopus.STATE_GROUNDED:
		get_node("anim").play("show")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
