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