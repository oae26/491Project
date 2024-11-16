# FadeTransition.gd
extends CanvasLayer

@export var fade_speed: float = 1.0
@onready var color_rect = $ColorRect

func fade_out(callback: Callable):
	color_rect.modulate.a = 0
	color_rect.visible = true
	color_rect.create_tween().tween_property(color_rect, "modulate:a", 1, fade_speed).as_callable(callback).call_deferred()

func fade_in():
	color_rect.create_tween().tween_property(color_rect, "modulate:a", 0, fade_speed)
	color_rect.visible = false
