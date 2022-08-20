#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$(($RANDOM % 1000 + 1))
TURNS=0

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

echo $NUMBER

echo "Guess the secret number between 1 and 1000:"
until [[ $GUESS == $NUMBER ]]; do
  read GUESS

  if [[ ! $GUESS =~ ^[0-9]+$ ]];then
    echo "That is not an integer, guess again:"
  elif [[ $GUESS -lt $NUMBER ]]; then
    echo "It's lower than that, guess again:"
  elif [[ $GUESS -gt $NUMBER ]]; then
    echo "It's higher than that, guess again:"
  fi

  (( TURNS++ ))
done

RESULT=$($PSQL "INSERT INTO games (name,turns) VALUES ('$NAME',$TURNS)")

echo "You guessed it in $TURNS tries. The secret number was $NUMBER. Nice job!"