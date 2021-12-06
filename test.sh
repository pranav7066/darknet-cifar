if [ ! -f ./darknet ]; then
    echo 'You must build your implementation with `make` before trying to test it.'
    exit 1
fi

function predict () {
./darknet classifier predict cfg/cifar.data cfg/cifar.cfg cifar.weights >/dev/stdout 2>&1
}

TIME=$({ time { find data/cifar/test | sort | sed -n '1!p' | head -n $1 | predict 2>&1;} | grep '%' > participant-results.txt; } 2>&1 | grep real | awk '{ print $2 }')

NUM_IMAGES=$1

OUTPUT_DIFF=$(diff -u <( cat reference-results.txt | head -n $(( NUM_IMAGES * 2 )) ) <( cat participant-results.txt ))

if [ -n "$OUTPUT_DIFF" ];
then
  echo -e '\033[0;31mTests did not pass!\033[0m'
  echo $OUTPUT_DIFF
else
  echo -ne '\033[0;32mTests passed.\033[0m  '
  SEC=$(echo $TIME | sed 's/m/*60+/g' | sed 's/s//g' | bc)
  AVERAGE=$(echo "$SEC / $NUM_IMAGES" | bc -l | sed 's/0*$//g' | sed 's/^\./0./g')
  echo "$AVERAGE seconds per image." 
fi

