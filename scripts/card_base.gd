extends Node2D

var card_data : Card

# Called when the node enters the scene tree for the first time.
func _ready():
	var image = load("res://assets/card_images/" + card_data.file_path)
	$Card/Image.set_texture(image)
	$Card/ValuesHContainer/West.text = str(card_data.west)
	$Card/ValuesHContainer/East.text = str(card_data.east)
	$Card/ValuesHContainer/VBoxContainer/North.text = str(card_data.north)
	$Card/ValuesHContainer/VBoxContainer/South.text = str(card_data.south)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

# For SlotCardBase only
func _on_slot_area_mouse_entered():
	get_node("/root/MainMenu/Layout/Content/DeckMenu").target_card = self
