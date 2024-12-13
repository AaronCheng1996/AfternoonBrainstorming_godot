extends Label

@onready var message: Label = $"."
@onready var message_timer: Timer = $message_timer

func pop_message(text: String) -> void:
	message.text = text
	message.show()
	message_timer.start()

func _on_message_timer_timeout() -> void:
	message.hide()
