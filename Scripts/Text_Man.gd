extends Node




func parsear_colores_bbcode1(texto: String) -> String:
	var resultado := ""
	var palabras := texto.split(" ")
	
	for palabra in palabras:
		# Detectar rainbow: <r;color;color;color>texto
		if palabra.begins_with("<r;") and ">" in palabra:
			var fin = palabra.find(">")
			var header = palabra.substr(0, fin+1)   # "<r;008125;0014ff;ff0000>"
			var resto = palabra.substr(fin+1)       # "Palabra"
			
			# extraer colores
			var partes = header.replace("<", "").replace(">", "").split(";")
			# partes[0] == "r"
			var colores := []
			for i in range(1, partes.size()):
				colores.append(partes[i])
			
			# construir rainbow letra por letra
			var out := ""
			for i in range(resto.length()):
				var col = colores[i % colores.size()]
				out += "[color=#%s]%s[/color]" % [col, resto[i]]
			
			resultado += out + " "
			continue
		
		# Tag normal tipo <#FF0000>Palabra
		if palabra.begins_with("<#") and ">" in palabra:
			var fin2 = palabra.find(">")
			var hex = palabra.substr(0, fin2 + 1)
			hex = hex.replace("<", "").replace(">", "")
			var resto2 = palabra.substr(fin2 + 1)
			resultado += "[color=%s]%s[/color] " % [hex, resto2]
			continue
		
		# palabra normal
		resultado += palabra + " "
	
	return resultado.strip_edges()


func parsear_colores_bbcode(texto: String) -> String:
	var resultado := ""
	var i := 0
	# ahora solo son separadores los whitespace
	var separadores := [" ", "\t", "\n", "\r"]
	
	while i < texto.length():
		# Detectar "<#"
		if i <= texto.length() - 2 and texto[i] == '<' and texto[i+1] == '#':
			var cierre := texto.find(">", i)
			# Si no hay cierre, copiamos el '<' y seguimos
			if cierre == -1:
				resultado += texto[i]
				i += 1
				continue
			
			var hex := texto.substr(i + 1, cierre - (i + 1))  # ejemplo: "#FF0000"
			
			# Validar que empiece con #
			if not hex.begins_with("#"):
				resultado += texto[i]
				i += 1
				continue
			
			# Avanzar despues de ">"
			i = cierre + 1
			
			# Capturar todo hasta el primer whitespace (incluye signos y puntuacion)
			var inicio_palabra := i
			while i < texto.length() and not (texto[i] in separadores):
				i += 1
			
			var palabra := texto.substr(inicio_palabra, i - inicio_palabra)
			
			# Fallback si no hay palabra
			if palabra == "":
				resultado += "[color=%s]%s[/color]" % [hex, hex]
			else:
				resultado += "[color=%s]%s[/color]" % [hex, palabra]
			
			# continuar: el separador actual (si lo hay) sera procesado por el bucle principal
			continue
		
		# Si no es un tag, copiar el caracter normal
		resultado += texto[i]
		i += 1
	
	return resultado


func preparar_rainbow_datos(bbcode_label: RichTextLabel, nodo_propio):
	nodo_propio.posision_inicial_rainbow.clear()
	
	var texto = bbcode_label.bbcode_text
	var i = 0
	
	while i < texto.length():
	
		# buscamos el primer "[color=#"
		if texto.substr(i).begins_with("[color=#"):
			var inicio_bloque = i
			var letras = []
			var colores = []
			
			# mientras siga habiendo [color=#xxxxxx]
			while texto.substr(i).begins_with("[color=#"):
				var cierre_tag = texto.find("]", i)
				if cierre_tag == -1:
					break
				
				# obtener color
				var tag = texto.substr(i, cierre_tag - i + 1)  # "[color=#xxxxxx]"
				var col_hex = tag.split("#")[1].split("]")[0]
				colores.append(col_hex)
				
				# obtener letra
				var cierre2 = texto.find("[/color]", cierre_tag)
				if cierre2 == -1:
					break
				
				var letra = texto.substr(cierre_tag + 1, cierre2 - (cierre_tag + 1))
				letras.append(letra)
				
				# mover i después de [/color]
				i = cierre2 + 8  # len("[/color]")
			
			var fin_bloque = i - 1
			
			# si hay mas de 1 letra = es rainbow
			if letras.size() > 1:
				nodo_propio.posision_inicial_rainbow.append({
					"inicio": inicio_bloque,
					"fin": fin_bloque,
					"letras": letras,
					"colores": colores
				})
			
			continue
		
		# caracter normal
		i += 1


func ciclar_rainbow(bbcode_label: RichTextLabel, nodo_propio):
	var texto = bbcode_label.bbcode_text
	
	for data in nodo_propio.posision_inicial_rainbow:
		var inicio = data.inicio
		
		# rotar colores (importante: duplicate!)
		var colores = data.colores.duplicate()
		var ultimo = colores[colores.size() - 1]
		for i in range(colores.size() - 1, 0, -1):
			colores[i] = colores[i - 1]
		colores[0] = ultimo
		
		# guardar los colores nuevos para el proximo ciclo
		data.colores = colores
		
		# reconstruir bbcode
		var nuevo = ""
		for i in range(data.letras.size()):
			nuevo += "[color=#%s]%s[/color]" % [colores[i], data.letras[i]]
		
		# reemplazar en el texto original
		texto = texto.substr(0, inicio) + nuevo + texto.substr(data.fin + 1)
		
		# actualizar indices por la diferencia de largo
		var diff = nuevo.length() - ((data.fin - data.inicio) + 1)
		data.fin += diff
	
	preparar_rainbow_datos(bbcode_label, nodo_propio)
	# aplicar al label
	bbcode_label.bbcode_text = texto

