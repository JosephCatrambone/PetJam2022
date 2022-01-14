extends Node

var hunger_level = 0.0
var hunger_growth_rate = 0.0

func _ready():
	get_parent().connect("on_eat", self, "_on_cat_eat")

func _on_cat_eat():
	pass

func _process(delta):
	pass
