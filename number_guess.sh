#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$(($RANDOM % 1000 + 1))

echo "Enter your username:"
read NAME

USER=$($PSQL "SELECT name, COUNT(game_id), MIN(turns) FROM games WHERE name = '$NAME' GROUP BY name;")

if [[ -z $USER ]];then 
  echo "Welcome, $NAME! It looks like this is your first time here."
else 
  echo $USER | while IFS=\| read NAME COUNT BEST; do
    echo "Welcome back, $NAME! You have played $COUNT games, and your best game took $BEST guesses."
  done
fi