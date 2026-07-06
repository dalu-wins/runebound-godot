class_name HealthItem
extends Item

@export var heal_amount: int = 20

func use(user: Node) -> bool:
	var health := user.get_node("Components/PlayerHealth") as PlayerHealth
	if health == null:
		return false

	health.heal(heal_amount)
	return true
	

func get_id() -> int:
	return hash([item_name, icon, description, heal_amount])


func get_heal_preview() -> int:
	return heal_amount
