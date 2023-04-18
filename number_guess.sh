#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

# read -p  "Enter your username:" USERNAME (replaced to pass tests)
echo "Enter your username:"
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

REPS=0
# NUMBER=$(shuf -i 1-1000 -n1) (replaced to pass tests)
NUMBER=$(( RANDOM % 1000 + 1 ))
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
#get user's data from db
GAMES=$($PSQL "select games_played from users where username='$USERNAME'")
BEST=$($PSQL "select best_game from users where username='$USERNAME'")
#calculate updated values
let "UPDATED_GAMES=GAMES+1"
if [[ $REPS -lt $BEST ]] && [[ $BEST -ne 0 ]]
then
  UPDATED_BEST=$REPS
elif [[ $BEST -eq 0 ]]
then
  UPDATED_BEST=$REPS
else
  UPDATED_BEST=$BEST
fi
#update DB
UPDATE=$($PSQL "update users set games_played=$UPDATED_GAMES, best_game=$UPDATED_BEST where username='$USERNAME'")