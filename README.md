# Focus@Will-CLI

The scripts in this repository are available mainly as a reference for your own implementation
of the Focus@Will API, since I suspect not many people use Fish Shell.

If you do use Fish and wish to use these scripts, continue on to the Dependencies and Usage sections.


# Dependencies:

* cURL: sending requests and downloading tracks
* joq: extracting data from json, quick and easy
* MPV: for playing tracks

# Usage

1. Create two files in the same directory:  `username` which contains only your focus@will username/email, and `password` with the password.
2. Run `login.sh`. This gets an authentication token back, written to the `auth` file.
3. Run `play.sh` whenever you wish to tune into the zone.
