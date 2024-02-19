extends Node2D


signal joke_completed(is_correct: bool)


const JOKES = [
	["Van dos y...", "se cae el de enmedio."],
	["Me sacaron del grupo de WhatsApp de paracaidismo.", "Se ve que no caía bien."],
	["¿Sabes cuánta leche da una vaca en su vida?", "Pues la misma que en bajada."],
	["¿Cuál es el colmo de un peluquero?", "Descubrir que en la vida nada es permanente."],
	["¿Qué le dice un jardinero a otro?", "Seamos felices mientras podamos."],
	["Eliminar correos no deseados es muy fácil:", "spam comido."],
	["¿Cómo se llama el hermano vegano de Bruce Lee?", "Broco Lee."],
	["¿Qué dice una cereza mirándose al espejo?", "\"¿Ceré eza?\"."],
	["¿Cuál es el peinado favorito de los carteros?", "Los tirabuzones."],
	["¿Qué hace un tupper en el bosque?", "Tupperdío."],
	["¿Cuál es el colmo de una azafata?", "Enamorarse del piloto automático."],
	["¿Cómo se llama el hermano más limpio de Bruce Willis?", "Kevin Willis."],
	["¿Cuáles eran los dibujos animados preferidos del capitán del Titanic?", "Timón y PUMBA."],
	["¿De qué murió Jack Sparrow?", "De un disparrow."],
	["¿Cómo se les llama a 2 zombis que hablan distintas lenguas?", "Zombilingües."],
	["¿Cómo se despiden los químicos?", "Ácido un gusto."],
	["Una vez conté un chiste químico,", "pero no hubo reacción."],
	["¿Cómo queda un mago después de comer?", "Magordito."],
	["Un león se comió un jabón.", "Y ahora es puma."],
	["¿Por qué las focas del circo miran siempre hacia arriba?", "Porque es dónde están los focos."],
	["¿Sabes por qué el mar es azul?", "Porque los peces dicen \"Blue, blue, blue blue\"."],
]
var current_joke_i: int


@onready var joke_option_scene: PackedScene = preload("res://joke_option.tscn")
const N_JOKE_OPTIONS: int = 3
const JOKE_POSITIONS: Array[Vector2] = [
	Vector2(210, 190),
	Vector2(470, 190),
	Vector2(730, 190)
]
var joke_option_instances: Array[JokeOption]


# Called when the node enters the scene tree for the first time.
func _ready():
	select_new_joke()


func select_new_joke():
	current_joke_i = randi() % len(JOKES)
	get_node("Bubble/Label").set_text(JOKES[current_joke_i][0])
	spawn_joke_options()


func spawn_joke_options():
	destroy_joke_options()
	var correct_option_i: int = randi() % N_JOKE_OPTIONS
	for i in N_JOKE_OPTIONS:
		var instance: JokeOption = joke_option_scene.instantiate()
		add_child(instance)
		joke_option_instances.append(instance)
		if i == correct_option_i:
			instance.set_text(JOKES[current_joke_i][1])
			instance.set_is_correct_option()
		else:
			var incorrect_joke_i = randi() % len(JOKES)
			while incorrect_joke_i == current_joke_i:
				incorrect_joke_i = randi() % len(JOKES)
			instance.set_text(JOKES[incorrect_joke_i][1])
		instance.set_position(JOKE_POSITIONS[i])


func destroy_joke_options():
	for instance in joke_option_instances:
		instance.queue_free()
	joke_option_instances.clear()


func _on_option_selected(is_correct_option: bool):
	select_new_joke()
	emit_signal("joke_completed", is_correct_option)
