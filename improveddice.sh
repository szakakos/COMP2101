numsides=6
bias=1
echo"Rolling"
die1=$((RANDOM % $numsides + $bias))
die2=$((RANDOM % $numsides + $bias))
sum=$((die1+die2))
average = $((sum/2))

echo "Rolled $die1, $die2)
echo "The rolls summed $sum"
echo "The average roll was $average"