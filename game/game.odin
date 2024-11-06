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
		rl.PlaySound(sounds.game_over)
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
