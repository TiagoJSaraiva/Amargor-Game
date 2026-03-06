extends PlayerNodesBehavior
# SCRIPT QUE CONTROLA O VISUAL DO PLAYER

@onready var visual = $Sprite

# "Aliases" pra facilitar escrita de código
var AS = Player.ActionState
var LS = Player.LocomotionState
var LifeS = Player.LifeState
var BS = Player.BodyState

func update(action_state: Player.ActionState,
			locomotion_state: Player.LocomotionState, 
			life_state: Player.LifeState, 
			body_state: Player.BodyState
):
	if action_state == LifeS.DEAD:
		pass
