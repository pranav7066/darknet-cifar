# Usage:
# ./predict.sh <filename>

echo $1 | ./darknet classify cfg/cifar.cfg cifar.weights
