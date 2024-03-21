#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ $# -eq 0 ]; then
  echo Please provide an element as an argument.
  exit
  
elif [[ "$1" =~ ^[0-9]+$ ]]; then
  RESULT="$($PSQL "SELECT * FROM elements e INNER JOIN properties p USING (atomic_number) INNER JOIN types USING (type_id) WHERE e.atomic_number='$1'")"
elif [[ "$1" =~ ^[A-Z][a-z]{2,}$ ]]; then
  RESULT="$($PSQL "SELECT * FROM elements e INNER JOIN properties p USING (atomic_number) INNER JOIN types USING (type_id) WHERE e.name = '$1'")"
elif [[ "$1" =~ ^[A-Z] ]]; then
  RESULT="$($PSQL "SELECT * FROM elements e INNER JOIN properties p USING (atomic_number) INNER JOIN types USING (type_id) WHERE e.symbol = '$1'")"
else
  echo "I could not find that element in the database."
  exit
fi

if [ -z "$RESULT" ]; then
  echo "I could not find that element in the database."
else
  echo "$RESULT" | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE;
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi
