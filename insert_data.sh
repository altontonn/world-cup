#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE teams, games RESTART IDENTITY")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Inserting from winners table
  TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  if [[ -z $TEAM_ID_WINNER ]]
  then
    if [[ $WINNER != winner ]]
    then
      # insert team
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $WINNER"
      fi 
    fi
  fi

  # Inserting from opponent table
  TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  if [[ -z $TEAM_ID_OPPONENT ]]
  then
    if [[ $OPPONENT != opponent ]]
    then
    # insert team
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $OPPONENT"
      fi 
    fi
  fi

  # Inserting all games record
  if [[ $YEAR != year ]] 
  then
    #get the team id
    TEAM_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # echo $TEAM_WINNER 
    
    INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_WINNER, $TEAM_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)");
    if [[ $INSERT_GAMES == 'INSERT 0 1' ]]
    then
      echo "Inserted into games $YEAR $ROUND $TEAM_WINNER $TEAM_OPPONENT" 
    fi
  fi
done
