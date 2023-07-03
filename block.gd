extends StaticBody2D

var hp = 3

func damage(value: int):
	hp -= 1
	if hp <= 0:
		queue_free()
