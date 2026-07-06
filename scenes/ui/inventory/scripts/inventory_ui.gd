class_name InventoryUI
extends Control

const ITEM_ROW_SCENE := preload("res://scenes/ui/inventory/item_row.tscn")
const NAVIGATION_COOLDOWN := 0.15

signal selection_changed(item: Item)

@onready var grid: GridContainer = $PanelContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var scroll_container: ScrollContainer = $PanelContainer/VBoxContainer/ScrollContainer

var inventory: PlayerInventory
var _rows: Array[ItemRow] = []
var _selected_index: int = 0

var _navigation_timer: float = 0.0

func setup(p_inventory: PlayerInventory) -> void:
	inventory = p_inventory
	inventory.add_item_signal.connect(_on_inventory_changed)
	inventory.remove_item_signal.connect(_on_inventory_changed)
	_refresh()


func _on_inventory_changed(_item: Item) -> void:
	_refresh()


func _refresh() -> void:
	for child in grid.get_children():
		child.queue_free()

	_rows.clear()
	var grouped := _group_items(inventory.get_items())

	for group in grouped.values():
		var row: ItemRow = ITEM_ROW_SCENE.instantiate()
		grid.add_child(row)
		row.setup(group.item, group.count)
		row.hovered.connect(_on_row_hovered.bind(_rows.size()))
		row.pressed.connect(_on_item_row_pressed)
		_rows.append(row)

	_selected_index = clampi(_selected_index, 0, max(_rows.size() - 1, 0))
	_update_selection_visual()


func _group_items(items: Array[Item]) -> Dictionary:
	var grouped := {}

	for item in items:
		var id = item.get_id()
		if grouped.has(id):
			grouped[id].count += 1
		else:
			grouped[id] = { "item": item, "count": 1 }

	return grouped


func _unhandled_input(event: InputEvent) -> void:
	if not visible or _rows.is_empty():
		selection_changed.emit(null)
		return

	if event.is_action_pressed("ui_accept"):
		_use_selected()


func _process(delta: float) -> void:
	if not visible:
		selection_changed.emit(null)
		return

	_navigation_timer -= delta

	if _navigation_timer <= 0.0:
		var direction := Input.get_axis("ui_up", "ui_down")
		if direction != 0:
			_move_selection(1 if direction > 0 else -1)
			_navigation_timer = NAVIGATION_COOLDOWN


func _move_selection(direction: int) -> void:
	_selected_index = wrapi(_selected_index + direction, 0, _rows.size())
	_update_selection_visual()


func _on_row_hovered(index: int) -> void:
	_selected_index = index
	_update_selection_visual()


func _update_selection_visual() -> void:
	for i in _rows.size():
		_rows[i].set_selected(i == _selected_index)
	
	if _rows.size() > 0:
		selection_changed.emit(_rows[_selected_index].item)
		scroll_container.ensure_control_visible(_rows[_selected_index])
	else:
		selection_changed.emit(null)


func _use_selected() -> void:
	inventory.use_item(_rows[_selected_index].item)
	_update_selection_visual()


func focus_first_row() -> void:
	_selected_index = 0
	_update_selection_visual()
	scroll_container.scroll_vertical = 0


func _on_item_row_pressed(item: Item) -> void:
	inventory.use_item(item)
	_update_selection_visual()
