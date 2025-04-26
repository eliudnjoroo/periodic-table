#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    QUERY="$($PSQL "select * from properties inner join elements using (atomic_number) inner join types using (type_id) where atomic_number = '$1';")"
  elif [[ ${#1} -lt 3 ]]
  then
    QUERY="$($PSQL "select * from properties inner join elements using (atomic_number) inner join types using (type_id) where symbol = '$1';")"
  else
    QUERY="$($PSQL "select * from properties inner join elements using (atomic_number) inner join types using (type_id) where name = '$1';")"
  fi

  if [[ -z $QUERY ]]
  then
    echo I could not find that element in the database.
  else
    echo $QUERY | 
    while IFS="|" read TYPE_ID ATOMIC_NUMBER ATOMIC_MASS MELTING BOILING SYMBOL NAME TYPE 
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi
