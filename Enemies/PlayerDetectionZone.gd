extends Area2D

export var VISION_RANGE := 50

#TODO: not tunnel vision on 1 player / hologram

var playerExited = true
var detectedPlayer = false
var player = null

# Raycast to player position, with appropriate mask, check if we hit player or world
func canSeePlayer():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, player.global_position, [self], getPlayerAndWorldMask())
	if result != null and result.collider == player:
		return true
	else:
		return false

func _on_PlayerDetectionZone_body_exited(body):
	player = null
	playerExited = true
	detectedPlayer = false

func _on_PlayerDetectionZone_body_entered(body):
	player = body
	playerExited = false
	if canSeePlayer():
		detectedPlayer = true

# Expected that this will be called by the parent node in physics process step
func isAwareOfPlayer():
	# Shortcut to avoid unnecesary raycasts
	if playerExited:
		return false
	
	var canSeePlayer = canSeePlayer()
	
	if detectedPlayer and !canSeePlayer:
		detectedPlayer = false
	elif not playerExited and not detectedPlayer and canSeePlayer:
		detectedPlayer = true
	
	return detectedPlayer

# So the zone's parent can know where the player is, without needing to also hold on to a reference to the player
func getPlayerPosition():
	return player.global_position

func getPlayerAndWorldMask():
	return pow(2, 0) + pow(2, 1)
