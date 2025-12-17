extends Node














func _stamps(): pass
var stamps = {
	# HECHO ///////////////////////////////
	"Ascendant Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(32, 0),
		"plata": "<#b1911a>10",
		"chance": 3,  # algo menos común
		"titulo": "<#a13895>Ascendant <#296e8f>Stamp",
		"descripcion": "Increases the Domino's value by <#296e8f>+2 every time it falls.",
		"descripcion_corta": "Perma <#296e8f>+2. \n<#296e8f>(now <#296e8f>: <#296e8f>",
	},
	
	# HECHO ///////////////////////////////
	"Double Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(48, 0),
		"plata": "<#b1911a>10",
		"chance": 3,  # algo menos común
		"titulo": "<#238c73>Double <#296e8f>Stamp",
		"descripcion": "Allows the Domino to have an extra arrow/child.",
		"descripcion_corta": "Extra arrow/child.",
	},
	
	# HECHO ///////////////////////////////
	"Stone Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(64, 0),
		"plata": "<#b1911a>10",
		"chance": 3,  # algo menos común
		"titulo": "<#5e5e5e>Stone <#296e8f>Stamp",
		"descripcion": "The Domino is considered any color.",
		"descripcion_corta": "Any color.",
	},
	
	# HECHO ///////////////////////////////
	"Gold Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(80, 0),
		"plata": "<#b1911a>10",
		"chance": 3,  # algo menos común
		"titulo": "<#b1911a>Gold <#296e8f>Stamp",
		"descripcion": "The Domino <#296e8f>gives <#b1911a>5c when used.",
		"descripcion_corta": "<#296e8f>Gives <#b1911a>5c.",
	},
	
	# HECHO ///////////////////////////////
	"Silver Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(96, 0),
		"plata": "<#b1911a>10",
		"chance": 3,  # algo menos común
		"titulo": "<#5e5e5e>Silver <#296e8f>Stamp",
		"descripcion": "The Domino <#296e8f>gives <#b1911a>3c when used.",
		"descripcion_corta": "<#296e8f>Gives <#b1911a>3c.",
	},
	
	# HECHO ///////////////////////////////
	"Bronze Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(112, 0),
		"plata": "<#b1911a>10",
		"chance": 3,  # algo menos común
		"titulo": "<#b57b4e>Bronze <#296e8f>Stamp",
		"descripcion": "The Domino <#296e8f>gives <#b1911a>1c when used.",
		"descripcion_corta": "<#296e8f>Gives <#b1911a>1c.",
	},
	
	# HECHO ///////////////////////////////
	"Obsidian Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(128, 0),
		"plata": "<#b1911a>10",
		"chance": 3,  # algo menos común
		"titulo": "<#3b3b3b>Obsidian <#296e8f>Stamp",
		"descripcion": "When used, Duplicates chances of this color in the next play.",
		"descripcion_corta": "Duplicates chances of this color.",
	},
	
	# HECHO ///////////////////////////////
	"Emerald Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(144, 0),
		"plata": "<#b1911a>10",
		"chance": 3,  # algo menos común
		"titulo": "<#6cc47a>Emerald <#296e8f>Stamp",
		"descripcion": "Each time the Domino is used, <#296e8f>gives the amount of Dominos of the same color in <#b1911a>coins.",
		"descripcion_corta": "<#b1911a>+1c per same color.",
	},
	
	# HECHO ///////////////////////////////
	"Amethyst Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(160, 0),
		"plata": "<#b1911a>10",
		"chance": 3,  # algo menos común
		"titulo": "<#b48edc>Amethyst <#296e8f>Stamp",
		"descripcion": "When used, <#296e8f>adds a temporary <#e0483e>x.5 to the score of Dominos of the same color.",
		"descripcion_corta": "Same color <#e0483e>x.5.",
	},
	
	# HECHO ///////////////////////////////
	"Diamond Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(176, 0),
		"plata": "<#b1911a>10",
		"chance": 3,  # algo menos común
		"titulo": "<#296e8f>Diamond <#296e8f>Stamp",
		"descripcion": "<#e0483e>Multiplies <#e0483e>by <#e0483e>3 the coins obtained by the dominos that share color with this one.",
		"descripcion_corta": "Same color, Coins <#e0483e>x3.",
	},
	
	# HECHO ///////////////////////////////
	"Quartz Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(192, 0),
		"plata": "<#b1911a>10",
		"chance": 3,  # algo menos común
		"titulo": "<#e6c3e6>Quartz <#296e8f>Stamp",
		"descripcion": "Each time it is used, <#296e8f>adds a small random effect of <#b1911a>+5c or <#296e8f>+5 points.",
		"descripcion_corta": "Random <#b1911a>+5c or <#296e8f>+5pts.",
	},
	
	# HECHO ///////////////////////////////
	"God Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(208, 0),
		"plata": "<#b1911a>10",
		"chance": 1,  # algo menos común
		"titulo": "<r;1e90ff;00b7ff;66d9ff>God <#296e8f>Stamp",
		"descripcion": "Each time this Domino is used, it <#296e8f>adds the <#296e8f>score given by the strongest domino before this one.", # \n<#296e8f>(null)",
		"descripcion_corta": "Copies strongest's <#296e8f>score.",
	},
}





# padre es 0 significa que puede ser padre o hijo, si es 1 solo puede ser hijo, si es 2 solo puede ser padre, si es 3 puede ser padre extra.
func _dominos_especiales(): pass
var dominos_especiales = {
	# HECHO ///////////////////////////////
	"Bomb" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 3,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(208, 0),
				"flechitas" : ["↖", "↗", "↘", "↙"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 0.5,
				"puntaje_siguiente": 0,
				"puntaje": 10,
				"padre" : 0,
				"plata": "<#b1911a>10",
				"venta": "<#b1911a>10",
				"BG": Vector2(48, 192),
				"titulo": "<#238c73>Bomb",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "This domino <#e0483e>Explodes when it falls knocking over other dominos with half strenght.", # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"50 Pointer" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 5,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(112, 0),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 50,
				"padre" : 0,
				"plata": "<#b1911a>14",
				"venta": "<#b1911a>7",
				"BG": Vector2(80, 192),
				"titulo": "<#296e8f>50 Pointer",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "This domino Adds <#296e8f>+50 points when it falls." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"2x Behind" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 1,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(80, 0),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>20",
				"venta": "<#b1911a>10",
				"BG": Vector2(16, 192),
				"titulo": "<#e0483e>2x Behind",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "This domino <#296e8f>Adds the amount made before itself <#e0483e>times <#e0483e>2." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Banana" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 1,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(144, 0),
				"flechitas" : ["→", "←"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>20",
				"venta": "<#b1911a>10",
				"BG": Vector2(4800, 192),
				"titulo": "<#e19124>Banana",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "This domino Falls to the front and <#238c73>THEN to the back of itself." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Double" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 4,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(176, 0),
				"flechitas" : ["→", "↳"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>10",
				"venta": "<#b1911a>6",
				"BG": Vector2(48, 192),
				"titulo": "<#238c73>Double",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Can knock down <#296e8f>2 dominos." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Multiplier 2x" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 3,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(240, 0),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>10",
				"venta": "<#b1911a>10",
				"BG": Vector2(16, 192),
				"titulo": "<#e0483e>Multiplier <#e0483e>2x",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "<#e0483e>Doubles everything in the chain if this domino is the <#e0483e>2nd in the <#296e8f>row." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Specific 100" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 6,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(272, 0),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>20",
				"venta": "<#b1911a>10",
				"BG": Vector2(80, 192),
				"titulo": "Specific <#296e8f>100",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Adds <#296e8f>+100 if it’s the <#e0483e>2nd and last in a row." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Reverse" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 2,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(304, 0),
				"flechitas" : ["↺"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>15",
				"venta": "<#b1911a>7",
				"BG": Vector2(48, 192),
				"titulo": "<#238c73>Reverse",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "<#238c73>Reverses the fall direction of a row of dominos." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Long Shot" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 5,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(48, 0),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>8",
				"venta": "<#b1911a>4",
				"BG": Vector2(80, 192),
				"titulo": "<#296e8f>Long Shot",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "<#296e8f>Adds to the score the number of dominos that fell because of this one." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Sniper" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 6,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(48, 64),
				"flechitas" : ["→→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>8",
				"venta": "<#b1911a>4",
				"BG": Vector2(208, 192),
				"titulo": "<#e0483e>Sniper",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Falls with <#238c73>double the normal length." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Eye" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 5,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(80, 64),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>10",
				"venta": "<#b1911a>7",
				"BG": Vector2(48, 192),
				"titulo": "<#e0483e>Eye",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Falls and <#296e8f>adds the score of the domino that contributed the most before itself." # ejemplo: "This domino adds <#f3983a>+1"
			},
#	"Time Bomb" :  {
#				"tipo" : "especial",
#				"color" : "All",  # Orange, Pink, Blue, Green, All
#				"chance": 4,  # algo menos común
#				"usado": 0,  # CANTIDAD DE USOS
#				"region_rect_cords": Vector2(16, 64),
#				"flechitas" : ["↖", "↗", "↘", "↙"],
#				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
#				"mult_actual": 1,
#				"mult_global": 1,
#				"mult_siguiente": 0.5,
#				"puntaje_siguiente": 0,
#				"puntaje": 0,
#				"padre" : 3,
#				"plata": "<#b1911a>10",
#				"venta": "<#b1911a>10",
#				"BG": Vector2(48, 192),
#				"titulo": "<#238c73>Time <#238c73>Bomb",  # ejemplo: "1 <#f3983a>Red"
#				"descripcion": "Activates after 7 other dominos fell, then explodes." # ejemplo: "This domino adds <#f3983a>+1"
#			},
	
	# HECHO ///////////////////////////////
	"Mirror" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 2,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(112, 64),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>12",
				"venta": "<#b1911a>7",
				"BG": Vector2(4800, 192),
				"titulo": "<#76357a>Mirror",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Clones the row it is in but only after itself, it only clones normal dominos with x1.5 the strenght." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Fire" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 2,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(144, 64),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 5,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>10",
				"venta": "<#b1911a>10",
				"BG": Vector2(4800, 192),
				"titulo": "<#f04015>Fire",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "<#f04015>Spreads its effect to all dominos in the chain, giving each <#296e8f>+5 points." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Blue Fire" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 20000,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(176, 64),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1.5,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>12",
				"venta": "<#b1911a>7",
				"BG": Vector2(4800, 192),
				"titulo": "<#407cad>Blue <#407cad>Fire",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Like <#f04015>Fire but <#296e8f>adds 50% to each of the next dominos instead of +5 points" # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Sticky" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 1,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(208, 64),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 5,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>14",
				"venta": "<#b1911a>8",
				"BG": Vector2(4800, 192),
				"titulo": "<#38b338>Sticky",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Leaves a <#38b338>”slime <#38b338>trail”, Dominos after it gain <#296e8f>+1 permanently." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Ruler" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 0,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(240, 64),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 0,
				"padre" : 0,
				"plata": "<#b1911a>15",
				"venta": "<#b1911a>6",
				"BG": Vector2(4800, 192),
				"titulo": "<#e19124>Ruler",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "<#296e8f>Adds the distance   ( <#e19124>cm ) traveled between start to finish." # ejemplo: "This domino adds <#f3983a>+1"
			},
	
	# HECHO ///////////////////////////////
	"Stamp Master" :  {
				"tipo" : "especial",
				"color" : "All",  # Orange, Pink, Blue, Green, All
				"chance": 4,  # algo menos común
				"usado": 0,  # CANTIDAD DE USOS
				"region_rect_cords": Vector2(272, 64),
				"flechitas" : ["→"],
				"stamps": [],  #[  ["Ascendant", Vector2(0, 0)], ["Ascendant", Vector2(8, 20)]  ],
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"puntaje": 10,
				"padre" : 0,
				"plata": "<#b1911a>13",
				"venta": "<#b1911a>6",
				"BG": Vector2(16, 192),
				"titulo": "<#e0483e>Stamp <#e0483e>Master",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "The next stamp you <#296e8f>add to this domino will be duplicated, it also <#296e8f>adds <#296e8f>+10." # ejemplo: "This domino adds <#f3983a>+1"
			},
}



func _amuletos():pass
var amuletos = {
	# HECHO ///////////////////////////////
	"Standard Pack" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(0,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 3,
							"cuantos_agarrables" : 1,
							"titulo" : "Standard Pack",
							"descripcion" : "<#296e8f>Gives 3 common Dominos of random colors.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Color Infusion Pack":{
							"size" : Vector2(32,32), 
							"position" : Vector2(32,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 2,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 4,
							"cuantos_agarrables" : 4,
							"titulo" : "Color Infusion Pack",
							"descripcion" : "<#296e8f>Gives 1 extra Domino of each color (Rose, Orange, Blue, Green).\n<#296e8f>(all)",
	},
	
	# HECHO ///////////////////////////////
	"Mystery Spread" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(64,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3000,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "special",
							"stamps" : false,
							"cuantos" : 4,
							"cuantos_agarrables" : 1,
							"titulo" : "Mystery Spread",
							"descripcion" : "<#296e8f>Gives 4 special Dominos.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Stamp Collector Pack":{
							"size" : Vector2(32,32),
							"position" : Vector2(96,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "stamp",
							"tipo_domino_stamp" : "normal",
							"stamps" : false,
							"cuantos" : 2,
							"cuantos_agarrables" : 1,
							"titulo" : "Stamp Collector Pack",
							"descripcion" : "<#296e8f>Gives 2 random Stamps.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Super Stamp Pack" : {
							"size" : Vector2(32,32),
							"position" : Vector2(128,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "stamp",
							"tipo_domino_stamp" : "normal",
							"stamps" : false,
							"cuantos" : 4,
							"cuantos_agarrables" : 1,
							"titulo" : "Super Stamp Pack",
							"descripcion" : "<#296e8f>Gives 4 random Stamps.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Lucky Batch" : {
							"size" : Vector2(32,32),
							"position" : Vector2(160,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : true,
							"cuantos" : 5,
							"cuantos_agarrables" : 1,
							"titulo" : "Lucky Batch",
							"descripcion" : "<#296e8f>Gives 5 Dominos with a random stamp, without special dominos.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Chainmaker Pack" : {
							"size" : Vector2(32,32),
							"position" : Vector2(192,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 2,
							"cuantos_agarrables" : 2,
							"titulo" : "Chainmaker Pack",
							"descripcion" : "<#296e8f>Gives 2 Dominos of the color you have the most.\n<#296e8f>(all)",
	},
	
	# HECHO ///////////////////////////////
	"Focused Pack" : {
							"size" : Vector2(32,32),
							"position" : Vector2(224,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 2,
							"cuantos_agarrables" : 2,
							"titulo" : "Focused Pack",
							"descripcion" : "<#296e8f>Gives 2 Dominos of the most played color.\n<#296e8f>(all)",
	},
	
	# HECHO ///////////////////////////////
	"*StampName* Pack" : {
							"size" : Vector2(32,32),
							"position" : Vector2(256,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 1,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "stamp",
							"tipo_domino_stamp" : "all",
							"stamp" : "",
							"stamps" : false,
							"cuantos" : 1,
							"cuantos_agarrables" : 1,
							"titulo" : "*StampName* Pack",
							"descripcion" : "<#296e8f>Gives the *StampName*; can be used on special or normal domino.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Overflow Pack" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(288,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 5,
							"cuantos_agarrables" : 3,
							"titulo" : "Overflow Pack",
							"descripcion" : "<#296e8f>Gives 5 Normal Dominos, but randomly destroys 2 unknown ones from your collection.\n<#296e8f>(3)",
	},
	
	# HECHO ///////////////////////////////
	"Inverted Pack": {
							"size": Vector2(32, 32),
							"position": Vector2(64, 160),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 4,
							"cuantos_agarrables" : 1,
							"titulo": "Inverted Pack",
							"descripcion": "Deletes a Whole Color of Dominos."
	},
	
	
	
	# HECHO ///////////////////////////////
	"borrar": {
							"chance": 0,  # algo menos común
							"nivel_desbloqueo" : 0,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 5,
							"cuantos_agarrables" : 1,
							"titulo": "Borrar",
							"descripcion": "Deletes a Dominos."
	},
	
	
	
	
	
	
	
	
	
	
	
	# //////   STATS //////   STATS //////   STATS //////   STATS //////   STATS //////   STATS //////
	
	
#	"Rose Favor" :          {
#							"size" : Vector2(32,32),
#							"position" : Vector2(96,32),
#							"plata": "<#b1911a>10",
#							"venta": "<#b1911a>10",
#							"chance": 3,  # algo menos común
#							"nivel_desbloqueo" : 1,
#							"usable": false,
#							"titulo" : "<#e48b7c>Rose Favor",
#							"descripcion" : "Chances of Rose dominos to appear are <#e0483e>x1.2 higher.",
#	},
#	"Orange Favor" :      {
#							"size" : Vector2(32,32),
#							"position" : Vector2(128,32),
#							"plata": "<#b1911a>10",
#							"venta": "<#b1911a>10",
#							"chance": 3,  # algo menos común
#							"nivel_desbloqueo" : 1,
#							"usable": false,
#							"titulo" : "<#f3983a>Orange Favor",
#							"descripcion" : "Chances of Orange dominos to appear are <#e0483e>x1.2 higher.",
#	},
#	"Blue Favor" :          {
#							"size" : Vector2(32,32),
#							"position" : Vector2(160,32),
#							"plata": "<#b1911a>10",
#							"venta": "<#b1911a>10",
#							"chance": 3,  # algo menos común
#							"nivel_desbloqueo" : 1,
#							"usable": false,
#							"titulo" : "<#3c4368>Blue Favor",
#							"descripcion" : "Chances of Blue dominos to appear are <#e0483e>x1.2 higher.",
#	},
#	"Green Favor" :        {
#							"size" : Vector2(32,32),
#							"position" : Vector2(192,32),
#							"plata": "<#b1911a>10",
#							"venta": "<#b1911a>10",
#							"chance": 3,  # algo menos común
#							"nivel_desbloqueo" : 1,
#							"usable": false,
#							"titulo" : "<#235955>Green Favor",
#							"descripcion" : "Chances of Green dominos to appear are <#e0483e>x1.2 higher.",
#	},
	
	
	
	# HECHO ///////////////////////////////
	"Stamper" : {
							"size" : Vector2(32,32),
							"position" : Vector2(0,128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["maximo_stampas"],
							"accion" : ["+2"],
							
							"titulo" : "Stamper",
							"descripcion" : "Allows you to have up to 3 stamps in a domino.",
	},
	
	
	# HECHO ///////////////////////////////
	"Jump Man": {
							"size": Vector2(32, 32),
							"position": Vector2(32, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 300000,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["plays"],
							"accion" : ["+1"],
							
							"titulo": "Jump Man",
							"descripcion": "<#296e8f>Gives <#296e8f>+1 Extra Play."
	},
	
	
	# HECHO ///////////////////////////////
	"GamePad": {
							"size": Vector2(32, 32),
							"position": Vector2(64, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["plays"],
							"accion" : ["+1"],
							
							"titulo": "GamePad",
							"descripcion": "<#296e8f>Gives <#296e8f>+1 Extra Play."
	},
	
	
	# HECHO ///////////////////////////////
	"Cards Drawed": {
							"size": Vector2(32, 32),
							"position": Vector2(96, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["draws"],
							"accion" : ["+1"],
							
							"titulo": "Cards Drawed",
							"descripcion": "<#296e8f>Gives <#296e8f>+1 Extra Draw."
	},
	
	
	# HECHO ///////////////////////////////
	"Painting": {
							"size": Vector2(32, 32),
							"position": Vector2(128, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["draws"],
							"accion" : ["+1"],
							
							"titulo": "Painting",
							"descripcion": "<#296e8f>Gives <#296e8f>+1 Extra Draw."
	},
	
	
	# HECHO ///////////////////////////////
	"Gold Cart": {
							"size": Vector2(32, 32),
							"position": Vector2(160, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" :   ["max_cards_specials_in_store", "max_cards_normal_in_store"],
							"accion" : ["_4"                         , "_4"],
							
							"titulo": "<#b1911a>Gold Cart",
							"descripcion": "<#296e8f>Gives <#296e8f>+1 Extra Normal and Special Domino in the shop. (invalidates the other carts)"
	},
	
	
	# HECHO ///////////////////////////////
	"Silver Cart": {
							"size": Vector2(32, 32),
							"position": Vector2(192, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["max_cards_normal_in_store"],
							"accion" : ["_4"],
							
							"titulo": "Silver Cart",
							"descripcion": "<#296e8f>Gives <#296e8f>+1 Extra Normal Domino in the shop."
	},
	
	
	# HECHO ///////////////////////////////
	"Special Cart": {
							"size": Vector2(32, 32),
							"position": Vector2(224, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["max_cards_specials_in_store"],
							"accion" : ["_4"],
							
							"titulo": "Special Cart",
							"descripcion": "<#296e8f>Gives <#296e8f>+1 Extra Special Domino in the shop."
	},
	
	
	# HECHO ///////////////////////////////
	"Gold Stamp": {
							"size": Vector2(32, 32),
							"position": Vector2(256, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["dominos_en_shop_tener_stamps"],
							"accion" : ["+1"],
							
							"titulo": "<#b1911a>Gold Stamp",
							"descripcion": "All Dominos in the Shop have a chance to have stamps."
	},
	
	
	# HECHO ///////////////////////////////
	"Silver Stamp": {
							"size": Vector2(32, 32),
							"position": Vector2(288, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["normales_pueden_tener_stamps"],
							"accion" : ["+1"],
							
							"titulo": "Silver Stamp",
							"descripcion": "Normal Dominos in the Shop have a chance to have stamps."
	},
	
	
	# HECHO ///////////////////////////////
	"Discount Tag": {
							"size": Vector2(32, 32),
							"position": Vector2(320, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["descuento"],
							"accion" : ["+30"],
							
							"titulo": "Discount Tag",
							"descripcion": "<#e0483e>30% Discount."
	},
	
	
	# HECHO ///////////////////////////////
	"Stampack": {
							"size": Vector2(32, 32),
							"position": Vector2(352, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["packs_pueden_tener_stamps"],
							"accion" : ["+1"],
							
							"titulo": "Stampack",
							"descripcion": "All the Packs of Dominos Could have stamps with them."
	},
	
	
	# HECHO ///////////////////////////////
	"Rose Scroll": {
							"size": Vector2(32, 32),
							"position": Vector2(384, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["rose_%"],
							"accion" : ["+25"],
							
							"titulo": "Rose Scroll",
							"descripcion": "Double the base chance of getting Rose Dominos."
	},
	
	
	# HECHO ///////////////////////////////
	"Orange Scroll": {
							"size": Vector2(32, 32),
							"position": Vector2(416, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["orange_%"],
							"accion" : ["+25"],
							
							"titulo": "Orange Scroll",
							"descripcion": "Double the base chance of getting Orange Dominos."
	},
	
	
	# HECHO ///////////////////////////////
	"Blue Scroll": {
							"size": Vector2(32, 32),
							"position": Vector2(448, 128),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["blue_%"],
							"accion" : ["+25"],
							
							"titulo": "Blue Scroll",
							"descripcion": "Double the base chance of getting Blue Dominos."
	},
	
	
	# HECHO ///////////////////////////////
	"Green Scroll": {
							"size": Vector2(32, 32),
							"position": Vector2(0, 160),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["green_%"],
							"accion" : ["+25"],
							
							"titulo": "Green Scroll",
							"descripcion": "Double the base chance of getting Green Dominos."
	},
	"Random Scroll": {
							"size": Vector2(32, 32),
							"position": Vector2(32, 160),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat_por_level" : ["<rose;green;orange;blue>_%"],
							"accion_por_level" : ["+25"],
							
							"titulo": "Random Scroll",
							"descripcion": "Double the base chance of getting a random Color per level.  \n<#296e8f>(null)"
	},
	
	
	# HECHO ///////////////////////////////
	"Silver Plate": {
							"size": Vector2(32, 32),
							"position": Vector2(128, 160),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["max_cards_in_hand"],
							"accion" : ["+1"],
							
							"titulo": "Silver Plate",
							"descripcion": "<#296e8f>1+ Extra Normal Domino in hand."
	},
	
	
	# HECHO ///////////////////////////////
	"Special Plate": {
							"size": Vector2(32, 32),
							"position": Vector2(160, 160),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["max_specials_cards_in_hand"],
							"accion" : ["+1"],
							
							"titulo": "Special Plate",
							"descripcion": "<#296e8f>1+ Extra Special Domino in hand."
	},
	
	
	# HECHO ///////////////////////////////
	"Domino Sticker": {
							"size": Vector2(32, 32),
							"position": Vector2(192, 160),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["dominos_on_gamezone"],
							"accion" : ["+1"],
							
							"titulo": "Domino Sticker",
							"descripcion": "Allows you to have <#296e8f>1 Extra Domino in the Game Zone."
	},
	
	
	# HECHO ///////////////////////////////
	"Domino Tag": {
							"size": Vector2(32, 32),
							"position": Vector2(224, 160),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["dominos_on_gamezone"],
							"accion" : ["+1"],
							
							"titulo": "Domino Tag",
							"descripcion": "Allows you to have <#296e8f>1 Extra Domino in the Game Zone."
	},
	
	
	# HECHO ///////////////////////////////
	"Trash Bag": {
							"size": Vector2(32, 32),
							"position": Vector2(256, 160),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["cantidad_de_borrables_por_tienda"],
							"accion" : ["+2"],
							
							"titulo": "Trash Bag",
							"descripcion": "Allows you to Delete up to 3 dominos per shop."
	},
	
	
	# HECHO ///////////////////////////////
	"Black Hole": {
							"size": Vector2(32, 32),
							"position": Vector2(288, 160),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 30000,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["poder_repetir_amuletos"],
							"accion" : ["+1"],
							
							"titulo": "<r;392d57;4b3576;5d3c95;7043b4;5d3c95;4b3576;392d57>Black <r;392d57;4b3576;5d3c95;7043b4;5d3c95;4b3576;392d57>Hole",
							"descripcion": "Allows you to encounter charms that you already have."
	},
	
	
	# HECHO ///////////////////////////////
	"Coin Blessing" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(448,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["level_plata_mult"],
							"accion" : ["x1.1"],
							
							"titulo" : "Coin Blessing",
							"descripcion" : "Gives you <#296e8f>10% extra coins every level cleared.",
	},
	
	
	# HECHO ///////////////////////////////
	"Greed's Touch" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(224,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["plata_mult"],
							"accion" : ["x1.25"],
							
							"titulo" : "Greed's Touch",
							"descripcion" : "Multiplies all coin rewards from other items by <#e0483e>x1.25.",
	},
	
	
	# HECHO ///////////////////////////////
	"Box of Scraps" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(192,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["max_amuletos"],
							"accion" : ["+2"],
							
							"titulo" : "Box of Scraps",
							"descripcion" : "Let's you have 2 extra charms.",
	},
	# //////   STATS //////   STATS //////   STATS //////   STATS //////   STATS //////   STATS //////
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	"Rose Ascendant" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(320,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#e48b7c>Rose Ascendant",
							"descripcion" : "<#296e8f>50% of fallen Rose dominos get a permanent <#296e8f>+1 every time they are used.",
	},
	"Orange Ascendant" :  {
							"size" : Vector2(32,32),
							"position" : Vector2(352,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#f3983a>Orange Ascendant",
							"descripcion" : "<#296e8f>50% of fallen Orange dominos get a permanent <#296e8f>+1 every time they are used.",
	},
	"Blue Ascendant" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(384,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#3c4368>Blue Ascendant",
							"descripcion" : "<#296e8f>50% of fallen Blue dominos get a permanent <#296e8f>+1 every time they are used.",
	},
	"Green Ascendant" :    {
							"size" : Vector2(32,32),
							"position" : Vector2(416,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#235955>Green Ascendant",
							"descripcion" : "<#296e8f>50% of fallen Green dominos get a permanent <#296e8f>+1 every time they are used.",
	},
	"Rose Flourish" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(448,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#e48b7c>Rose Flourish",
							"descripcion" : "<#296e8f>50% of fallen Rose dominos get <#e0483e>x1.6 every time they are used.",
	},
	"Orange Flourish" :    {
							"size" : Vector2(32,32),
							"position" : Vector2(0,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#f3983a>Orange Flourish",
							"descripcion" : "<#296e8f>50% of fallen Orange dominos get <#e0483e>x1.6 every time they are used.",
	},
	"Blue Flourish" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(32,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#3c4368>Blue Flourish",
							"descripcion" : "<#296e8f>50% of fallen Blue dominos get <#e0483e>x1.6 every time they are used.",
	},
	"Green Flourish" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(64,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#235955>Green Flourish",
							"descripcion" : "<#296e8f>50% of fallen Green dominos get <#e0483e>x1.6 every time they are used.",
	},
	"Rose Resurgence" :    {
							"size" : Vector2(32,32),
							"position" : Vector2(224,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#e48b7c>Rose Resurgence",
							"descripcion" : "The fewer Rose dominos there are, the higher the chance they appear.",
	},
	"Orange Resurgence" : {
							"size" : Vector2(32,32),
							"position" : Vector2(256,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#f3983a>Orange Resurgence",
							"descripcion" : "The fewer Orange dominos there are, the higher the chance they appear.",
	},
	"Blue Resurgence" :    {
							"size" : Vector2(32,32),
							"position" : Vector2(288,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#3c4368>Blue Resurgence",
							"descripcion" : "The fewer Blue dominos there are, the higher the chance they appear.",
	},
	"Green Resurgence" :  {
							"size" : Vector2(32,32),
							"position" : Vector2(320,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#235955>Green Resurgence",
							"descripcion" : "The fewer Green dominos there are, the higher the chance they appear.",
	},
	"Rose Bloom" :          {
							"size" : Vector2(32,32),
							"position" : Vector2(352,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#e48b7c>Rose Bloom",
							"descripcion" : "<#296e8f>50% chance for every Rose dominos that scores to <#296e8f>gain <#296e8f>+0.2 color multiplier permanently (max <#e0483e>x2).",
	},
	"Orange Delight" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(384,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#f3983a>Orange Delight",
							"descripcion" : "Orange dominos give <#b1911a>2c.",
	},
	"Domino Surge" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(416,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Domino Surge",
							"descripcion" : "If a chain contains 5 or more dominos of a single color, that color gets a permanent <#296e8f>+.5 in it's multiplier.",
	},
	"Final Wish" :          {
							"size" : Vector2(32,32),
							"position" : Vector2(0,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Final Wish",
							"descripcion" : "The last play of the level <#296e8f>adds <#e0483e>x.5 to the global multiplier.",
	},
	"Augmented Chance" :  {
							"size" : Vector2(32,32),
							"position" : Vector2(32,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Augmented Chance",
							"descripcion" : "Items with chance-based effects get <#e0483e>x2 more likely to activate.",
	},
	"Coin Strike" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(64,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Coin Strike",
							"descripcion" : "There is a <#296e8f>20% chance for every domino to give you <#b1911a>2c.",
	},
	"Combo Trinity" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(96,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Combo Trinity",
							"descripcion" : "If all the normal dominos in a single play are 7 or 8, <#296e8f>adds 0.5 to the global multiplier.", #you get 3 or more patterns/combos 
	},
	"Chain Dealer" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(128,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Chain Dealer",
							"descripcion" : "Each 7th domino in a chain <#e0483e>multiplies by x1.7 the domino's score.", # global multiplier
	},
	"Lucky Break" :        {
							"size" : Vector2(32,32),
							"position" : Vector2(160,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Lucky Break",
							"descripcion" : "<#296e8f>10% chance to replay all dominos after a play.", # without any combos.
	},
	"Stack Overflow" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(192,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Stack Overflow",
							"descripcion" : "Every normal domino adds +5 to itself, only for this level.", # Every combo type <#296e8f>adds <#296e8f>+5 to the combo's score
	},
	"Echo Pattern" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(256,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Echo Pattern",
							"descripcion" : "Repeats the last 3 dominos of the play once per level <#296e8f>(150% <#296e8f>efficiency).", # combo
	},
	"Domino Paradox" :    {
							"size" : Vector2(32,32),
							"position" : Vector2(288,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Domino Paradox",
							"descripcion" : "The first and last domino in a chain both <#296e8f>gain <#296e8f>+10.",
	},
	"Overgrowth" :          {
							"size" : Vector2(32,32),
							"position" : Vector2(320,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Overgrowth",
							"descripcion" : "If you play 5 or more dominos of the same color, that color <#296e8f>gains <#296e8f>10% spawn chance permanently.",
	},
	"Fading Luck" :        {
							"size" : Vector2(32,32),
							"position" : Vector2(352,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Fading Luck",
							"descripcion" : "<#296e8f>Adds <#296e8f>+80 each play, then halves permanently after each use.",
	},
	"Gold Medal" :          {
							"size" : Vector2(32,32),
							"position" : Vector2(384,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#b1911a>Gold Medal",
							"descripcion" : "The first 3 dominos of every level has <#e0483e>x1.25 power.", #combo
	},
	"Gold Seed" :           {
							"size" : Vector2(32,32),
							"position" : Vector2(416,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#b1911a>Gold Seed",
							"descripcion" : "Every <#b1911a>50c owned grants a <#e0483e>x0.5 global multiplier.",
	},
	"Gold Tree" :        {
							"size" : Vector2(32,32),
							"position" : Vector2(448,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#b1911a>Gold Tree",
							"descripcion" : "Every <#b1911a>100c owned grants a <#e0483e>x2 global multiplier.",
	},
	"Trickster's Bloom" : {
							"size" : Vector2(32,32),
							"position" : Vector2(0,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Trickster's Bloom",
							"descripcion" : "Each time a charm activates, there's a <#296e8f>10% chance for it to activate twice.",
	},
	"Fifth is the charm" : {
							"size" : Vector2(32,32),
							"position" : Vector2(32,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Fifth is the charm",
							"descripcion" : "Every five charm activations, this repeats the last charm's effect.",
	},
	"Chain Lock" :        {
							"size" : Vector2(32,32),
							"position" : Vector2(64,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Chain Lock",
							"descripcion" : "<#296e8f>Gain <#b1911a>+10c if all dominos in a chain have no consecutive colors.",
	},
	"Domino Spirit" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(96,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Domino Spirit",
							"descripcion" : "The last domino played in a level permanently <#296e8f>gains <#296e8f>+10 base value.",
	},
	"Crystal Shard" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(128,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Crystal Shard",
							"descripcion" : "Each charm activates twice but disables color-based bonuses.", #combo
	},
	"Puzzle Piece" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(160,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Puzzle Piece",
							"descripcion" : "If the same domino repeats 3 times in a level, <#296e8f>+1 to the global multiplier.", #combo
	},
	"Sun Pendant" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(224,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Sun Pendant",
							"descripcion" : "At level start, for every 3 or more same color-type charms owned, <#296e8f>gain <#e0483e>x1.2 global multiplier.",
	},
	"Amber Core" :        {
							"size" : Vector2(32,32),
							"position" : Vector2(256,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Amber Core",
							"descripcion" : "When an Orange domino starts a the play, grants <#296e8f>+2 to all other Oranges permanently.",
	},
	"Sea Shell" :         {
							"size" : Vector2(32,32),
							"position" : Vector2(288,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Sea Shell",
							"descripcion" : "When a play ends with a Blue domino, <#296e8f>gain <#b1911a>+5c.",
	},
	"Easy Money" :          {
							"size" : Vector2(32,32),
							"position" : Vector2(320,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Easy Money",
							"descripcion" : "Get the value of the last domino in coins.",
	},
	"Rusty Scale" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(352,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Rusty Scale",
							"descripcion" : "All coins <#296e8f>gained are taxed −<#296e8f>20%, but charm activations are <#e0483e>x1.3 stronger.",
	},
	"Domino Mask" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(384,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Domino Mask",
							"descripcion" : "Creates an new domino after the last one with the next natural number.", # one away from a combo
	},
	"Black Ink" :         {
							"size" : Vector2(32,32),
							"position" : Vector2(416,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 1,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Black Ink",
							"descripcion" : "Missing a color in your deck gives <#296e8f>+5 global multiplier per absent color.",
	},
	"Crystal Dice" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(448,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Crystal Dice",
							"descripcion" : "Duplicates one random active charm at the start of a level (temporary).",
	},
	"Giant's Tear Drop": {
							"size": Vector2(32, 32),
							"position": Vector2(96, 160),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"titulo": "Giant Tear Drop",
							"descripcion": "<#e0483e>10% chance of getting all the points in a play as coins."
	},
	"Gold Bracelet": {
							"size": Vector2(32, 32),
							"position": Vector2(320, 160),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>10",
							"chance": 3,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"titulo": "<#b1911a>Gold Bracelet",
							"descripcion": "Adds +1.0 to the global multiplier for every leftover normal? Domino in hand."
	},
}



