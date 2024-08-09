extends Node

func start_server():
	MultiplayerManager.create_game()
	

func start_client():
	MultiplayerManager.join_game()

