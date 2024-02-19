extends Node2D


const TIME_LIMIT: int = 1 * 60
@onready var time_remaining: int = 0
@onready var time_remaining_label: Label = get_node("TimeRemaining")

var score: int = 0
@onready var score_label: Label = get_node("Score")


var throwable_object_scene: PackedScene = preload("res://throwable_object.tscn")
@onready var RIGHT_SPAWNS: Array[Node2D] = [
	get_node("ThrowableObjectsSpawns/Right1"),
	get_node("ThrowableObjectsSpawns/Right2"),
	get_node("ThrowableObjectsSpawns/Right3"),
]
@onready var LEFT_SPAWNS: Array[Node2D] = [
	get_node("ThrowableObjectsSpawns/Left1"),
	get_node("ThrowableObjectsSpawns/Left2"),
	get_node("ThrowableObjectsSpawns/Left3"),
]


var game_over_scene: PackedScene = preload("res://game_over.tscn")


func add_score(value: int):
	score += value
	if score < 0:
		score = 0
	score_label.set_text(str("Puntos:     ", score))


func spawn_throwable_object(type: ThrowableObject.Type):
	var thrown_from_right: bool
	var spawn_position: Vector2
	if randi() % 2 == 0:
		thrown_from_right = true
		spawn_position = RIGHT_SPAWNS[randi() % len(RIGHT_SPAWNS)].global_position
	else:
		thrown_from_right = false
		spawn_position = LEFT_SPAWNS[randi() % len(LEFT_SPAWNS)].global_position
	
	var throwable_object: ThrowableObject = throwable_object_scene.instantiate()
	throwable_object.init(type, thrown_from_right, spawn_position)
	add_child(throwable_object)


# Called when the node enters the scene tree for the first time.
func _ready():
	add_score(0)
	_add_time_remaining(TIME_LIMIT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("test_throw_object"):
		#spawn_throwable_object()
	pass


func _on_joke_system_joke_completed(is_correct):
	if is_correct:
		add_score(100)
		spawn_throwable_object(ThrowableObject.Type.ROSE if randi() % 2 == 0 else ThrowableObject.Type.TOMATO)
		get_node("Player").react(is_correct)
	else:
		add_score(-50)
		if randi() % 5 == 0:
			spawn_throwable_object(ThrowableObject.Type.ROSE)	# para animar
		get_node("Player").react(is_correct)


func _add_time_remaining(value: int):
	time_remaining += value
	if time_remaining < 0:
		_game_over()
	var min: int = time_remaining / 60
	var s: int = time_remaining - (min * 60)
	time_remaining_label.set_text(str("Tiempo:     ", min, ":", str(s).pad_zeros(2)))


func _on_seconds_timer_timeout():
	_add_time_remaining(-1)


func _on_player_hit(type: ThrowableObject.Type):
	if type == ThrowableObject.Type.TOMATO:
		add_score(-15)
		# cambiar sprite jugador
	elif type == ThrowableObject.Type.ROSE:
		# cambiar sprite jugador
		add_score(15)


func _game_over():
	get_node("SecondsTimer").stop()
	time_remaining_label.set_text("¡SE ACABÓ!")
	var game_over_instance: GameOver = game_over_scene.instantiate()
	game_over_instance.set_final_score(score)
	get_tree().root.add_child(game_over_instance)
	get_tree().current_scene = game_over_instance
	queue_free()
