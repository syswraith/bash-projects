#!/usr/bin/env bash

function auth() {
  curl -s -o /dev/null 'https://www.etechschoolonline.com/login.htm' -c cookie.txt
  COOKIE=$(cat cookie.txt | grep -Eo "[0-9A-Z]{32}")
  rm cookie.txt

  curl -s -o /dev/null 'https://www.etechschoolonline.com/j_spring_security_check' \
    -H "Cookie: JSESSIONID=$COOKIE" \
    --data-raw "j_logincode=khsbaner&j_username=$1&j_password=$2&j_idt48=j_idt48&j_idt48%3AbtnLogin=&javax.faces.ViewState=7316503297059879101%3A-6469100250549994161"

  curl -L 'https://www.etechschoolonline.com/student.htm' \
    -H "Cookie: JSESSIONID=$COOKIE"
}

if [[ $# == 0 ]]; then
  echo 'Provide username and password (optional)'
elif [[ $# == 1 ]]; then
  password=$1
  echo 'Getting userinfo'
  auth "$1" "$password"
elif [[ $# == 2 ]]; then
  username=$1
  password=$2
  echo 'Getting userinfo'
  auth "$username" "$password"
elif [[ $# > 2 ]]; then
  echo "ERR! Provide username and password (optional)"
fi
