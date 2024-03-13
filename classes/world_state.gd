extends RefCounted

class_name WorldState

signal bad_tackle_count_changed(count: int)
signal max_bad_tackle_count_reached

var max_bad_tackle_count: int = 3
var _max_bad_tackle_count_reached_emitted := false

var bad_tackle_count: int = 0:
	set(v):
		if v == bad_tackle_count:
			return
		bad_tackle_count = v
		bad_tackle_count_changed.emit(bad_tackle_count)
		if bad_tackle_count >= max_bad_tackle_count and not _max_bad_tackle_count_reached_emitted:
			max_bad_tackle_count_reached.emit()
			_max_bad_tackle_count_reached_emitted = true
	get:
		return bad_tackle_count


