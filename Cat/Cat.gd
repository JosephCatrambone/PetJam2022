extends KinematicBody

signal on_eat
signal on_sleep
signal on_play
signal on_affection
signal action_started(action)
signal action_complete(action)

var happiness = 0.0  # Determines how likely an action command from the player is to get picked up.
var command_queue: Dictionary = {}  # This is a map of action -> priority.
var current_action: String = ""

# Movement:
export var walk_speed:float = 1.0
export var run_speed:float = 1.0
#export var turn_rate:float = 1.0
var walk_time = 0.0
export var max_walk_time:float = 10.0  # If we are walking towards something for more than this long, we can't get there.

# Different subsystems.
var needs:Array = []

func _ready():
	pass

func _process(delta):
	if not current_action:
		var next_action = select_command()
		emit_signal("action_started", next_action)
		current_action = next_action
	
	# Are we at the location we need to be for the active action?

	# Execute the plan!
	match current_action.to_lower():
		"wander":
			# Pick a target at random.
			self.move_target = self.global_transform.origin + Vector3(randf()*5, 0.0, randf()*5)

		"speak":
			pass
		"sit":
			pass
		"come":
			pass
		"down":
			pass
		"jump":
			pass
		"play":
			pass

		"groom":
			pass
		
		"sleep":
			print("Cat is sleeping")
			emit_signal("on_sleep")
			emit_signal("action_complete", self.current_action)
		"wake":
			pass
		
		"eat":
			emit_signal("on_eat")

func move_to(delta:float, move_target: Vector3) -> bool:
	# Move to the given target and return true if we're close enough.
	# Avoid getting stuck:
	self.walk_time += delta
	var dpos = self.global_transform.origin - move_target
	self.move_and_slide(Vector3(dpos.x, 0.0, dpos.z).normalized()*walk_speed)
	if dpos.length_squared() < walk_speed or self.walk_time > self.max_walk_time:
		# Arrived.
		self.walk_time = 0.0
		return true
	return false

# Handle interactible pieces.
func get_interactions():
	return ["pet", "scold", "treat", "feed", "command"]

func interact(action):
	if action == "Command":
		return ["speak", "sit", "come", "down", "jump"]
	return null

# Handle state tree.
func queue_command(command: String, priority: float):
	print_debug("Command queued: ", command, " with priority ", priority)
	command_queue[command] = priority

func select_command():
	if len(self.command_queue) == 0:
		return ""
		
	# Sum the probabilities.  Pick a number in the range of 0 to that, and when we land there, pick that action.
	var total_probability = 0.0
	for k in self.command_queue:
		total_probability += self.command_queue[k]
	var pick_energy = total_probability*randf()
	var chosen_action = ""
	for k in self.command_queue:
		if pick_energy < self.command_queue[k]:
			chosen_action = k
		else:
			pick_energy -= self.command_queue[k]
	# Remove this action from the pending and return it.
	self.command_queue.erase(chosen_action)
	return chosen_action
