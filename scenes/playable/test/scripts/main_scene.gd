extends Node

@onready var player: CharacterBody2D = $Player
@onready var inventory_ui: Control = $UILayer/InventoryUI
@onready var health_ui: PanelContainer = $UILayer/HealthUI

func _ready() -> void:
	var inventory := player.get_node("Components/PlayerInventory") as PlayerInventory
	inventory_ui.setup(inventory)
	inventory_ui.hide()
	
	var health := player.get_node("Components/PlayerHealth") as PlayerHealth
	health_ui.setup(health, inventory_ui)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = not inventory_ui.visible
		player.enable_movement(not inventory_ui.visible)
		inventory_ui.focus_first_row()
	
	if event.is_action_pressed("back"):
		inventory_ui.visible = false
		player.enable_movement(true)
