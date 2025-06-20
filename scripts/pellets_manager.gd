extends Node

var total_pellets_count
var pellets_eaten = 0

@onready var ui: UI = $"../UI"

func _ready():
	var pellets = self.get_children() as Array[Area2D]
	total_pellets_count = pellets.size()
	for pellet in pellets:
		pellet.pellet_eaten.connect(on_pellets_eaten)
		
func on_pellets_eaten():
	pellets_eaten += 1
	
	if pellets_eaten == total_pellets_count:
		ui.game_won()
		
