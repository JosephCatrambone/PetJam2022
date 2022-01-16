extends Spatial

onready var mesh:MeshInstance = $CatBowlMesh
var fill = 0.0
var need_mesh_refresh = false

# Called when the node enters the scene tree for the first time.
func _ready():
	interact("empty")

# For the cat:
func has_food():
	return self.fill > 0.1

func eat(amount):
	# Return the amount eaten and update this fill.
	amount = min(amount, self.fill)
	self.fill -= amount
	self.need_mesh_refresh = true
	return amount

# Handle interactible pieces.
func get_interactions():
	return ["fill", "empty", "clean"]

func interact(action):
	if action == "fill":
		self.fill += 0.25
	elif action == "empty" or action == "clean":
		self.fill = 0.0
	elif action == "eat":
		self.fill -= 0.01
	self.need_mesh_refresh = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.need_mesh_refresh:
		self.set_fill(self.fill)
		self.need_mesh_refresh = false

func set_fill(level):
	# 0 is empty.  1.0 is full.  2.0 is way over full.
	level = max(0.0, min(level, 2.0))
	var blend_level = 1.0 - level
	self.mesh.set("blend_shapes/Empty", blend_level)
