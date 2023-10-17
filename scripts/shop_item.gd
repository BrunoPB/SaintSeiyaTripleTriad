extends Node2D

var card_data : Card
var card_scene = preload("res://scenes/static_card_base.tscn").instantiate()
var buy_card_pop_up_scene = preload("res://scenes/buy_card_pop_up.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	card_scene.card_data = card_data
	$Container/Layout/CardArea.add_child(card_scene)
	$Container/Layout/NameArea/Name.text = card_data.name
	$Container/Layout/PriceArea/Price.text = str(card_data.price())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_buy_button_pressed():
	var bcp = buy_card_pop_up_scene.duplicate()
	bcp.card_data = card_data
	add_child(bcp)
