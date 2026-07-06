extends CharacterBody2D

@onready var movement: PlayerMovement = $Components/PlayerMovement
@onready var inventory: PlayerInventory = $Components/PlayerInventory
@onready var health: PlayerHealth = $Components/PlayerHealth
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	inventory.use_item_signal.connect(_on_item_use)

	# Testweise ein paar Items reinpacken
	for item_name in ["fruit_salad", "kiwi", "strawberry", "banana", "orange"]:
		for i in range(0, randi() % 3 + 1):
			var item: Item = load("res://resources/items/" + item_name + ".tres").duplicate()
			inventory.add_item(item)


func _on_item_use(item: Item) -> void:
	if item.use(self):
		inventory.remove_item(item)


func _physics_process(delta: float) -> void:
	movement.process_movement(delta)
	

func enable_movement(is_active: bool):
	movement.is_active = is_active
	
