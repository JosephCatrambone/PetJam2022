extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_interactions():
	return ["Pet", "Scold", "Treat", "Feed", "Command"]

func interact(action):
	if action == "Command":
		return ["Speak", "Sit", "Come", "Down"]
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
