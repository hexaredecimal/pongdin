package game

import bl "../ball"
import pl "../player"
import "core:strings"
import rl "vendor:raylib"

Game :: struct {
	show_menu: bool,
	play:      bool,
}

new_game :: proc() -> Game {
	return Game{true, false}
}

play_game :: proc(
	player: ^pl.Player,
	player2: ^pl.Player,
	ball: ^bl.Ball,
	game: ^Game,
	sounds: GameSounds,
) {
	if bl.check_collision(player^, ball^) {
		rl.PlaySound(sounds.tennis_hit)
		ball.dy *= -1
		hit_position := (ball.pos.x - player.pos.x) / f32(player.width)
		max_angle := f32(0.8)
		angle := hit_position * max_angle
		ball.dx = angle * (player2.dx * ball.dx) + player2.speed / 2
		if hit_position < 0.5 do ball.dx *= -1
	}

	if bl.check_collision(player2^, ball^) {
		rl.PlaySound(sounds.tennis_hit)
		ball.dy *= -1
		hit_position := (ball.pos.x - player.pos.x) / f32(player.width)
		max_angle := f32(0.8)
		angle := hit_position * max_angle
		ball.dx = angle * (player2.dx * ball.dx) + player2.speed / 2
		if hit_position < 0.5 do ball.dx *= -1
	}

	if bl.is_death(ball^) {
		player.health -= 1
		if player.health <= 0 do player.health = 0
		rl.PlaySound(sounds.loss)
	}

	player2.pos.x = ball.pos.x - f32(player2.width) / 2

	if player.health > 0 {
		pl.draw_player(player^)
		pl.draw_player(player2^)
		bl.draw_ball(ball^)
		bl.move_ball(ball)

		pl.move_player(player)
		pl.draw_player_health(player^)
	} else {
		game.play = false
	}
}

handle_game_over :: proc(
	using game: ^Game,
	sounds: GameSounds,
	player: ^pl.Player,
	ball: ^bl.Ball,
) {
	if rl.IsKeyPressed(.SPACE) {
		game.play = true
		game.show_menu = false
		bl.reset(ball)
		pl.reset(player)
		rl.PlaySound(sounds.lockandload)
		stop_game_over_music(sounds)
	} else if rl.IsKeyPressed(.M) {
		game.play = false
		game.show_menu = true
		stop_game_over_music(sounds)
		bl.reset(ball)
		pl.reset(player)
	}
}
