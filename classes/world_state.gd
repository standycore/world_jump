extends RefCounted

class_name WorldState

signal bad_tackle_count_changed(count: int)

var bad_tackle_count: int = 0:
	set(v):
		if v == bad_tackle_count:
			return
		bad_tackle_count = v
		bad_tackle_count_changed.emit(bad_tackle_count)
	get:
		return bad_tackle_count


