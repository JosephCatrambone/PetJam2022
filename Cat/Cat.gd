extends KinematicBody

signal action_started(action)
signal action_complete(action)

var command_queue: Dictionary = {}  # This is a map of action -> priority.
var current_action: String = ""

# Movement:
export var walk_speed:float = 1.0
export var run_speed:float = 1.0
#export var turn_rate:float = 1.0
var walk_time = 0.0
export var max_walk_time:float = 10.0  # If we are walking towards something for more than this long, we can't get there.

# Different animal traits.
export(float) var base_happiness:float = 0.5
var current_happiness:float = 0.0
var min_queue_priority = 0.1

# HUNGER
export(NodePath) var food_bowl
export(Curve) var hunger_penalty:Curve  # As we move up from 0 to 1, what does the rescale seem like?
export(float) var hunger_scale:float = 1.0  # How much does max hunger take priority?
export(float) var hunger_growth_rate:float = 0.01  # How fast does hunger grow to 1.0 (max)?
var hunger:float = 0.0
var hunger_recovery_rate:float = 1.0  # This MUST be higher than hunger growth rate.

# SLEEP
export(NodePath) var bed
export(Curve) var tired_penalty:Curve  # As we move from 0 to 1, how does our tirendess begin to impact us.
export(float) var tired_scale:float = 1.0  # How much does max sleepiness take priority?
export(float) var tired_growth_rate:float = 0.01  # How fast do we get tired?
var tired:float = 0.0
var sleep_recovery_rate:float = 1.0

# BOREDOM
export(Curve) var bored_penalty:Curve
export(float) var bored_scale:float = 1.0
export(float) var bored_growth_rate:float = 0.1
var bored:float = 0.0
var bored_recovery_rate:float = 1.0


func _process(delta):
	self.update_needs(delta)
	var current_action = self.get_command()
	
	# Are we at the location we need to be for the active action?
	var at_target = true
	var target = self.get_location_for_action(current_action)
	if target:
		at_target = self.move_to(delta, target)
	if not at_target:
		return  # Working on getting there.

	# Execute the plan!
	match current_action.to_lower():
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
			self.tired -= self.sleep_recovery_rate*delta
			if self.tired <= 0.0:
				self.tired = 0.0
				self.complete_command()
		
		"eat":
			# We are at the bowl.
			var b = get_node(food_bowl)
			# TODO: This is tight coupling.  Fix it.
			if not b.has_food():
				# Meow or something.
				pass
			else:
				var amount_eaten = b.eat(self.hunger_recovery_rate*delta)
				self.hunger -= amount_eaten
				if self.hunger <= 0.0:
					self.hunger = 0.0
					self.complete_command()

func update_needs(delta):
	self.current_happiness = self.base_happiness
	
	# Compute the hunger penalty.
	self.hunger += delta*self.hunger_growth_rate
	var hunger_unhappiness = self.hunger_scale*self.hunger_penalty.interpolate(self.hunger)
	if hunger_unhappiness > self.min_queue_priority:
		self.queue_command("eat", hunger_unhappiness)
	self.current_happiness -= hunger_unhappiness
	
	# Sleep
	self.tired += delta*self.tired_growth_rate
	var tired_unhappiness = self.tired_scale*self.tired_penalty.interpolate(self.tired)
	if tired_unhappiness > self.min_queue_priority:
		self.queue_command("sleep", tired_unhappiness)
	self.current_happiness -= tired_unhappiness

func get_location_for_action(action:String):
	if action == "eat" and food_bowl:
		var fb:Spatial = get_node(food_bowl)
		return fb.transform.origin
	if action == "sleep" and bed:
		var cb:Spatial = get_node(bed)
		return cb.transform.origin
	return null

func move_to(delta:float, move_target: Vector3) -> bool:
	# Move to the given target and return true if we're close enough.
	# Avoid getting stuck:
	self.walk_time += delta
	var dpos = move_target - self.global_transform.origin
	self.move_and_slide(Vector3(dpos.x, 0.0, dpos.z).normalized()*walk_speed)
	if dpos.length() < walk_speed*0.1 or self.walk_time > self.max_walk_time:
		# Arrived.
		self.walk_time = 0.0
		return true
	return false

# Handle interactible pieces.
func get_interactions():
	return ["pet", "scold", "command"]  # Feed and Play are on different objects.

func interact(action):
	if action == "Command":
		return ["speak", "sit", "come", "down", "jump"]
	return null
	
# Handle state tree.
func queue_command(command: String, priority: float):
	print_debug("Command queued: ", command, " with priority ", priority)
	command_queue[command] = priority

func complete_command():
	if self.current_action:
		emit_signal("action_complete", self.current_action)
		self.current_action = ""
	else:
		print_debug("ERROR (non-critical): Action completed without a current action")

func get_command():
	# If we already have one selected, keep at it:
	if self.current_action:
		return self.current_action
	
	# If we have nothing, return nothing.  Note that we don't set the current action to empty.
	if len(self.command_queue) == 0:
		return ""
	
	# Pick something at random from the distribution.
	var chosen_action = random_choice_from_distribution(self.command_queue)
	
	# Remove this action from the pending and return it.
	self.command_queue.erase(chosen_action)
	
	# Signal that we're doing this.
	self.current_action = chosen_action
	emit_signal("action_started", chosen_action)
	
	return chosen_action

func random_choice_from_distribution(choices:Dictionary):
	if not choices:
		return null
		
	# Sum the probabilities.  Pick a number in the range of 0 to that, and when we land there, pick that action.
	var total_probability = 0.0
	for k in choices:
		total_probability += choices[k]
	var pick_energy = total_probability*randf()
	var chosen_action = ""
	for k in choices:
		if pick_energy < choices[k]:
			chosen_action = k
		else:
			pick_energy -= choices[k]
	return chosen_action
