#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# if the input has letters in it
if [[ -n ${1//[0-9]/} ]]; then
  RESP="$(
  $PSQL "SELECT elements.atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
  FROM elements
  LEFT JOIN properties
  ON elements.atomic_number = properties.atomic_number
  LEFT JOIN types
  ON properties.type_id = types.type_id
  WHERE elements.symbol = '$1'
  OR elements.name = '$1';"
  )"
else
  RESP="$(
  $PSQL "SELECT elements.atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius 
  FROM elements
  LEFT JOIN properties
  ON elements.atomic_number = properties.atomic_number
  LEFT JOIN types
  ON properties.type_id = types.type_id
  WHERE elements.atomic_number = $1;"
  )"
fi

if [[ -z $RESP ]]
then 
  echo "I could not find that element in the database."
else
  echo $RESP | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
  do 
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
fi