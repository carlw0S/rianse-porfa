extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var reaction_good_texture: Resource = preload("res://Art/reaccion bien.png")
@onready var reaction_bad_texture: Resource = preload("res://Art/reaccion mal.png")


@onready var sprite: Sprite2D = get_node("Sprite")
@onready var reaction_sprite: Sprite2D = get_node("Reaction")
@onready var reaction_timer: Timer = get_node("ReactionTimer")


func react(is_correct: bool):
	if is_correct:
		reaction_sprite.texture = reaction_good_texture
		reaction_sprite.position = Vector2(70, -80)
	else:
		reaction_sprite.texture = reaction_bad_texture
		reaction_sprite.position = Vector2(-70, -80)
	reaction_sprite.visible = true
	reaction_timer.start()


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0 and not sprite.flip_h:
			sprite.flip_h = true
		elif direction > 0 and sprite.flip_h:
			sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_reaction_timer_timeout():
	reaction_sprite.visible = false
