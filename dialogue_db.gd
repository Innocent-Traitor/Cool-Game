extends Node
class_name Dialogue_DB


## scene_identifier {
##  talk_index: {
##    'character': The internal character identifier string (NOT NUMBER ID)
##    'text': Text to display
##    'vars': Variables to insert into the text <- TODO
##    'options': Additional options to use when displaying text <- NOTE: Dunno if I'll use this
##


const DIALOGUE_DB = {
	'scene_1': {
		0: {
			'character': 'Placeholder',
			'text': 'The quick brown fox jumped over the lazy dog.'
		},
		1: {
			'character': 'Placeholder',
			'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu'
		},
		2: {
			'character': 'Placeholder',
			'text': '[b]Bold[/b]  [i]Italics[/i]  [b][i]Bold Italics[/i][/b]  [u]Underline[/u]  [s]Strikethrough[/s]  [url=https://www.moonsoftstudios.com]URL[/url]  [img=32x32]res://icon.svg[/img]\n [color=#00beef]Colored[/color]  [bgcolor=#00beef]BGColored[/bgcolor]  [fgcolor=#00beef]FGColored[/fgcolor]  [outline_size=2][outline_color=#00beef]Outline[/outline_color][/outline_size]'
		},
		3: {
			'character': 'Placeholder',
			'text': '[pulse]Pulse[/pulse]  [wave]Wave[/wave]  [tornado]Tornado[/tornado]  [shake]Shake[/shake]  '
		},
        4: {
            'character': 'Placeholder',
            'text': 'Hello %s, there are %d enemies outside!',
            'vars': ['Joe', 10]
        }
	}
}

const CHARACTER_DB = {
    'Placeholder': {
        'name': 'Adachi Rei',
        'id': 0,
        'portrait': 'res://sprites/frame1.png'
    },
}