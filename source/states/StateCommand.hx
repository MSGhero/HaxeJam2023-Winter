package states;

enum StateCommand {
	REGISTER_STATE(state:State, tag:Int);
	REGISTER_ENTER(to:Int, callback:()->Void);
	REGISTER_EXIT(from:Int, callback:()->Void);
	ENTER(state:Int);
	EXIT(state:Int);
}