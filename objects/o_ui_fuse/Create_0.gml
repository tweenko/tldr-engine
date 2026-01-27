items = [
	{
		result: new item_revivemint(),
		ingredients: [
			new item_lightcandy(),
			new item_a_silvercard()
		],
	},
	{
		result: new item_revivemint(),
		ingredients: [
			new item_lightcandy(),
			new item_a_silvercard()
		],
	},
	{
		result: new item_cellphone(),
		ingredients: [
			new item_darkcandy(),
			new item_lightcandy()
		],
	},
	{
		result: new item_revivemint(),
		ingredients: [
			new item_lightcandy(),
			new item_a_silvercard()
		],
	},
]

exists = []
for (var i = 0; i < array_length(items); ++i) {
	var s = {
		result: false,
		ingredients: []
	}
	var a = true
	
	for (var j = 0; j < array_length(items[i].ingredients); ++j) {
		var c = item_contains(items[i].ingredients[j]) != undefined
		array_push(s.ingredients, c)
		if a 
			a = c
	}
	s.result = a
	
	array_push(exists, s)
}

selection = 0
soulx = 110-30
souly = 190 + 100*selection % 2
confirmation = 0
c_selection = 0
buffer = 0

alarm[0] = 1