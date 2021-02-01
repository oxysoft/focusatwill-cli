#!/usr/bin/fish

# CONFIG ##########

set energy_level 1
set channel_id 2093
set slot_index 0
set total_played 1

###################


function post_fetch
	set auth (cat auth)
	set post '{"energy_level":$energy_level,"track_index":{"sequence_loop":0,"slot_index":$slot_index,"total_played":$total_played},"track_user_genre_id":$channel_id,"rate_limiter_total":1,"auth_token":"$auth","meta":{"client_version":"0.0.1","client":"cli"}}'

	set post (string replace '$energy_level' $energy_level $post)
	set post (string replace '$channel_id' $channel_id $post)

	set post (string replace '$slot_index' $slot_index $post)
	set post (string replace '$total_played' $total_played $post)
	set post (string replace '$auth' $auth $post)

	curl -s 'https://api.focusatwill.com/api/v4/fetch_sequence_track.json' -H 'Content-Type: application/json' --data-raw $post > response_fetch_sequence_track.json
	
	# Ask for the next track
	set -g track_path (jq .audio_file_url response_fetch_sequence_track.json | cut -d\" -f2)
	set -g track_id (jq .track_id response_fetch_sequence_track.json | cut -d\" -f2)
	
	# Download the track
	echo "Downloading track $slot_index: $track_id "
	curl -s $track_path > track.mp3
end

function post_announce
	set auth (cat auth)
	set post '{"track_id":$track_id,"track_index":{"sequence_loop":0,"slot_index":$slot_index,"total_played":$total_played},"channel_id":$channel_id,"channel_name":"Uptempo","energy_level":0,"auth_token":"$auth"}'

	set post (string replace '$track_id' $track_id $post)
	set post (string replace '$channel_id' $channel_id $post)

	set post (string replace '$slot_index' $slot_index $post)
	set post (string replace '$total_played' $total_played $post)

	set post (string replace '$auth' $auth $post)

	curl -s 'https://api.focusatwill.com/api/v4/playing_track.json' -H 'Content-Type: application/json' --data-raw $post > response_announce.json
end

while true
	post_fetch
	post_announce # This rolls the rng forward

	mpv track.mp3 --keep-open never

	set slot_index (math $slot_index + 1)
	set total_played (math $slot_index + 1)
end

