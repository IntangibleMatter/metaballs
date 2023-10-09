#@tool
extends Node2D

# Was an export, moved to a config file bc fuck you
var ball_count : int = 128

var balls : Array[Transform2D]
var sizes : PackedFloat32Array
var killing : PackedVector2Array
var spawning : PackedVector2Array

var INIT_V_MAX := 32.0
var INIT_V_MIN := 8.0
var MAX_V := 32.0
var INIT_A := 16.0
var MAX_A := 32.0
@export_range(0.1, 2.0) var SIZE_MIN := 0.6
@export_range(0.1, 2.0) var SIZE_MAX := 1.2
@export_range(0.0, 1.0) var gyration := 0.1


var half_width : float
var half_height : float

var tex := preload("res://ball.png")

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	half_height = get_viewport_rect().size.y/2 + 256
	half_width = get_viewport_rect().size.x/2 + 256
	randomize()
	
	get_ball_count()
	
	create_balls(ball_count)


func get_ball_count() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://balls.cfg") != OK:
		cfg.set_value("balls", "count", ball_count)
		cfg.set_value("balls", "size_min", SIZE_MIN)
		cfg.set_value("balls", "size_max", SIZE_MAX)
		cfg.set_value("balls", "gyration", gyration)
		cfg.set_value("balls", "init_velocity_min", INIT_V_MIN)
		cfg.set_value("balls", "init_velocity_max", INIT_V_MAX)
		cfg.set_value("balls", "velocity_max", MAX_V)
		cfg.set_value("balls", "accel_max", MAX_A)
		cfg.save("user://balls.cfg")
	else:
		ball_count = cfg.get_value("balls", "count", ball_count)
		SIZE_MIN = cfg.get_value("balls", "size_min", SIZE_MIN)
		SIZE_MAX = cfg.get_value("balls", "size_max", SIZE_MAX)
		gyration = cfg.get_value("balls", "gyration", gyration)
		INIT_V_MIN = cfg.get_value("balls", "init_velocity_min", INIT_V_MIN)
		INIT_V_MAX = cfg.get_value("balls", "init_velocity_max", INIT_V_MAX)
		MAX_V = cfg.get_value("balls", "velocity_max", MAX_V)
		MAX_A = cfg.get_value("balls", "accel_max", MAX_A)


func _process(delta: float) -> void:
	update_balls(delta)
	queue_redraw()


func create_balls(count: int) -> void:
	for ball in count:
		sizes.append(randf_range(SIZE_MIN, SIZE_MAX))
		balls.append(Transform2D(
			Vector2(randf_range(INIT_V_MIN, INIT_V_MAX) * sign(randf_range(-1, 1)), randf_range(INIT_V_MIN, INIT_V_MAX) * sign(randf_range(-1, 1))),
			Vector2.ZERO,#(randf_range(-INIT_A, INIT_A), randf_range(-INIT_A, INIT_A)),
			Vector2(randf_range(-half_width, half_width), randf_range(-half_height, half_height))
			))
		print(balls[-1])


func update_balls(delta: float) -> void:
	for ball in balls.size():
#		print(ball)
		balls[ball].y += Vector2(randf_range(-1, 1), randf_range(-1, 1))
		balls[ball].x += balls[ball].y * delta
#		prints(balls[ball].origin, balls[ball].origin + balls[ball].x)
		balls[ball].origin += balls[ball].x * delta
		balls[ball].y.x = clamp(balls[ball].y.x, -MAX_A, MAX_A)
		balls[ball].y.y = clamp(balls[ball].y.y, -MAX_A, MAX_A)
		balls[ball].x.x = clamp(balls[ball].x.x, -MAX_A, MAX_A)
		balls[ball].x.y = clamp(balls[ball].x.y, -MAX_A, MAX_A)
		if balls[ball].origin.y > half_height:
			balls[ball].origin.y = -half_height 
		elif balls[ball].origin.y < -half_height:
			balls[ball].origin.y = half_height
		elif balls[ball].origin.x > half_width:
			balls[ball].origin.x = -half_width
		elif balls[ball].origin.x < -half_width:
			balls[ball].origin.x = half_width
#
#func get_accel_diff(pos: Vector2) -> Vector2:
#	return pos.normalized() * -1


func _draw() -> void:
#	draw_rect(get_viewport_rect(), Color.BLACK)
#	draw_texture(tex, get_local_mouse_position())
#	prints(Time.get_ticks_msec(), "ASDASDASD")
	for ball in balls.size():
		## alternate version which enables scale
		var dsize : float = sizes[ball] + gyration * sin(Time.get_ticks_msec() / 1000.0 + ball * ball)\
		if fmod(sizes[ball], 0.1) == 0 else sizes[ball] + gyration * cos(Time.get_ticks_msec() / 1000.0 + ball * ball)
		draw_set_transform(balls[ball].origin, 0, Vector2(dsize, dsize))
		draw_texture(tex, Vector2.ZERO) 
#		draw_texture(tex, balls[ball].origin, Color(Color.WHITE, sizes[ball]))
