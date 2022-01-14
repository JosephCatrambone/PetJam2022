extends Node

export var sleep_desire = 0.0
export var sleep_growth_rate = 0.0
var sleeping:bool = false

func _ready():
	get_parent().connect("on_sleep", self, "_on_cat_sleep")
	get_parent().connect("action_started", self, "_on_cat_action_started")

func _on_cat_sleep():
	sleep_desire = 0.0

func _on_cat_action_started(action):
	if action.to_lower() == "sleep":
		self.sleeping = true

func get_happiness_impact() -> float:
	return -sleep_desire

func _process(delta):
	if self.sleeping:
		self.sleep_desire -= sleep_growth_rate*delta
		if self.sleep_desire <= 0.0:
			get_parent().queue_command("wake", 1.0)
			self.sleeping = false
	else:
		sleep_desire += sleep_growth_rate*delta
		# If the delta pushes us over 0.4, announce:
		if sleep_desire+(sleep_growth_rate*delta) > 0.8 and sleep_desire < 0.8:
			print_debug("Cat is sleepy.")
		if sleep_desire > 0.9:
			print_debug("Cat is going to sleep.")
			get_parent().queue_command("sleep", self.sleep_desire)
	
