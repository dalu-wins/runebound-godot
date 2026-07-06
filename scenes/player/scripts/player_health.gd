class_name PlayerHealth
extends Node

signal died
signal heal_signal(current_health: int)
signal damage_signal(current_health: int)

@export var max_hp: int = 100

var _current_hp: int:
	set(value):
		_current_hp = clampi(value, 0, max_hp)
		if _current_hp == 0:
			died.emit()

func _ready() -> void:
	_current_hp = roundi(float(max_hp) / 3)


func take_damage(amount: int) -> void:
	_current_hp -= amount
	damage_signal.emit(_current_hp)


func heal(amount: int) -> void:
	_current_hp += amount
	heal_signal.emit(_current_hp)


func get_current_hp() -> int:
	return _current_hp
