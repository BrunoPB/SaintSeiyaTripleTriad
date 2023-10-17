extends Control

@onready var player = get_node("/root/Player")
var home_scene = preload("res://scenes/home_menu.tscn").instantiate()
var shop_scene = preload("res://scenes/shop_menu.tscn").instantiate()
var deck_scene = preload("res://scenes/deck_menu.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Layout/Header/HeaderInfos/CoinsMargin/CoinsAnim.play()
	update_data()
	update_scene(home_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_data():
	$Layout/Header/HeaderInfos/CoinsMargin/Coins.text = str(player.coins) + " coins"
	$Layout/Header/HeaderInfos/CardsMargin/NofCards.text = str(player.cards.size()) + " cards"

func update_scene(scene):
	delete_children($Layout/Content)
	$Layout/Content.add_child(scene.duplicate())

func _on_shop_button_pressed():
	unpress_buttons()
	$Layout/Footer/FooterLayout/ShopButton.button_pressed = true
	update_scene(shop_scene)

func _on_home_button_pressed():
	unpress_buttons()
	$Layout/Footer/FooterLayout/HomeButton.button_pressed = true
	update_scene(home_scene)

func _on_deck_button_pressed():
	unpress_buttons()
	$Layout/Footer/FooterLayout/DeckButton.button_pressed = true
	update_scene(deck_scene)

func unpress_buttons():
	for btn in $Layout/Footer/FooterLayout.get_children():
		btn.button_pressed = false

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
