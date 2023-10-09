extends Node2D

@onready var svc: SubViewportContainer = $SubViewportContainer
@onready var label: Label = $Label

var pallettes : Array[GradientTexture1D]
var p_names : PackedStringArray
var p_index := 0
var display_name : bool = false


func _ready() -> void:
	load_palettes("6")
	DirAccess.make_dir_recursive_absolute("user://palettes")
	ResourceSaver.save(
		pallettes[p_index],
		"user://palettes/example.tres"
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event.is_action_pressed("ui_left"):
		p_index -= 1
		if p_index < 0:
			p_index = pallettes.size() - 1
		set_palette(p_index)
	elif event.is_action_pressed("ui_right"):
		p_index += 1
		if p_index >= pallettes.size():
			p_index = 0
		set_palette(p_index)
	elif event is InputEventKey:
		if not event.pressed:
			return
		match event.keycode:
			KEY_0:
				load_palettes("0")
			KEY_2:
				load_palettes("2")
			KEY_3:
				load_palettes("3")
			KEY_4:
				load_palettes("4")
			KEY_5:
				load_palettes("5")
			KEY_6:
				load_palettes("6")
			KEY_7:
				load_palettes("7")
			KEY_8:
				load_palettes("8")
			KEY_F:
				load_palettes("flag")
			KEY_U:
				load_palettes("user")
			KEY_D:
				print("ASSSSSSSSSSSS")
				display_name = not display_name

func set_palette(index: int) -> void:
	svc.material.set_shader_parameter("gradient", pallettes[index])
	print(p_names[index])
	print(display_name)
	if display_name:
		print("ASDASDASD")
		label.text = p_names[index].replace(".tres", "")
		print(label.text)
		label.modulate = Color.WHITE
		await get_tree().create_timer(3.0).timeout
		var tween := get_tree().create_tween()
		tween.tween_property(label, "modulate", Color(Color.WHITE, 0), 0.1)
		await tween.finished
		label.text = ""
		label.modulate = Color.WHITE


func load_palettes(folder: String) -> void:
	pallettes.clear()
	p_names.clear()
	var location : String = "res://palettes/%s" % folder if folder != "user" else "user://palettes"
	for p in DirAccess.get_files_at(location):
		pallettes.append(load("{0}/{1}".format([location, p])))
		p_names.append(p)
	p_index = p_index % pallettes.size()
	set_palette(p_index)
