extends Node2D

var card_data : Card
var card_scene = preload("res://scenes/deck_drag_card_base.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	card_scene.card_data = card_data
	$Container/Layout/CardArea.add_child(card_scene)
	$Container/Layout/NameArea/Name.text = card_data.name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
