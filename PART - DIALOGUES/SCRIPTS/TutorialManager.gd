extends Node

signal move_learned
signal jump_learned
signal interact_learned
signal swap_c_learned
signal swap_d_learned

var moved_q := false
var moved_d := false
var interacted := false
var jumped := false
var swaped_d := false
var swaped_c := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		moved_q = true
		_check_done()
	elif event.is_action_pressed("move_right"):
		moved_d = true
		_check_done()
	elif event.is_action_pressed("jump"):
		jumped = true
		_check_done()
	elif event.is_action_pressed("interagir"):
		interacted = true
		_check_done()
	elif event.is_action_pressed("closerLayer"):
		swaped_c = true
		_check_done()
	elif event.is_action_pressed("deeperLayer"):
		swaped_d = true
		_check_done()

func _check_done() -> void:
	if moved_q and moved_d:
		move_learned.emit()
	if jumped:
		jump_learned.emit()
	if interacted:
		interact_learned.emit()
	if swaped_c:
		swap_c_learned.emit()
	if swaped_d:
		swap_d_learned.emit()


## Fonction appelée depuis le dialogue, elle bloque tant que ce n'est pas fait
func wait_for_move() -> void:
	if moved_q and moved_d:
		return
	await move_learned

func wait_for_jump():
	if jumped: # Si on a sauté c'est bon
		return
	await jump_learned # Sinon on attend le moment ou on saute puis c'est bon

func wait_for_interact():
	if interacted:
		return
	await interact_learned

func wait_for_swap_d():
	if swaped_d:
		return
	await swap_d_learned

func wait_for_swap_c():
	if swaped_c:
		return
	await swap_c_learned
