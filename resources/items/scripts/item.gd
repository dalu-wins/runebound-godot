class_name Item
extends Resource

@export var item_name: String = "Unnamed Item"
@export var icon: Texture2D
@export_multiline var description: String = ""

func use(_user: Node) -> bool:
	push_warning("use() was not defined for: " + item_name)
	return false


func get_id() -> int:
	push_warning("get_id() was not defined for: " + get_script().get_global_name())
	return hash([item_name, icon, description])


func get_heal_preview() -> int:
	return 0
