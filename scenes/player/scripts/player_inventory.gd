class_name PlayerInventory
extends Node

signal use_item_signal(item: Item)
signal remove_item_signal(item: Item)
signal add_item_signal(item: Item)

var _items: Array[Item] = []

func add_item(item: Item) -> bool:
	_items.append(item)
	add_item_signal.emit(item)
	return true


func remove_item(item: Item) -> bool:
	var index := _items.find(item)
	if index == -1:
		return false

	_items.remove_at(index)
	remove_item_signal.emit(item)
	return true


func use_item(item: Item) -> void:
	if not _items.has(item):
		return
	use_item_signal.emit(item)


func has_item(item: Item) -> bool:
	return _items.has(item)


func get_items() -> Array[Item]:
	return _items.duplicate()
