tool
extends TextEdit

const _lcreg := [
	['!', Color('FF2D00')],
	['$', Color('3498DB')],
	['#', Color('474747')],
	['@', Color('FF8C00')],
	['*', Color('98C379')]
]

const _rcreg := [
	['"', '"', Color('EBD76F')],
	['(', ')', Color('6772EF')],
	['[', ']', Color('CD67EF')],
	['<', '>', Color('EF67A9')]
]

func _ready() -> void:
	minimap_draw = true
	connect('focus_exited', self, '_on_focus_exit')
	for arr in _lcreg:
		add_color_region(arr[0], arr[0], arr[1], true)
	for arr in _rcreg:
		add_color_region(arr[0], arr[1], arr[2])
#<END>

func _on_focus_exit()-> void:
	select(0, 0, 0, 0)
	release_focus()
#<END>


	
