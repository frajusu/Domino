extends Node














func _stamps(): pass
var stamps = {
	# HECHO ///////////////////////////////
	"Ascendant Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(32, 0),
		"plata": "<#b1911a>10",
		"chance": 10,  # algo menos común
		"titulo": "<#a13895>Ascendant <#296e8f>Stamp",
		"descripcion": "Increases the Domino's value by <#296e8f>+2 every time it falls.",
		"descripcion_corta": "Perma <#296e8f>+2. \n<#296e8f>(now <#296e8f>: <#296e8f>",
	},
	
	# HECHO ///////////////////////////////
	"Double Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(48, 0),
		"plata": "<#b1911a>10",
		"chance": 5,  # algo menos común
		"titulo": "<#238c73>Double <#296e8f>Stamp",
		"descripcion": "Allows the Domino to have an extra arrow/child.",
		"descripcion_corta": "Extra arrow/child.",
	},
	
	# HECHO ///////////////////////////////
	"Stone Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(64, 0),
		"plata": "<#b1911a>10",
		"chance": 10,  # algo menos común
		"titulo": "<#5e5e5e>Stone <#296e8f>Stamp",
		"descripcion": "The Domino is considered any color.",
		"descripcion_corta": "Any color.",
	},
	
	# HECHO ///////////////////////////////
	"Gold Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(80, 0),
		"plata": "<#b1911a>10",
		"chance": 7,  # algo menos común
		"titulo": "<#b1911a>Gold <#296e8f>Stamp",
		"descripcion": "The Domino <#296e8f>gives <#b1911a>5c when used.",
		"descripcion_corta": "<#296e8f>Gives <#b1911a>5c.",
	},
	
	# HECHO ///////////////////////////////
	"Silver Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(96, 0),
		"plata": "<#b1911a>10",
		"chance": 10,  # algo menos común
		"titulo": "<#5e5e5e>Silver <#296e8f>Stamp",
		"descripcion": "The Domino <#296e8f>gives <#b1911a>3c when used.",
		"descripcion_corta": "<#296e8f>Gives <#b1911a>3c.",
	},
	
	# HECHO ///////////////////////////////
	"Bronze Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(112, 0),
		"plata": "<#b1911a>10",
		"chance": 12,  # algo menos común
		"titulo": "<#b57b4e>Bronze <#296e8f>Stamp",
		"descripcion": "The Domino <#296e8f>gives <#b1911a>1c when used.",
		"descripcion_corta": "<#296e8f>Gives <#b1911a>1c.",
	},
	
	# HECHO ///////////////////////////////
	"Obsidian Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(128, 0),
		"plata": "<#b1911a>10",
		"chance": 10,  # algo menos común
		"titulo": "<#3b3b3b>Obsidian <#296e8f>Stamp",
		"descripcion": "When used, Duplicates chances of this color in the next play.",
		"descripcion_corta": "Duplicates chances of this color.",
	},
	
	# HECHO ///////////////////////////////
	"Emerald Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(144, 0),
		"plata": "<#b1911a>10",
		"chance": 10,  # algo menos común
		"titulo": "<#6cc47a>Emerald <#296e8f>Stamp",
		"descripcion": "Each time the Domino is used, <#296e8f>gives the amount of Dominos of the same color in <#b1911a>coins.",
		"descripcion_corta": "<#b1911a>+1c per same color.",
	},
	
	# HECHO ///////////////////////////////
	"Amethyst Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(160, 0),
		"plata": "<#b1911a>10",
		"chance": 10,  # algo menos común
		"titulo": "<#b48edc>Amethyst <#296e8f>Stamp",
		"descripcion": "When used, <#296e8f>adds a temporary <#e0483e>x.5 to the score of Dominos of the same color.",
		"descripcion_corta": "Same color <#e0483e>x.5.",
	},
	
	# HECHO ///////////////////////////////
	"Diamond Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(176, 0),
		"plata": "<#b1911a>10",
		"chance": 10,  # algo menos común
		"titulo": "<#296e8f>Diamond <#296e8f>Stamp",
		"descripcion": "<#e0483e>Multiplies <#e0483e>by <#e0483e>3 the coins obtained by the dominos that share color with this one.",
		"descripcion_corta": "Same color, Coins <#e0483e>x3.",
	},
	
	# HECHO ///////////////////////////////
	"Quartz Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(192, 0),
		"plata": "<#b1911a>10",
		"chance": 10,  # algo menos común
		"titulo": "<#e6c3e6>Quartz <#296e8f>Stamp",
		"descripcion": "Each time it is used, <#296e8f>adds a small random effect of <#b1911a>+5c or <#296e8f>+5 points.",
		"descripcion_corta": "Random <#b1911a>+5c or <#296e8f>+5pts.",
	},
	
	# HECHO ///////////////////////////////
	"God Stamp": {
		"size": Vector2(16, 16),
		"position": Vector2(208, 0),
		"plata": "<#b1911a>10",
		"chance": 4,  # algo menos común
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
				"chance": 2,  # algo menos común
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
				"descripcion": "The next <#e0483e>stamp you <#296e8f>add to this domino will be duplicated, it also <#296e8f>adds <#296e8f>+10." # ejemplo: "This domino adds <#f3983a>+1"
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
							"chance": 15,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 3,
							"cuantos_agarrables" : 1,
							"titulo" : "Standard Pack",
							"descripcion" : "<#296e8f>Gives <#296e8f>3 common Dominos of random colors.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Color Infusion Pack":{
							"size" : Vector2(32,32), 
							"position" : Vector2(32,0),
							"plata": "<#b1911a>12",
							"venta": "<#b1911a>10",
							"chance": 15,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 4,
							"cuantos_agarrables" : 4,
							"titulo" : "Color Infusion Pack",
							"descripcion" : "<#296e8f>Gives <#296e8f>1 extra Domino of each color (Rose, Orange, Blue, Green).\n<#296e8f>(all)",
	},
	
	# HECHO ///////////////////////////////
	"Mystery Spread" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(64,0),
							"plata": "<#b1911a>15",
							"venta": "<#b1911a>10",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "special",
							"stamps" : false,
							"cuantos" : 4,
							"cuantos_agarrables" : 1,
							"titulo" : "Mystery Spread",
							"descripcion" : "<#296e8f>Gives <#296e8f>4 <#267864>Special Dominos.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Stamp Collector Pack":{
							"size" : Vector2(32,32),
							"position" : Vector2(96,0),
							"plata": "<#b1911a>5",
							"venta": "<#b1911a>10",
							"chance": 16,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "stamp",
							"tipo_domino_stamp" : "normal",
							"stamps" : false,
							"cuantos" : 2,
							"cuantos_agarrables" : 1,
							"titulo" : "Stamp Collector Pack",
							"descripcion" : "<#296e8f>Gives <#296e8f>2 random Stamps.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Super Stamp Pack" : {
							"size" : Vector2(32,32),
							"position" : Vector2(128,0),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>10",
							"chance": 15,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "stamp",
							"tipo_domino_stamp" : "normal",
							"stamps" : false,
							"cuantos" : 4,
							"cuantos_agarrables" : 1,
							"titulo" : "Super Stamp Pack",
							"descripcion" : "<#296e8f>Gives <#296e8f>4 random Stamps.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Lucky Batch" : {
							"size" : Vector2(32,32),
							"position" : Vector2(160,0),
							"plata": "<#b1911a>13",
							"venta": "<#b1911a>10",
							"chance": 14,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : true,
							"cuantos" : 5,
							"cuantos_agarrables" : 1,
							"titulo" : "Lucky Batch",
							"descripcion" : "<#296e8f>Gives <#296e8f>5 Dominos with a random <#e0483e>stamp, without <#267864>Special dominos.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Chainmaker Pack" : {
							"size" : Vector2(32,32),
							"position" : Vector2(192,0),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>10",
							"chance": 16,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 2,
							"cuantos_agarrables" : 2,
							"titulo" : "Chainmaker Pack",
							"descripcion" : "<#296e8f>Gives <#296e8f>2 Dominos of the color you have the <#e0483e>most.\n<#296e8f>(all)",
	},
	
	# HECHO ///////////////////////////////
	"Focused Pack" : {
							"size" : Vector2(32,32),
							"position" : Vector2(224,0),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>10",
							"chance": 16,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 2,
							"cuantos_agarrables" : 2,
							"titulo" : "Focused Pack",
							"descripcion" : "<#296e8f>Gives <#296e8f>2 Dominos of the most played color.\n<#296e8f>(all)",
	},
	
	# HECHO ///////////////////////////////
	"*StampName* Pack" : {
							"size" : Vector2(32,32),
							"position" : Vector2(256,0),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>10",
							"chance": 5,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "stamp",
							"tipo_domino_stamp" : "all",
							"stamp" : "",
							"stamps" : false,
							"cuantos" : 1,
							"cuantos_agarrables" : 1,
							"titulo" : "*StampName* Pack",
							"descripcion" : "<#296e8f>Gives the <#e0483e>*StampName*; can be used on <#267864>Special or normal domino.\n<#296e8f>(only <#296e8f>1)",
	},
	
	# HECHO ///////////////////////////////
	"Overflow Pack" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(288,0),
							"plata": "<#b1911a>12",
							"venta": "<#b1911a>10",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 5,
							"cuantos_agarrables" : 3,
							"titulo" : "Overflow Pack",
							"descripcion" : "<#296e8f>Gives <#296e8f>5 Normal Dominos, but randomly destroys 2 unknown ones from your collection.\n<#296e8f>(3)",
	},
	
	# HECHO ///////////////////////////////
	"Inverted Pack": {
							"size": Vector2(32, 32),
							"position": Vector2(64, 160),
							"plata": "<#b1911a>20",
							"venta": "<#b1911a>10",
							"chance": 5,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": true,
							"tipo_domino" : "normal",
							"stamps" : false,
							"cuantos" : 4,
							"cuantos_agarrables" : 1,
							"titulo": "Inverted Pack",
							"descripcion": "<#e0483e>Deletes a Whole Color of Dominos."
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
	
	# HECHO ///////////////////////////////
	"Stamper" : {
							"size" : Vector2(32,32),
							"position" : Vector2(0,128),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["maximo_stampas"],
							"accion" : ["+2"],
							
							"titulo" : "Stamper",
							"descripcion" : "<#296e8f>Allows you to have up to <#e0483e>3 <#e0483e>stamps in a single domino.",
	},
	
	
	# HECHO ///////////////////////////////
	"Jump Man": {
							"size": Vector2(32, 32),
							"position": Vector2(32, 128),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
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
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
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
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
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
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
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
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" :   ["max_cards_specials_in_store", "max_cards_normal_in_store"],
							"accion" : ["_4"                         , "_4"],
							
							"titulo": "<#b1911a>Gold Cart",
							"descripcion": "<#296e8f>Gives <#296e8f>+1 Extra Normal and <#267864>Special Domino in the shop. (invalidates the other carts)"
	},
	
	
	# HECHO ///////////////////////////////
	"Silver Cart": {
							"size": Vector2(32, 32),
							"position": Vector2(192, 128),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["max_cards_normal_in_store"],
							"accion" : ["_4"],
							
							"titulo": "Silver Cart",
							"descripcion": "<#296e8f>Gives <#296e8f>+1 <#296e8f>Extra Normal Domino in the shop."
	},
	
	
	# HECHO ///////////////////////////////
	"Special Cart": {
							"size": Vector2(32, 32),
							"position": Vector2(224, 128),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["max_cards_specials_in_store"],
							"accion" : ["_4"],
							
							"titulo": "<#267864>Special Cart",
							"descripcion": "<#296e8f>Gives <#296e8f>+1 <#296e8f>Extra <#267864>Special Domino in the shop."
	},
	
	
	# HECHO ///////////////////////////////
	"Gold Stamp": {
							"size": Vector2(32, 32),
							"position": Vector2(256, 128),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["dominos_en_shop_tener_stamps"],
							"accion" : ["+1"],
							
							"titulo": "<#b1911a>Gold Stamp",
							"descripcion": "All Dominos in the Shop have a chance to have <#e0483e>stamps."
	},
	
	
	# HECHO ///////////////////////////////
	"Silver Stamp": {
							"size": Vector2(32, 32),
							"position": Vector2(288, 128),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["normales_pueden_tener_stamps"],
							"accion" : ["+1"],
							
							"titulo": "Silver <#e0483e>Stamp",
							"descripcion": "Normal Dominos in the Shop have a chance to have <#e0483e>stamps."
	},
	
	
	# HECHO ///////////////////////////////
	"Discount Tag": {
							"size": Vector2(32, 32),
							"position": Vector2(320, 128),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
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
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["packs_pueden_tener_stamps"],
							"accion" : ["+1"],
							
							"titulo": "Stampack",
							"descripcion": "All the Packs of Dominos Could have <#e0483e>stamps with them."
	},
	
	
	# HECHO ///////////////////////////////
	"Rose Scroll": {
							"size": Vector2(32, 32),
							"position": Vector2(384, 128),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["rose_%"],
							"accion" : ["+25"],
							
							"titulo": "<#e48b7c>Rose Scroll",
							"descripcion": "<#e0483e>Double the base chance of getting <#e48b7c>Rose Dominos."
	},
	
	
	# HECHO ///////////////////////////////
	"Orange Scroll": {
							"size": Vector2(32, 32),
							"position": Vector2(416, 128),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["orange_%"],
							"accion" : ["+25"],
							
							"titulo": "<#f3983a>Orange Scroll",
							"descripcion": "<#e0483e>Double the base chance of getting <#f3983a>Orange Dominos."
	},
	
	
	# HECHO ///////////////////////////////
	"Blue Scroll": {
							"size": Vector2(32, 32),
							"position": Vector2(448, 128),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["blue_%"],
							"accion" : ["+25"],
							
							"titulo": "<#3c4368>Blue Scroll",
							"descripcion": "<#e0483e>Double the base chance of getting <#3c4368>Blue Dominos."
	},
	
	
	# HECHO ///////////////////////////////
	"Green Scroll": {
							"size": Vector2(32, 32),
							"position": Vector2(0, 160),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["green_%"],
							"accion" : ["+25"],
							
							"titulo": "<#235955>Green Scroll",
							"descripcion": "<#e0483e>Double the base chance of getting <#235955>Green Dominos."
	},
	
	
	# HECHO ///////////////////////////////
	"Random Scroll": {
							"size": Vector2(32, 32),
							"position": Vector2(32, 160),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat_por_level" : ["<rose;green;orange;blue>_%"],
							"accion_por_level" : ["+25"],
							
							"titulo": "Random Scroll",
							"descripcion": "<#e0483e>Double the base chance of getting a random Color per level.  \n<#296e8f>("
	},
	
	
	# HECHO ///////////////////////////////
	"Silver Plate": {
							"size": Vector2(32, 32),
							"position": Vector2(128, 160),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["max_cards_in_hand"],
							"accion" : ["+1"],
							
							"titulo": "Silver Plate",
							"descripcion": "<#296e8f>1+ <#296e8f>Extra Normal Domino in hand."
	},
	
	
	# HECHO ///////////////////////////////
	"Special Plate": {
							"size": Vector2(32, 32),
							"position": Vector2(160, 160),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["max_specials_cards_in_hand"],
							"accion" : ["+1"],
							
							"titulo": "<#267864>Special Plate",
							"descripcion": "<#296e8f>1+ <#296e8f>Extra <#267864>Special Domino in hand."
	},
	
	
	# HECHO ///////////////////////////////
	"Domino Sticker": {
							"size": Vector2(32, 32),
							"position": Vector2(192, 160),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["dominos_on_gamezone"],
							"accion" : ["+1"],
							
							"titulo": "Domino Sticker",
							"descripcion": "<#296e8f>Allows you to have <#296e8f>+1 <#296e8f>Extra Domino in the <#e0483e>Game <#e0483eZone."
	},
	
	
	# HECHO ///////////////////////////////
	"Domino Tag": {
							"size": Vector2(32, 32),
							"position": Vector2(224, 160),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["dominos_on_gamezone"],
							"accion" : ["+1"],
							
							"titulo": "Domino Tag",
							"descripcion": "<#296e8f>Allows you to have <#296e8f>+1 <#296e8f>Extra Domino in the <#e0483e>Game <#e0483eZone."
	},
	
	
	# HECHO ///////////////////////////////
	"Trash Bag": {
							"size": Vector2(32, 32),
							"position": Vector2(256, 160),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["cantidad_de_borrables_por_tienda"],
							"accion" : ["+2"],
							
							"titulo": "Trash Bag",
							"descripcion": "<#296e8f>Allows you to <#e0483e>Delete up to <#296e8f>3 dominos per shop."
	},
	
	
	# HECHO ///////////////////////////////
	"Black Hole": {
							"size": Vector2(32, 32),
							"position": Vector2(288, 160),
							"plata": "<#b1911a>16",
							"venta": "<#b1911a>8",
							"chance": 6,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["poder_repetir_amuletos"],
							"accion" : ["+1"],
							
							"titulo": "<r;392d57;4b3576;5d3c95;7043b4;5d3c95;4b3576;392d57>Black <r;392d57;4b3576;5d3c95;7043b4;5d3c95;4b3576;392d57>Hole",
							"descripcion": "<#296e8f>Allows you to encounter <#e0483e>charms that you already have."
	},
	
	
	# HECHO ///////////////////////////////
	"Coin Blessing" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(448,32),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["level_plata_mult"],
							"accion" : ["x1.1"],
							
							"titulo" : "<#b1911a>Coin <#b1911a>Blessing",
							"descripcion" : "Gives you <#296e8f>10% <#296e8f>extra <#b1911a>coins every level cleared.",
	},
	
	
	# HECHO ///////////////////////////////
	"Greed's Touch" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(224,64),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["plata_mult"],
							"accion" : ["x1.25"],
							
							"titulo" : "<#b1911a>Greed's <#b1911a>Touch",
							"descripcion" : "<#e0483e>Multiplies all <#b1911a>coin rewards from other items by <#e0483e>x1.25.",
	},
	
	
	# HECHO ///////////////////////////////
	"Box of Scraps" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(192,96),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["max_amuletos"],
							"accion" : ["+3"],
							
							"titulo" : "Box of Scraps",
							"descripcion" : "Let's you have <#296e8f>3 <#296e8f>extra <#e0483e>charms.",
	},
	# //////   STATS //////   STATS //////   STATS //////   STATS //////   STATS //////   STATS //////
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	# HECHO ///////////////////////////////
	"Rose Ascendant" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(320,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#e48b7c>Rose Ascendant",
							"descripcion" : "<#296e8f>50% of fallen Rose dominos get a permanent <#296e8f>+1 every time they are used.",
	},
	
	# HECHO ///////////////////////////////
	"Orange Ascendant" :  {
							"size" : Vector2(32,32),
							"position" : Vector2(352,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#f3983a>Orange Ascendant",
							"descripcion" : "<#296e8f>50% of fallen Orange dominos get a permanent <#296e8f>+1 every time they are used.",
	},
	
	# HECHO ///////////////////////////////
	"Blue Ascendant" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(384,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#3c4368>Blue Ascendant",
							"descripcion" : "<#296e8f>50% of fallen Blue dominos get a permanent <#296e8f>+1 every time they are used.",
	},
	
	# HECHO ///////////////////////////////
	"Green Ascendant" :    {
							"size" : Vector2(32,32),
							"position" : Vector2(416,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#235955>Green Ascendant",
							"descripcion" : "<#296e8f>50% of fallen Green dominos get a permanent <#296e8f>+1 every time they are used.",
	},
	
	# HECHO ///////////////////////////////
	"Rose Flourish" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(448,0),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#e48b7c>Rose Flourish",
							"descripcion" : "<#296e8f>50% of fallen Rose dominos get <#e0483e>x1.6 every time they are used.",
	},
	
	# HECHO ///////////////////////////////
	"Orange Flourish" :    {
							"size" : Vector2(32,32),
							"position" : Vector2(0,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#f3983a>Orange Flourish",
							"descripcion" : "<#296e8f>50% of fallen Orange dominos get <#e0483e>x1.6 every time they are used.",
	},
	
	# HECHO ///////////////////////////////
	"Blue Flourish" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(32,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#3c4368>Blue Flourish",
							"descripcion" : "<#296e8f>50% of fallen Blue dominos get <#e0483e>x1.6 every time they are used.",
	},
	
	# HECHO ///////////////////////////////
	"Green Flourish" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(64,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#235955>Green Flourish",
							"descripcion" : "<#296e8f>50% of fallen Green dominos get <#e0483e>x1.6 every time they are used.",
	},
	
	# HECHO ///////////////////////////////
	"Rose Resurgence" :    {
							"size" : Vector2(32,32),
							"position" : Vector2(224,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#e48b7c>Rose Resurgence",
							"descripcion" : "The fewer Rose dominos there are, the higher the chance they appear.",
	},
	
	# HECHO ///////////////////////////////
	"Orange Resurgence" : {
							"size" : Vector2(32,32),
							"position" : Vector2(256,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#f3983a>Orange Resurgence",
							"descripcion" : "The fewer Orange dominos there are, the higher the chance they appear.",
	},
	
	# HECHO ///////////////////////////////
	"Blue Resurgence" :    {
							"size" : Vector2(32,32),
							"position" : Vector2(288,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#3c4368>Blue Resurgence",
							"descripcion" : "The fewer Blue dominos there are, the higher the chance they appear.",
	},
	
	# HECHO ///////////////////////////////
	"Green Resurgence" :  {
							"size" : Vector2(32,32),
							"position" : Vector2(320,32),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 13,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#235955>Green Resurgence",
							"descripcion" : "The fewer Green dominos there are, the higher the chance they appear.",
	},
	
	# HECHO ///////////////////////////////
	"Rose Bloom" :          {
							"size" : Vector2(32,32),
							"position" : Vector2(352,32),
							"plata": "<#b1911a>12",
							"venta": "<#b1911a>7",
							"chance": 10,  # algo menos común  
							"nivel_desbloqueo" : 1,
							"aniadido" : 0.0,
							"usable": false,
							"titulo" : "<#e48b7c>Rose Bloom",
							"descripcion" : "<#296e8f>50% chance for every Rose dominos that scores to <#296e8f>gain <#296e8f>+0.2 color <#e0483e>multiplier (max <#e0483e>x2). \n<#296e8f>(now <#296e8f>: <#296e8f>",
	},
	
	# HECHO ///////////////////////////////
	"Orange Delight" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(384,32),
							"plata": "<#b1911a>12",
							"venta": "<#b1911a>7",
							"chance": 10,  # algo menos común  
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#f3983a>Orange Delight",
							"descripcion" : "Orange dominos give <#b1911a>2c.",
	},
	
	# HECHO ///////////////////////////////
	"Domino Surge" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(416,32),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>4",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Domino Surge",
							"descripcion" : "If a chain contains 5 or more dominos of a single color, that color gets a permanent <#e0483e>+.5 in it's <#e0483e>multiplier.",
	},
	
	# HECHO ///////////////////////////////
	"Final Wish" :          {
							"size" : Vector2(32,32),
							"position" : Vector2(0,64),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Final Wish",
							"descripcion" : "The last play of the level <#e0483e>multiplies by <#e0483e>three the <#e0483e>global <#e0483e>multiplier.",
	},
	
	# HECHO ///////////////////////////////
	"Augmented Chance" :  {
							"size" : Vector2(32,32),
							"position" : Vector2(32,64),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>4",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Augmented Chance",
							"descripcion" : "Items with chance-based effects get <#e0483e>x2 activation chance. Additional copies increase this <#e0483e>multiplier by <#e0483e>1.",
	},
	
	# HECHO ///////////////////////////////
	"Coin Strike" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(64,64),
							"plata": "<#b1911a>12",
							"venta": "<#b1911a>8",
							"chance": 14,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#b1911a>Coin <#b1911a>Strike",
							"descripcion" : "There is a <#296e8f>20% chance for every domino to give you <#b1911a>2c.",
	},
	
	# HECHO ///////////////////////////////
	"Combo Trinity" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(96,64),
							"plata": "<#b1911a>7",
							"venta": "<#b1911a>5",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Combo Trinity",
							"descripcion" : "If all the normal dominos in a single play are 7 or 8, <#296e8f>adds +3 to the <#e0483e>global <#e0483e>multiplier.", #you get 3 or more patterns/combos 
	},
	
	# HECHO ///////////////////////////////
	"Chain Dealer" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(128,64),
							"plata": "<#b1911a>11",
							"venta": "<#b1911a>8",
							"chance": 8,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Chain Dealer",
							"descripcion" : "<#e0483e>Multiplies <#e0483e>global <#e0483e>mult by <#e0483e>x2 per domino exceeding the amount of 6 (7 = <#e0483e>x2, 8 = <#e0483e>x2x2).", # global multiplier
	},
	
	# HECHO ///////////////////////////////
	"Lucky Break" :        {
							"size" : Vector2(32,32),
							"position" : Vector2(160,64),
							"plata": "<#b1911a>9",
							"venta": "<#b1911a>7",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Lucky Break",
							"descripcion" : "<#296e8f>5% chance to repeat the play.", # without any combos.
	},
	
	# HECHO ///////////////////////////////
	"Stack Overflow" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(192,64),
							"plata": "<#b1911a>6",
							"venta": "<#b1911a>2",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Stack Overflow",
							"descripcion" : "Creates copies in your bag of all the normal dominos used in the play.", # Every combo type <#296e8f>adds <#296e8f>+5 to the combo's score
	},
	
	# HECHO ///////////////////////////////
	"Echo Pattern" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(256,64),
							"plata": "<#b1911a>15",
							"venta": "<#b1911a>10",
							"chance": 8,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Echo Pattern",
							"descripcion" : "Repeats the last 3 dominos of the play.", # combo
	},
	
	# HECHO ///////////////////////////////
	"Domino Paradox" :    {
							"size" : Vector2(32,32),
							"position" : Vector2(288,64),
							"plata": "<#b1911a>7",
							"venta": "<#b1911a>5",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Domino Paradox",
							"descripcion" : "The first and last domino in a chain both <#296e8f>gain <#296e8f>+10.",
	},
	
	# HECHO ///////////////////////////////
	"Overgrowth" :          {
							"size" : Vector2(32,32),
							"position" : Vector2(320,64),
							"plata": "<#b1911a>7",
							"venta": "<#b1911a>5",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Overgrowth",
							"descripcion" : "If you play 5 or more dominos of the same color, that color <#296e8f>gains <#296e8f>+10 spawn chance.",
	},
	
	# HECHO ///////////////////////////////
	"Fading Luck" :        {
							"size" : Vector2(32,32),
							"position" : Vector2(352,64),
							"plata": "<#b1911a>11",
							"venta": "<#b1911a>2",
							"chance": 8,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Fading Luck",
							"descripcion" : "<#296e8f>Adds <#296e8f>+80 each play, it reduces by 10 permanently after each use. \n<#296e8f>(now <#296e8f>: <#296e8f>",
	},
	
	# HECHO ///////////////////////////////
	"Gold Medal" :          {
							"size" : Vector2(32,32),
							"position" : Vector2(384,64),
							"plata": "<#b1911a>7",
							"venta": "<#b1911a>5",
							"chance": 11,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#b1911a>Gold Medal",
							"descripcion" : "The first 3 dominos of every level score <#e0483e>x1.6 of base value.", #combo
	},
	
	# HECHO ///////////////////////////////
	"Gold Seed" :           {
							"size" : Vector2(32,32),
							"position" : Vector2(416,64),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>4",
							"chance": 7,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#b1911a>Gold Seed",
							"descripcion" : "Every <#b1911a>50c owned grants a <#e0483e>x2 <#e0483e>global <#e0483e>multiplier.",
	},
	
	# HECHO ///////////////////////////////
	"Gold Tree" :        {
							"size" : Vector2(32,32),
							"position" : Vector2(448,64),
							"plata": "<#b1911a>11",
							"venta": "<#b1911a>8",
							"chance": 7,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#b1911a>Gold Tree",
							"descripcion" : "Every <#b1911a>100c owned grants a <#e0483e>x5 <#e0483e>global <#e0483e>multiplier.",
	},
	
	# HECHO ///////////////////////////////
	"Trickster's Bloom" : {
							"size" : Vector2(32,32),
							"position" : Vector2(0,96),
							"plata": "<#b1911a>14",
							"venta": "<#b1911a>10",
							"chance": 7,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Trickster's Bloom",
							"descripcion" : "Each time a <#e0483e>charm activates at the end of a play, there's a <#296e8f>10% chance for it to activate up to 2 times.",
	},
	
	# HECHO ///////////////////////////////
	"Fifth is the charm" : {
							"size" : Vector2(32,32),
							"position" : Vector2(32,96),
							"plata": "<#b1911a>13",
							"venta": "<#b1911a>10",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Fifth is the charm",
							"descripcion" : "Every five <#e0483e>charm activations, this <#e0483e>repeats the last <#e0483e>charm's effect.",
	},
	
	# HECHO ///////////////////////////////
	"Chain Lock" :        {
							"size" : Vector2(32,32),
							"position" : Vector2(64,96),
							"plata": "<#b1911a>7",
							"venta": "<#b1911a>5",
							"chance": 12,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Chain Lock",
							"descripcion" : "<#296e8f>Gain <#b1911a>+10c if all dominos in the play have no consecutive colors.",
	},
	
	# HECHO ///////////////////////////////
	"Domino Spirit" :     {
							"size" : Vector2(32,32),
							"position" : Vector2(96,96),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Domino Spirit",
							"descripcion" : "The last domino played in a level permanently <#296e8f>gains <#296e8f>+15 base value.",
	},
	
	# HECHO ///////////////////////////////
	"Crystal Shard" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(128,96),
							"plata": "<#b1911a>14",
							"venta": "<#b1911a>9",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["max_amuletos"],
							"accion" : ["-4"],
							
							"titulo" : "Crystal Shard",
							"descripcion" : "Each <#e0483e>charm activates 2 times, but this takes up 4 slots.", #combo
	},
	
	# HECHO ///////////////////////////////
	"Puzzle Piece" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(160,96),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Puzzle Piece",
							"descripcion" : "If the same domino repeats 3 times in a level, <#296e8f>+2 to the global multiplier.", #combo
	},
	
	# HECHO ///////////////////////////////
	"Sun Pendant" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(224,96),
							"plata": "<#b1911a>10",
							"venta": "<#b1911a>8",
							"chance": 10,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Sun Pendant",
							"descripcion" : "Get the amount of <#e0483e>charms owned as <#e0483e>global <#e0483e>multiplier.",
	},
	
	# HECHO ///////////////////////////////
	"Amber Core" :        {
							"size" : Vector2(32,32),
							"position" : Vector2(256,96),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>6",
							"chance": 16,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Amber Core",
							"descripcion" : "When an Orange domino starts a the play, grants <#296e8f>+2 to all other Oranges permanently after the play.",
	},
	
	# HECHO ///////////////////////////////
	"Sea Shell" :         {
							"size" : Vector2(32,32),
							"position" : Vector2(288,96),
							"plata": "<#b1911a>9",
							"venta": "<#b1911a>6",
							"chance": 16,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Sea Shell",
							"descripcion" : "When a play ends with a Blue domino, <#296e8f>gain <#b1911a>+5c.",
	},
	
	# HECHO ///////////////////////////////
	"Easy Money" :          {
							"size" : Vector2(32,32),
							"position" : Vector2(320,96),
							"plata": "<#b1911a>13",
							"venta": "<#b1911a>8",
							"chance": 16,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "<#b1911a>Easy <#b1911a>Money",
							"descripcion" : "Get half the score of the last domino in <#b1911a>coins.",
	},
	
	# HECHO ///////////////////////////////
	"Rusty Scale" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(352,96),
							"plata": "<#b1911a>11",
							"venta": "<#b1911a>2",
							"chance": 14,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"stat" : ["amuletos_gratis_por_tienda"],
							"accion" : ["+1"],
							
							"titulo" : "Rusty Scale",
							"descripcion" : "Gives you get one free <#e0483e>charm each shop.",
	},
	
	# HECHO ///////////////////////////////
	"Domino Mask" :       {
							"size" : Vector2(32,32),
							"position" : Vector2(384,96),
							"plata": "<#b1911a>17",
							"venta": "<#b1911a>1",
							"chance": 4,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Domino Mask",
							"descripcion" : "Transfomrs into the next <#e0483e>charm you buy.", # one away from a combo
	},
	
	# HECHO ///////////////////////////////
	"Black Ink" :         {
							"size" : Vector2(32,32),
							"position" : Vector2(416,96),
							"plata": "<#b1911a>8",
							"venta": "<#b1911a>5",
							"chance": 8,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Black Ink",
							"descripcion" : "<#e0483e>Missing a color in your deck gives <#e0483e>+5 <#e0483e>global <#e0483e>multiplier per absent color.",
	},
	
	# HECHO ///////////////////////////////
	"Crystal Dice" :      {
							"size" : Vector2(32,32),
							"position" : Vector2(448,96),
							"plata": "<#b1911a>17",
							"venta": "<#b1911a>10",
							"chance": 4,  # algo menos común
							"nivel_desbloqueo" : 1,
							"usable": false,
							"titulo" : "Crystal Dice",
							"descripcion" : "<#e0483e>Mimics one random <#e0483e>charm at the start of a level <#296e8f>(temporary). <#e0483e>\n(",
	},
	
	# HECHO ///////////////////////////////
	"Giant's Tear Drop": {
							"size": Vector2(32, 32),
							"position": Vector2(96, 160),
							"plata": "<#b1911a>7",
							"venta": "<#b1911a>4",
							"chance": 8,
							"nivel_desbloqueo" : 1,
							"usable": false,
							
							"titulo": "Giant Tear Drop",
							"descripcion": "<#e0483e>5% chance of getting all the points in a play as <#b1911a>coins."
	},
#	"Gold Bracelet": {
#							"size": Vector2(32, 32),
#							"position": Vector2(320, 160),
#							"plata": "<#b1911a>10",
#							"venta": "<#b1911a>10",
#							"chance": 3,
#							"nivel_desbloqueo" : 1,
#							"usable": false,
#							
#							"titulo": "<#b1911a>Gold Bracelet",
#							"descripcion": "algo."
#	},
}



