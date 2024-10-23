#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo -e "\n~~ INSERTING DATA ~~\n"

# empty table 
echo $($PSQL "TRUNCATE games, teams");
echo Table truncated completed.

# inserting 
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOAL O_GOAL
do
  if [[ $YEAR != year ]]
  then
    # get team_id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")


    # checking for winner team
    if [[ -z $WINNER_TEAM_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')");
      WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Team added :: $WINNER
      fi

    fi

    # checking for opponet team
    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')");
      OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Team added :: $OPPONENT
      fi
      
    fi

    # update team_id with new id
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $W_GOAL, $O_GOAL)");

  fi
  # echo $YEAR :: $ROUND :: $WINNER :: $OPPONENT :: $W_GOAL :: $O_GOAL
done
