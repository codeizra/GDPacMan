extends Resource

class_name MovementTargets

@export var scatter_targets: Array[NodePath]
@export var at_home_targets: Array[NodePath]

func get_scatter_targets(owner: Node) -> Array[Node2D]:
	var targets: Array[Node2D] = []
	for path in scatter_targets:
		var node = owner.get_node_or_null(path)
		if node is Node2D:
			targets.append(node)
		else:
			push_warning("Invalid Node2D at path: %s" % path)
	return targets
	
func get_at_home_targets(owner: Node) -> Array[Node2D]:
	var targets: Array[Node2D] = []
	for path in at_home_targets:
		var node = owner.get_node_or_null(path)
		if node is Node2D:
			targets.append(node)
		else:
			push_warning("Invalid Node2D at path: %s" % path)
	return targets
