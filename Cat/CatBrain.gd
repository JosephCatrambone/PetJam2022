extends Node

# This module tracks the basic needs of the cat and determines how the happiness should be impacted.
# This does not directly record happiness.

class AnimalTrait:
	var current_value = 0.0
	var min_value = 0.0
	var max_value = 0.0
	var decay_rate = 0.0  # Negative
	var negative_penalty = 0.0  # How much does this damage happiness when below min?  Should be negative.
	var positive_penalty = 0.0  # How much does this damage happiness when above max?  Should be negative.
	var satisfied_bonus = 0.0  # How much does this _add_ to happiness when in the right range?
	
	func _init(start_value, low, high, decay, low_penalty, high_penalty, bonus):
		self.current_value = start_value
		self.min_value = low
		self.max_value = high
		self.decay_rate = decay
		self.negative_penalty = low_penalty
		self.positive_penalty = high_penalty
		self.satisfied_bonus = bonus
	
	func step(delta):
		self.current_value += decay_rate*delta
	
	func get_happiness_impact():
		if self.current_value < self.min_value:
			return self.negative_penalty
		elif self.current_value > self.max_value:
			return self.positive_penalty
		else:
			return self.satisfied_bonus

var last_happiness_delta:float = 0.0  # How much does happiness change per unit time?

var traits:Dictionary = {
	"Hunger": AnimalTrait.new(0.5, 0.7, 0.9, 0.02, 0.1, 0.05, 0.05),
	"Sleep": AnimalTrait.new(0.2, 0.9, 0.9, 0.0, 0.1, 0.2, 0.01),
	"Play": AnimalTrait.new(0.5, 0.7, 0.9, 0.02, 0.1, 0.05, 0.05),
	"Affection": AnimalTrait.new(0.5, 0.7, 0.9, 0.02, 0.1, 0.05, 0.05),
}

func step(time_delta):
	self.last_happiness_delta = 0.0
	for t in self.traits:
		self.traits[t].step(time_delta)
		self.last_happiness_delta += self.traits[t].get_happiness_impact()

func get_happiness_impact():
	return self.last_happiness_delta
