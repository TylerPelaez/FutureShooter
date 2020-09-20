extends Area2D

export var damage := 1

func _on_Hitbox_area_entered(hurtbox):
	var pos = global_position
	var angle = global_rotation 
	hurtbox.emit_signal("hit", damage, pos, angle)
