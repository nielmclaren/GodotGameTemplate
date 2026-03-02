extends Node


func get_descendants_by_type(root: Node, type: Variant) -> Array[Node]:
	var result: Array[Node]
	var frontier: Array[Node] = root.get_children()
	while !frontier.is_empty():
		var child: Node = frontier.pop_back()
		if is_instance_of(child, type):
			result.append(child)

		else:
			frontier.append_array(child.get_children())

	return result


func get_ancestor_by_type(node: Node, type: Variant) -> Node:
	var frontier: Node = node.get_parent()
	while frontier and !is_instance_of(frontier, type):
		frontier = frontier.get_parent()
	return frontier


func string_to_vector2(value: String) -> Vector2:
	var parts: PackedStringArray = value.substr(1, value.length() - 2).split(", ")
	return Vector2(float(parts[0]), float(parts[1]))
