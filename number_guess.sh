#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

echo -e "Enter your username"
read USERNAME
CHECK_USER=$($PSQL "select username from users where username='$USERNAME'")

if [[ -z $CHECK_USER ]]
then
  #add user to database
  ADD_USER=$($PSQL "insert into users values('$USERNAME',0,0)")
else
  # greet user and give info about his games
  echo Hello, $USERNAME!
fi