@tool
class_name ResizableLabel extends Label

# Properties
# |===================================|
# |===================================|
# |===================================|



# Lifecycle
# |===================================|
# |===================================|
# |===================================|



# Signals
# |===================================|
# |===================================|
# |===================================|



# Methods
# |===================================|
# |===================================|
# |===================================|

func get_text_size() -> Vector2:
	return get_theme_default_font().get_string_size(text)