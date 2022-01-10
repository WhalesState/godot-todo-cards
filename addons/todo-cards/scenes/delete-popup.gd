tool
extends WindowDialog

var card_to_delete : PanelContainer
var card_name := ''

onready var info = get_node('VBox/Info') as Label
onready var yes_button = get_node('VBox/HBox/Yes') as Button
onready var no_button = get_node('VBox/HBox/No') as Button
onready var cards_container = get_node('../HBox/VBox/CardsContainer') as ScrollContainer

func _ready() -> void:
	connect('about_to_show', self, '_on_about_to_show')
	yes_button.connect('pressed', self, '_on_confirm', [true])
	no_button.connect('pressed', self, '_on_confirm', [false])
#<END>

func _on_about_to_show()-> void:
	info.text = 'Are you sure you want to delete "%s" card ?' % card_name
	yes_button.call_deferred('grab_focus')
#<END>

func _on_confirm(_delete: bool) -> void:
	if _delete:
		cards_container.delete_card(card_to_delete)
	hide()
#<END>