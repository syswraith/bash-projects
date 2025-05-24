#!/bin/bash

get_solved_by_diff() {
  curl -Ls "https://play.picoctf.org/api/users/$1/gym_stats/" | jq -r ".by_difficulty | to_entries[] | \"\(.key) \(.value.solved)\""
}

user1="$1"
user2="$2"

user1_id=$(curl -Ls "https://play.picoctf.org/api/users/$user1/" | jq -r '.id')
user2_id=$(curl -Ls "https://play.picoctf.org/api/users/$user2/" | jq -r '.id')

printf '\n'
printf "%-7s   | %9s | %9s | %9s | %-9s\n" "Level" "$user1" "$user2" "Total" "Leader"
printf '%.s-' {1..60}
printf '\n'

declare -A user1_solved
declare -A user2_solved

while read diff solved; do
  user1_solved[$diff]=$solved
done < <(get_solved_by_diff "$user1_id")

while read diff solved; do
  user2_solved[$diff]=$solved
done < <(get_solved_by_diff "$user2_id")

for diff in 1 2 3; do
  u1=${user1_solved[$diff]:-0}
  u2=${user2_solved[$diff]:-0}
  total=$((u1 + u2))
  case $diff in
    1) level="easy" ;;
    2) level="medium" ;;
    3) level="hard" ;;
  esac
  if (( u1 > u2 )); then
    leader="$user1"
  elif (( u2 > u1 )); then
    leader="$user2"
  else
    leader="Tie"
  fi
  printf "%-7s   | %9d | %9d | %9d | %-9s\n" "$level" "$u1" "$u2" "$total" "$leader"
done
printf '\n'

