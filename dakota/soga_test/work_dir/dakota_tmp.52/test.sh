
dprepro $1 in.tmp input.in --output-format="%f"

x1=$(cat input.in | cut -d "," -f 1)
x2=$(cat input.in | cut -d "," -f 2)
echo "$x1^2" | bc > $2
echo "($x2-3)^2" | bc >>$2
