tool
extends HBoxContainer
class_name OptionButtonEx
# OptionButton with a descriptive Label component

signal item_focused(index) # int
signal item_selected(index) # int

export(String) var description := "Descriptive Label:" setget set_description
export(Array, String) var options setget set_options
export(int) var selected := -1 setget set_selected

export(String, "Left", "Center", "Right") var align_style := "Left" setget set_align_style

onready var description_node := $LabelEx
onready var option_button_node := $OptionButton

func set_description(new_description: String) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	description = new_description
	
	description_node.text = description

func set_options(new_options: Array) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	options = new_options
	
	#prints("Set options:", options)
	option_button_node.clear()
	for option in options:
		option_button_node.add_item(option)
	
	# Reassign in case the size has changed (e.g. reduce index if invalid now)
	self.selected = selected
	
	property_list_changed_notify()

func set_selected(new_selected: int) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	selected = clamp(new_selected, -1, options.size() - 1) as int
	
	option_button_node.selected = selected

func set_align_style(new_align_style: String) -> void:
	if not is_inside_tree(): yield(self, "ready"); _on_ready()
	align_style = new_align_style
	
	match align_style:
		"Left":
			move_child(option_button_node, description_node.get_index() + 1)
			description_node.align = Label.ALIGN_LEFT
			description_node.visible = true
			option_button_node.align = OptionButton.ALIGN_LEFT
		"Center":
			description_node.visible = false
		"Right":
			move_child(description_node, option_button_node.get_index() + 1)
			description_node.align = Label.ALIGN_RIGHT
			description_node.visible = true
			option_button_node.align = OptionButton.ALIGN_RIGHT

func _on_OptionButton_item_focused(index: int) -> void:
	emit_signal("item_focused", index)

func _on_OptionButton_item_selected(index: int) -> void:
	selected = index
	emit_signal("item_selected", selected)

func _on_ready() -> void:
	if not description_node: description_node = $LabelEx
	if not option_button_node: option_button_node = $OptionButton
