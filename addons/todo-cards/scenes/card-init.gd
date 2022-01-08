tool
extends PanelContainer

onready var line_edit = get_node('HBox/LineEdit') as LineEdit
onready var add_button = get_node('../AddButton') as Button

func _ready() -> void:
	line_edit.connect('text_changed', self, '_on_text_changed')
	line_edit.connect('text_entered', self, '_on_line_edit_text_entered')
	get_node('HBox/XButton').connect('pressed', self, '_on_xbutton_pressed')
	hide()
#<END>

func _on_text_changed(_text: String) -> void:
	line_edit.get_node('Hint').visible = false if _text.length() > 0 else true
#<END>

func _on_line_edit_text_entered(_text: String) -> void:
	line_edit.select(0, 0)
	line_edit.release_focus()
	add_button.emit_signal('pressed')
#<END>

func _on_xbutton_pressed()-> void:
	line_edit.text = ''
	line_edit.get_node('Hint').show()
	hide()
#<END>
