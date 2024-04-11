#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    winner_id="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    if [[ -z $winner_id ]]
    then
      winner_request="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      winner_id="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    fi

    opponent_id="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    if [[ -z $opponent_id ]]
    then
      opponent_rquest="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      opponent_id="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    fi

    games_request="$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES('$YEAR', '$ROUND', '$WINNER_GOALS', '$OPPONENT_GOALS', '$winner_id', '$opponent_id')")"
  fi
done;
