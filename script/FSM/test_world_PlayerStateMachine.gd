extends FSM

func _ready():
	self.init_FSM()
	self.add_relation($WalkState as State, $NullState as State)
	self.add_relation($NullState as State, $WalkState as State)
