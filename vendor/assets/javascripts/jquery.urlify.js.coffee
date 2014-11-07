$.urlify = (value, isEditing=false) -> 
	# turn spaces into dashes and convert to lowercase
	value = value.toLowerCase().replace(/\s+/g, "-")

	# Replace all non word characters and dashes with nothing 
	# and dashes at the beginning of the name with nothing
	value = value.replace(/[^\w\-]/g, "").replace(/^[\-]+/g, "")

	# If we're editing, don't replace dashes at the end, it'd be frustrating
	value = value.replace(/[\-]+$/g, "") unless isEditing

	# Reduce all multiple dashed to a single dash
	value = value.replace(/[\-]+/g, "-")

	value
