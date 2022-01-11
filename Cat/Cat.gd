extends KinematicBody

var happiness = 0.0
onready var needs = $DesireController

func get_interactions():
	return ["Pet", "Scold", "Treat", "Feed", "Command"]

func interact(action):
	if action == "Command":
		needs.step(1.0)
		return ["Speak", "Sit", "Come", "Down"]
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
