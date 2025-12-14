extends Node2D

var p0 := Vector2(50, 400)
var p1 := Vector2(200, 100)
var p2 := Vector2(600, 100)
var p3 := Vector2(750, 400)

func _ready():
	update()

func _draw():
	draw_circle(p0, 6, Color.RED)
	draw_circle(p1, 6, Color.BLUE)
	draw_circle(p2, 6, Color.BLUE)
	draw_circle(p3, 6, Color.RED)

	draw_line(p0, p1, Color.GRAY, 2)
	draw_line(p1, p2, Color.GRAY, 2)
	draw_line(p2, p3, Color.GRAY, 2)

	var prev = p0
	for i in range(101):
		var t = i / 100.0
		var point = cubic_bezier(t, p0, p1, p2, p3)
		draw_line(prev, point, Color.YELLOW, 4)
		prev = point

func cubic_bezier(t, a, b, c, d):
	var ab = a.lerp(b, t)
	var bc = b.lerp(c, t)
	var cd = c.lerp(d, t)
	var ab_bc = ab.lerp(bc, t)
	var bc_cd = bc.lerp(cd, t)
	return ab_bc.lerp(bc_cd, t)
