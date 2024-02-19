class_name ThrowableObject extends RigidBody2D


enum Type {TOMATO, ROSE}


signal player_hit(type: Type)


var type: Type
var throw_direction: Vector2
var throw_force: float


@onready var sprite: Sprite2D = get_node("Sprite")
@onready var tomato_texture: Resource = preload("res://Art/tomato.png")
@onready var tomato_floor_texture: Resource = preload("res://Art/tomato_floor.png")
@onready var rose_texture: Resource = preload("res://Art/rose.png")


func init(object_type: Type, thrown_from_right: bool, spawn_position: Vector2):
	type = object_type
	set_position(spawn_position)
	throw_force = randf_range(1000.0, 1300.0)
	var throw_angle: float = randf_range(10, 20) * (-1 if thrown_from_right else 1)
	throw_direction = Vector2.UP.rotated(deg_to_rad(throw_angle))


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("player_hit", Callable(get_parent(), "_on_player_hit"))
	if type == Type.TOMATO:
		sprite.texture = tomato_texture
	elif type == Type.ROSE:
		sprite.texture = rose_texture
	apply_impulse(throw_direction * throw_force)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_hit", type)
		queue_free()
	else:
		if type == Type.TOMATO:
			sprite.texture = tomato_floor_texture
		set_deferred("freeze", true)
		_vanish()


func _vanish():
	await get_tree().create_timer(2.0).timeout
	queue_free()
