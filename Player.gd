extends CharacterBody2D

const SPEED = 2000

var cloud_collision_position = null
var in_cloud = false

func _process(delta):
	
	# Cheeky movement script
	velocity *= 0.9
	velocity += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED * delta
	move_and_slide()
	
	# Raycast in the direction of velocity - by the time we collide with the cloud it might be too late, so we just run this in process()
	$RayCast2D.global_position = global_position
	$RayCast2D.target_position = velocity.normalized() * 1000
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		cloud_collision_position = $RayCast2D.get_collision_point()
	queue_redraw()

func _draw():
	if cloud_collision_position != null: 
		draw_circle(cloud_collision_position - global_position, 10, Color.RED)

# Becuase we set collision point in _process(), we can just use that point when we do collide
func _on_cloud_entered(area):
	$CPUParticles2D.global_position = cloud_collision_position
	$CPUParticles2D.emitting = true

# When we exit the cloud, we just do the exact same thing but point the ray backward, and use that position immediatly
func _on_cloud_exited(area):
	$RayCast2D.global_position = global_position
	$RayCast2D.target_position = velocity.normalized() * -1000
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		cloud_collision_position = $RayCast2D.get_collision_point()
		$CPUParticles2D.global_position = cloud_collision_position
		$CPUParticles2D.emitting = true
