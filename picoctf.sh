#!/bin/bash

get_stats_by_diff() {
  curl -Ls "https://play.picoctf.org/api/users/$1/gym_stats/" | jq -r '.by_difficulty | to_entries[] | "\(.key) \(.value.solved) \(.value.available)"'
}

user1="$1"
user2="$2"

user1_id=$(curl -Ls "https://play.picoctf.org/api/users/$user1/" | jq -r '.id')
user2_id=$(curl -Ls "https://play.picoctf.org/api/users/$user2/" | jq -r '.id')

printf '\n'
printf "%-7s   | %15s | %15s | %-9s\n" "Level" "$user1" "$user2" "Leader"
printf '%.s-' {1..60}
printf '\n'

declare -A user1_solved
declare -A user1_total
declare -A user2_solved
declare -A user2_total

while read diff solved total; do
  user1_solved[$diff]=$solved
  user1_total[$diff]=$total
done < <(get_stats_by_diff "$user1_id")

while read diff solved total; do
  user2_solved[$diff]=$solved
  user2_total[$diff]=$total
done < <(get_stats_by_diff "$user2_id")

for diff in 1 2 3; do
  u1_s=${user1_solved[$diff]:-0}
  u1_t=${user1_total[$diff]:-0}
  u2_s=${user2_solved[$diff]:-0}
  u2_t=${user2_total[$diff]:-0}

  case $diff in
    1) level="easy" ;;
    2) level="medium" ;;
    3) level="hard" ;;
  esac

  if (( u1_s > u2_s )); then
    leader="$user1"
  elif (( u2_s > u1_s )); then
    leader="$user2"
  else
    leader="Tie"
  fi

  printf "%-7s   | %7s/%-7s | %7s/%-7s | %-9s\n" "$level" "$u1_s" "$u1_t" "$u2_s" "$u2_t" "$leader"
done
printf '\n'
