echo "Please give me the first number";read firstnum
echo "Please give me the second number";read secondnum
echo "Please give me the third number";read thirdnum

sum=$((firsnum + secondum + thirdnum))
product=$((firstnum * secondnum * thirdnum))

cat <<EOF
Your number summed = $sum
Your numbers multiplied = $product
EOF