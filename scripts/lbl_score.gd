extends Label

func _ready():
	text = str(game.score_current)
	game.connect("score_current_changed", self, "_on_score_current_changed")
	var octopus = utils.get_main_node().get_node("octopus")
	if (octopus):
		octopus.connect("state_changed", self, "_on_octopus_state_changed")
	pass

func _on_octopus_state_changed(octopus):
	if octopus.get_state() == octopus.STATE_GROUNDED: 	hide()
	if octopus.get_state() == octopus.STATE_HIT: hide()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_score_current_changed():
	text = str(game.score_current)
	pass
