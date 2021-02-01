# Focus@Will-CLI

The scripts in this repository are available mainly as a reference for your own implementation
of the Focus@Will API, since I suspect not many people use Fish Shell.

If you do use Fish and wish to use these scripts, continue on to the Dependencies and Usage sections.


# Dependencies:

* cURL: sending requests and downloading tracks.
* jq: extracting data from json, quick and easy.
* MPV: for playing tracks.

# Usage

1. Create two files in the same directory:  `username` which contains only your focus@will username/email, and `password` with the password.
2. Run `login.sh`. This gets an authentication token back, written to the `auth` file.
3. Run `play.sh` whenever you wish to tune into the zone.

# Focus@Will API

The (undocumented) Focus@will API  makes it fairly easy to implement a simple client:

1. https://api.focusatwill.com/api/v4/sign_in.json wants a username and password, and in return gives us information about the user along with an auth token.
2. https://api.focusatwill.com/api/v4/fetch_sequence_track.json allows us to ask for a song of the desired channel, intensity. In return, we get a track back, including its ID and an expiring URL to the MP3 file.
3. https://api.focusatwill.com/api/v4/playing_track.json allows us to signal to the server that we are currently playing a song (by ID, we must use the ID we got back from fetch_sequence_track). When we do this, the server seems to advance the randomizer.

Additionally, the 2nd and 3rd endpoints expect these special values:

- `slot_index`: the song index for the current session. (a new session begins when we hit the play button)
- `total_played`: total songs played since the client was started. (in a browser, that means how many songs since we loaded the page)

If we do not invoke `playing_track.json`, the randomization never advances and thus we will always get the same track back for any given `slot_index`. Note that `total_played` does not appear to have any relevance over the song that will play. 
