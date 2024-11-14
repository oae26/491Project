extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var screen_size
var current_block: Node = null
var npc: Node = null  # New variable to track NPC in range

@onready var game = get_tree().get_root().get_node("Game")
@onready var SPORE = load("res://scenes/spore.tscn")
@onready var sporeTimer = $SporeTimer
@onready var area2d = $Area2D
@onready var npc_area2d = $Area2NPC  # New Area2D for NPCs

# Track the last movement direction (-1 for left, 1 for right)
var last_direction = 1

func _ready():
	screen_size = get_viewport_rect().size
	area2d.body_entered.connect(_on_Area2D_body_entered)
	area2d.body_exited.connect(_on_Area2D_body_exited)
	
func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle movement/deceleration
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.play()
		
		last_direction = sign(direction)
		$AnimatedSprite2D.flip_h = (last_direction == -1)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.flip_h = (last_direction == -1)

	# Block breaking
	if Input.is_action_just_pressed("break_block") and current_block:
		current_block.destroy_block()

	# Spore launching
	if Input.is_action_just_pressed("spore_launch") and sporeTimer.get_time_left() == 0:
		launch_spore()

	# NPC interaction
	if Input.is_action_just_pressed("interact") and npc:
		trigger_dialogue(npc)

	move_and_slide()

# Function to trigger dialogue with the NPC
func trigger_dialogue(npc_node: Node) -> void:
	var dialogue_box = preload("res://scenes/dialogue.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)
	dialogue_box.dialogue_lines = npc_node.dialogue_lines

# Area2D signals for blocks
func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("blocks"):
		current_block = body

		var callable_on_block_destroyed = Callable(self, "_on_block_destroyed")
		if not current_block.is_connected("block_broken", callable_on_block_destroyed):
			current_block.connect("block_broken", callable_on_block_destroyed)

func _on_Area2D_body_exited(body: Node) -> void:
	if body == current_block:
		current_block = null

# Area2D signals for NPCs


func launch_spore():
	var spore = SPORE.instantiate()
	spore.dir = rotation
	spore.spawnPos = global_position
	spore.spawnRot = rotation
	game.add_child.call_deferred(spore)
	sporeTimer.start()
