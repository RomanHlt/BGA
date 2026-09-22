class_name InputHelper

static func get_key_name(action: String) -> String:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			if event.physical_keycode != 0:
				var keycode := DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
				return OS.get_keycode_string(keycode)
			elif event.keycode != 0:
				return OS.get_keycode_string(event.keycode)
			elif event.key_label != 0:
				return OS.get_keycode_string(event.key_label)
	return "?"
