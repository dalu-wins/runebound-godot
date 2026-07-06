class_name PlayerMovement
extends Node

@export var walk_speed: float = 40.0
@export var sprint_speed: float = 80.0
@export var idle_animation_speed: float = 0.2
@export var walk_animation_speed: float = 1.0
@export var sprint_animation_speed: float = 2.0

var facing: String = "down"
var is_active: bool = true
var _sprint_toggled: bool = false

@onready var player: CharacterBody2D = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"


func process_movement(_delta: float) -> void:
	if not is_active:
		player.velocity = Vector2.ZERO
		player.move_and_slide()
		_update_animation(Vector2.ZERO, false)
		return

	if Input.is_action_just_pressed("sprint"):
		_sprint_toggled = not _sprint_toggled

	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed = sprint_speed if _sprint_toggled else walk_speed
	player.velocity = input_vector * speed
	player.move_and_slide()

	_update_facing(input_vector)
	_update_animation(input_vector, _sprint_toggled)


func _update_facing(input_vector: Vector2) -> void:
	if input_vector == Vector2.ZERO:
		return

	if abs(input_vector.x) >= abs(input_vector.y):
		facing = "right" if input_vector.x > 0 else "left"
	else:
		facing = "down" if input_vector.y > 0 else "up"


func _update_animation(input_vector: Vector2, sprint: bool) -> void:
	var state := "walk" if input_vector != Vector2.ZERO else "idle"
	var anim_name := facing + "_" + state
	
	var animation_speed = idle_animation_speed
	if state == "walk" && !sprint:
		animation_speed = walk_animation_speed * input_vector.length()
	elif state == "walk" && sprint:
		animation_speed = sprint_animation_speed * input_vector.length()
	sprite.speed_scale = animation_speed

	if sprite.animation != anim_name:
		sprite.play(anim_name)
