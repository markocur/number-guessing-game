#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

echo -e "Enter your username:"
read USERNAME
CHECK_USER=$($PSQL "select username from users where username='$USERNAME'")

if [[ -z $CHECK_USER ]]
then
  #add user to database
  ADD_USER=$($PSQL "insert into users values('$USERNAME',0,0)")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  # greet user and give info about his games
  USER_DATA=$($PSQL "select * from users where username='$USERNAME'")
  echo "$USER_DATA" | while read USERNAME BAR GAMES BAR BEST 
  do
    echo "Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST guesses."
  done
fi

NUMBER=$(shuf -i 1-1000 -n1)
echo $NUMBER
REPS=0
echo "Guess the secret number between 1 and 1000:"
read GUESS
while :
do
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    (( REPS++ ))
    read GUESS
  else
    if (( $GUESS > $NUMBER ))
    then
      echo "It's lower than that, guess again:"
      (( REPS++ ))
      read GUESS
    elif (( $GUESS < $NUMBER ))
    then
      echo "It's higher than that, guess again:"
      (( REPS++ ))
      read GUESS
    else
      (( REPS++ ))
      echo "You guessed it in $REPS tries. The secret number was $NUMBER. Nice job!"
      break
    fi
  fi
done
