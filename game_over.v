module game_over(bikeone_crash, biketwo_crash, bikethree_crash, bikefour_crash, four_player_mode, game_finished);
	input bikeone_crash, biketwo_crash, bikethree_crash, bikefour_crash, four_player_mode;
	output game_finished;
	
	wire game_finished_two, game_finished_four, game_finished_four_a, game_finished_four_b, game_finished_four_c, game_finished_four_d;
	or or_game_two(game_finished_two, bikeone_crash, biketwo_crash);
	
	and and_game_four_a(game_finished_four_a, biketwo_crash, bikethree_crash, bikefour_crash);
	and and_game_four_b(game_finished_four_b, bikeone_crash, bikethree_crash, bikefour_crash);
	and and_game_four_c(game_finished_four_c, bikeone_crash, biketwo_crash, bikefour_crash);
	and and_game_four_d(game_finished_four_d, bikeone_crash, biketwo_crash, bikethree_crash);
	or or_game_four(game_finished_four, game_finished_four_a, game_finished_four_b, game_finished_four_c, game_finished_four_d);
	
	assign game_finished = four_player_mode ? game_finished_four:game_finished_two;
endmodule