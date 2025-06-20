extends Area2D

var current_scatter_index = 0

@export var speed: float = 120
@export var movement_targets: Resource
@export var tile_map: TileMap
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	if not tile_map:
		push_error("TileMap not assigned to ghost")
	if not movement_targets:
		push_error("MovementTargets resource not assigned to ghost")
	
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 4.0
	navigation_agent_2d.target_reached.connect(on_position_reached)
	
	call_deferred("setup")
	
func _process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		return
	move_ghost(navigation_agent_2d.get_next_path_position(), delta)
	
func move_ghost(next_position: Vector2, delta: float):
	var current_ghost_position = global_position
	var new_velocity = (next_position - current_ghost_position).normalized() * speed
	global_position += new_velocity * delta
	
func setup():
	if tile_map and navigation_agent_2d:
		var nav_map = tile_map.get_navigation_map(0)
		navigation_agent_2d.set_navigation_map(nav_map)
		NavigationServer2D.agent_set_map(navigation_agent_2d.get_rid(), nav_map)
		scatter() # start scattering to the first target
	else:
		push_error("Failed to set up navigation: TileMap or NavigationAgent2D missing")

func scatter():
	if movement_targets:
		var scatter_nodes = movement_targets.get_scatter_targets(self)
		if scatter_nodes.size() > 0 and current_scatter_index < scatter_nodes.size():
			navigation_agent_2d.target_position = scatter_nodes[current_scatter_index].global_position
			print("Moving to scatter target %d at %s" % [current_scatter_index, scatter_nodes[current_scatter_index].global_position])
		else:
			push_warning("No valid scatter targets or index out of range")
	else:
		push_error("MovementTargets resource not assigned")

func on_position_reached():
	if movement_targets:
		var scatter_nodes = movement_targets.get_scatter_targets(self)
		if scatter_nodes.size() == 0:
			push_warning("No scatter targets available")
			return
		if current_scatter_index < scatter_nodes.size() - 1:
			current_scatter_index += 1
		else:
			current_scatter_index = 0
		scatter()
	else:
		push_error("MovementTargets resource not assigned")
