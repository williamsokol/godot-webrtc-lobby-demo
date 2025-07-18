extends PanelContainer

@export var lineEdit:LineEdit
@export var chatLog:TextEdit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#lineEdit.text_submitted.connect(SendChat)
	#chatLog. 
	#InputEvent.
	pass # Replace with function body.
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER && lineEdit.is_editing():
			SendChat.rpc(lineEdit.text.replace('\n',""))
			
@rpc("any_peer","call_local")
func SendChat(text):
	chatLog.text += "\n"  + text
	chatLog.scroll_vertical = chatLog.get_line_count()
	lineEdit.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
