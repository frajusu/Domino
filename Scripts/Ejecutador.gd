extends Node




func ejectutar_jugada(nodo):
#	if !get_tree().root.has_node("Game"):
#		return
#	get_tree().root.get_node("Game").baraja_activa = "ejecutando"
	print("______________________________________________________")
	
	recorrer_domino(nodo)


func recorrer_domino(d: Node) -> void:
	print(d.nombre, "        ", d.global_position)  # imprime el nombre del domino actual
	
	# buscar todos los slots dentro de este domino
	for slot in d.get_slots_in_self():
		if slot.hijo != null:
			recorrer_domino(slot.hijo)  # recursion
