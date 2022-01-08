extends Control

export var radius:float
export var open_time:float

var open:bool = false  # Open is not set until the bits are completely unfurled.
var options:Array = []
onready var tween:Tween = $Tween
onready var base_button:TextureButton = $BaseButton
onready var buttons:Control = $Buttons

# Called when the node enters the scene tree for the first time.
func _ready():
	# So it's not displayed below.
	self.remove_child(self.base_button)

func open_menu(opts):
	if len(opts) == 0:
		return
		
	if self.open:
		print_debug("Menu already open with ", self.options, " but getting a reopen request with ", opts)
		
	self.open = true
	self.options = opts
	
	# Clear old buttons.
	for c in self.buttons.get_children():
		self.buttons.remove_child(c)
		c.queue_free()
	
	# Spawn new buttons.
	for idx in range(len(self.options)):  # No enumerate. :'(
		var opt = self.options[idx]
		var clone = base_button.duplicate(DUPLICATE_SIGNALS | DUPLICATE_GROUPS)
		clone.get_node("Label").text = opt
		self.buttons.add_child(clone)
		var angle = TAU * float(idx) / float(len(self.options))
		self.tween.interpolate_property(clone, "rect_position", clone.rect_position, clone.rect_position + Vector2(cos(angle)*radius, sin(angle)*radius), open_time)
		self.tween.interpolate_property(clone, "modulate", clone.modulate, Color(1.0, 1.0, 1.0, 1.0), open_time)
	
	self.buttons.visible = true
	self.tween.start()
	yield(tween, "tween_completed")

func close_menu():
	# Tween closed, wait, and mark closed.
	for idx in range(self.buttons.get_child_count()):
		var angle = TAU * float(idx) / float(self.buttons.get_child_count())
		var c:TextureButton = self.buttons.get_child(idx)
		self.tween.interpolate_property(c, "rect_position", c.rect_position, -c.rect_min_size/2, open_time)
		self.tween.interpolate_property(c, "modulate", c.modulate, Color(1.0, 1.0, 1.0, 1.0), open_time)
	self.tween.start()
	
	yield(tween, "tween_completed")
	self.open = false
	self.buttons.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Float to where the cursor is.
	#var mouse_xy = get_global_mouse_position()
	#var delta_position = mouse_xy - self.get_global_transform()
	if not self.open:
		self.set_global_position(self.get_global_mouse_position())
	
	if Input.is_mouse_button_pressed(0) or Input.is_mouse_button_pressed(1):
		if not self.open:
			self.open_menu(["asdf", "zxcv", "qwer", "1234"])
	else:
		self.close_menu()

# When the mouse button is pressed, get a list of all possible commands
# Spawn one button for each, add callbacks, and quickly tweent hem onscreen.
# Click on something -> try interact

func _on_interaction(source):
	pass
