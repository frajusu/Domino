extends Node




func ejectutar_jugada():
	if !get_tree().root.has_node("Game"):
		return
	
	get_tree().root.get_node("Game").baraja_activa = "ejecutando"
	
