#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
#echo $WINNER , $OPPONENT
#check if the name of the team is literally winner or opponent to skip that line
if [[ "$WINNER" == "winner" || "$OPPONENT" == "opponent" ]]
then 
continue
fi
#check end

#inputs unique values of winners and opponents as the team names into the database
	#variable to check if the next team name is unique
	IS_WINNER_UNIQUE="$($PSQL "SELECT name FROM teams WHERE name='$WINNER';")"
        IS_OPPONENT_UNIQUE="$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT';")"
	#checks if the name is unique and inputs it if so
    
	if [[ -z "$IS_WINNER_UNIQUE" ]]
	then
	$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
	fi
	if [[ -z "$IS_OPPONENT_UNIQUE" ]]
	then
	$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
	fi

#echo $WINNER , $OPPONENT

#variables to get winner_id and opponent_id
WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")"
OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")"
#enters YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS into the games table
$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")

done < games.csv
