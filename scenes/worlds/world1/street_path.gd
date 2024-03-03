extends Path2D

class_name StreetPath

@export var traffic_lights: Array[TrafficLight] = []
@export var traffic_stop_offsets: Array[float] = []

## Returns the index of the next traffic stop, 
## otherwise -1 if there are no traffic stops or all traffic stops passed
func get_next_traffic_stop_index(offset: float) -> int:
	for i in range(len(traffic_stop_offsets)):
		var stop_offset = traffic_stop_offsets[i]
		if stop_offset > offset:
			return i
	return -1


