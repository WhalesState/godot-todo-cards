tool
extends ScrollContainer

var card_scene = preload('res://addons/todo-cards/scenes/todo-card.tscn') as PackedScene

onready var add_card_button = get_node('Cards/AddCard/AddButton') as Button
onready var card_init = get_node('Cards/AddCard/CardInit') as PanelContainer
onready var todo_cards = get_node('../../../') as Control

func _ready() -> void:
	add_card_button.connect('pressed', self, '_on_add_card_button_pressed')
#<END>

func add_card(_data := {})-> void:
	var _card = card_scene.instance()
	_card.data = _data
	var _add_card = $Cards/AddCard as VBoxContainer
	$Cards.add_child(_card)
	$Cards.move_child(_add_card, $Cards.get_child_count() - 1)
#<END>

func delete_card(_card: PanelContainer)-> void:
	$Cards.remove_child(_card)
	_card.queue_free()
#<END>

func get_data() -> Array:
	var _data = []
	for _child in $Cards.get_children():
		if _child is PanelContainer:
			_data.append(_child.get_card_data())
	return _data
#<END>

func free_cards() -> void:
	for _child in $Cards.get_children():
			if _child is PanelContainer:
				$Cards.remove_child(_child)
				_child.queue_free()
#<END>

func _on_add_card_button_pressed()-> void:
	if !card_init.visible:
		card_init.show()
		card_init.line_edit.grab_focus()
	else:
		var _line_edit = card_init.get_node('HBox/LineEdit') as LineEdit
		if _line_edit.text.length() > 0:
			add_card({'label': _line_edit.text, 'flags': [todo_cards.random_color()]})
			_line_edit.text = ''
			_line_edit.get_node('Hint').show()
			card_init.hide()
			add_card_button.grab_focus()
#<END>


