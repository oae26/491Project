extends Area2D

signal switch_activated

@export var is_active: bool = false
@export var active_sprite: Texture
@export var inactive_sprite: Texture

@onready var sprite = $Sprite2D

func _ready() -> void:
	update_sprite()

func _on_body_entered(body: Node) -> void:
	print("Collision detected with:", body.name)
	if body.is_in_group("spores") and not is_active:
		is_active = true
		update_sprite()
		emit_signal("switch_activated")
		body.destroy()  # Destroy the spore after activating the switch

func update_sprite() -> void:
	if active_sprite and inactive_sprite:
		sprite.texture = active_sprite if is_active else inactive_sprite
