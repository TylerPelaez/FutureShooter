extends Area2D

export var VISION_RANGE := 50

#TODO: not tunnel vision on 1 player / hologram

var mainPlayer = null
var backupPlayer = null

# Raycast to player position, with appropriate mask, check if we hit player or world
func canSeePlayerCharacter(character_seeking):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, character_seeking.global_position, [self], getPlayerAndWorldMask())
	if result != null and result.collider == character_seeking:
		return true
	else:
		return false

func _on_PlayerDetectionZone_body_exited(body):
	if mainPlayer == body:
		# either mainPlayer is now null, or the previous backup is now the main target.
		mainPlayer = backupPlayer
	
	backupPlayer = null

func _on_PlayerDetectionZone_body_entered(body):
	if mainPlayer != null:
		backupPlayer = body
	else:
		mainPlayer = body

# Expected that this will be called by the parent node in physics process step
# this is 100% cheesable, maybe risky tho
func getTarget():
	# Shortcut to avoid unnecesary raycasts
	if mainPlayer == null:
		return null
	
	var canSeeMainPlayer = canSeePlayerCharacter(mainPlayer)
	
	if !canSeeMainPlayer:
		if backupPlayer != null:
			var canSeeBackupPlayer = canSeePlayerCharacter(backupPlayer)
			if canSeeBackupPlayer:
				var temp = mainPlayer
				mainPlayer = backupPlayer
				backupPlayer = temp
				
				return mainPlayer
		return null
	else:
		return mainPlayer

func getPlayerAndWorldMask():
	return pow(2, 0) + pow(2, 1)
