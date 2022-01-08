extends Spatial

# Xibanya: also if anyone identifies the song I will allow some tenuous connection to the lyrics in the bridge that excerpt is from to count as theme adherence (so long as all other jam rules are followed)
# Song is Ni**as in Paris by Kanye West: "So I ball so hard motherfuckers wanna' find me."
# Bonus for the cat balling so hard.

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var a = Matrix.new(3, 3, 0.0)
	var b = Matrix.new(3, 3, 0.0)
	
	print(b.to_string())
	
	a.set_value(0, 0, 5)
	assert(a.get_value(0, 0) == 5)
	b = a.add(b)
	
	print(b.to_string())
	
	b.set_value(1, 1, 2)
	b = a.add(b)
	b = b.add(1)
	
	print(b.to_string())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
