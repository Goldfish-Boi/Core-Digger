extends Line2D

@export var length = 20
@export var active = false

var point = Vector2()

func _process(_delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	
	point = get_parent().global_position
	
	if active == true:
		add_point(point)
	
	if get_point_count() > length or active == false:
		remove_point(0)
