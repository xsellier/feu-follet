extends Control

func capture_click():
  get_viewport().get_parent().set_process_input(true)
