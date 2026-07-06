class_name HealthUI
extends PanelContainer

var health : PlayerHealth

@onready var hp_bar : ProgressBar = $HPBar
@onready var preview_bar : ProgressBar = $HealPreviewBar

func setup(p_health: PlayerHealth, inventory_ui: InventoryUI) -> void:
	health = p_health
	health.heal_signal.connect(_on_health_changed)
	health.damage_signal.connect(_on_health_changed)
	inventory_ui.selection_changed.connect(_on_selection_changed)
	preview_bar.hide()
	_refresh()


func _on_health_changed(_new_health: int):
	_refresh()


func _refresh():
	hp_bar.max_value = health.max_hp
	hp_bar.value = health.get_current_hp()


func _on_selection_changed(item: Item) -> void:
	if item == null or item.get_heal_preview() <= 0:
		preview_bar.hide()
		return

	var projected := mini(health.get_current_hp() + item.get_heal_preview(), health.max_hp)

	preview_bar.max_value = health.max_hp
	preview_bar.value = projected
	preview_bar.show()
