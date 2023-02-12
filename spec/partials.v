module spec

import whisker

pub const partial_test = TestList{
	name: 'Partials'
	overview: '
Partials are external templates that can be plugged into the current template.
'
	tests: [
		TestCase{
			name: 'Basic Behaviour'
			desc: 'The greater-than operator should expand to the named partial.'
			template: '"{{>text}}"'
			expected: '"from partial"'
			partials: {
				'text': 'from partial'
			}
		},
		TestCase{
			name: 'Context'
			desc: 'The greater-than operator should operate within the current context.'
			data: {
				'text': whisker.DataModel('content')
			}
			template: '"{{>partial}}"'
			partials: {
				'partial': '*{{text}}*'
			}
			expected: '"*content*"'
		},
		TestCase{
			name: 'Recursion'
			desc: 'The greater-than operator should properly recurse.'
			data: whisker.DataModel({
				'content': 'X'
				'nodes':   whisker.DataModel([
					whisker.DataModel({
						'content': whisker.DataModel('Y')
						'nodes':   []whisker.DataModel{}
					}),
				])
			})
			template: '{{>node}}'
			partials: {
				'node': '{{content}}<{{#nodes}}{{>node}}{{/nodes}}>'
			}
			expected: 'X<Y<>>'
		},
	]
}
