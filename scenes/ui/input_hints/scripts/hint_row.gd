class_name HintRow
extends PanelContainer


@export var icon : Texture2D = preload("res://sprites/ui/input_controller1.png")
@export var text : String = "Input"

@onready var texture: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label

func _ready() -> void:
	texture.texture = icon
	label.text = text
