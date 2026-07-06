class_name ItemRow
extends PanelContainer

signal pressed(item: Item)
signal hovered

@onready var icon: TextureRect = $HBoxContainer/Icon
@onready var name_label: Label = $HBoxContainer/NameLabel
@onready var pointer: TextureRect = $HBoxContainer/Pointer

var item: Item


func setup(p_item: Item, count: int = 1) -> void:
	item = p_item
	icon.texture = item.icon
	name_label.text = item.item_name if count <= 1 else "%dx %s" % [count, item.item_name]


func _ready() -> void:
	mouse_entered.connect(func(): hovered.emit())
	pointer.visible = false


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pressed.emit(item)


func set_selected(sel: bool) -> void:
	modulate = Color(1.3, 1.3, 1.3) if sel else Color(1, 1, 1)
	
	if sel:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		pointer.visible = true
	else:
		name_label.add_theme_color_override("font_color", Color.BLACK)
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		pointer.visible = false
