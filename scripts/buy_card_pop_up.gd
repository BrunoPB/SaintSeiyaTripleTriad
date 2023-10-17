extends CanvasLayer

var card_data : Card
var card_scene = preload("res://scenes/static_card_base.tscn").instantiate()
@onready var player = get_node("/root/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	card_scene.card_data = card_data
	$PopUp/Layout/CardArea.add_child(card_scene)
	$PopUp/Layout/Title.text = "Buy " + card_data.name + " for " + str(card_data.price()) + " coins?"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cancel_pressed():
	get_tree().paused = false
	queue_free()


func _on_buy_pressed():
	if player.can_buy(card_data):
		get_tree().paused = false
		player.buy_card(card_data)
		var main_menu = get_node("/root/MainMenu")
		main_menu.update_data()
		var shop_menu = get_node("/root/MainMenu/Layout/Content/ShopMenu")
		shop_menu.update_all()
		queue_free()
