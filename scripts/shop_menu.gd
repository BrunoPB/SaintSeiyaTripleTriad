extends Node2D

var card_list : Array = Array()
var card_scene = preload("res://scenes/shop_item.tscn").instantiate()
@onready var cards_data = get_node("/root/CardsData")
@onready var player = get_node("/root/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	update_all()

func start_data():
	card_list = []
	card_list.append_array(cards_data.data.filter(func(c):
		return not player.cards.has(c)
		))
	card_list.sort_custom(
		func(c1,c2):
			return c1.price() < c2.price()
	)

func build_list_gui():
	delete_children($Container/Scroll/ScrollOffset/List)
	for card in card_list:
		var control = Control.new()
		var inst = card_scene.duplicate()
		inst.card_data = card
		control.add_child(inst)
		$Container/Scroll/ScrollOffset/List.add_child(control)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_all():
	start_data()
	build_list_gui()

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
