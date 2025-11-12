set -e

sim_type=$1
test_type=$2
test_name=$3

if [ "$sim_type" = "sim" ]; then
    make run_sim TESTTYPE=$test_type TESTNAME=$test_name
elif [ "$sim_type" = "gui" ]; then
    make run_gui TESTTYPE=$test_type TESTNAME=$test_name
fi
