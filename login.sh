#!/usr/bin/fish

if test -e 'auth'
	rm auth
end

set post '{"user":{"email":"$username","password":"$password"}}'

set username (cat username)
set password (cat password)

set post (string replace '$password' $password $post)

curl -s https://api.focusatwill.com/api/v4/sign_in.json -H 'Content-Type: application/json' -d $post > response_sign_in.json

jq .authentication_token response_sign_in.json | cut -d\" -f2 > auth
