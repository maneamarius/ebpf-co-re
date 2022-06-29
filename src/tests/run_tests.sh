#!/usr/bin/env bash

custom_test=$1

three_tests=( "cachestat" "dc" "fd" "mount" "process" "shm" "socket" "swap" "sync" "vfs" )
one_test=( "disk" "hardirq" "oomkill" "softirq" )

run_three_tests() {
    local test_to_run=$1

    echo "================  Running $test_to_run  ================"
    echo "---> Probe: "
    "./$test_to_run" --probe
    echo "---> Tracepoint: "
    "./$test_to_run" --tracepoint
    echo "---> Trampoline: "
    "./$test_to_run" --trampoline
    echo "  "
}

run_one_test() {
    local test_to_run=$1

    echo "================  Running $test_to_run  ================"
    "./$test_to_run"
    echo "  "
}

if [[ -n "$custom_test" ]]; then
    if [[ " ${three_tests[*]} " =~ " ${custom_test} " ]]; then
        run_three_tests $custom_test
    fi
    if [[ " ${one_test[*]} " =~ " ${custom_test} " ]]; then
        run_one_test $custom_test
    fi
else
    echo "Running all tests with three options"
    for i in "${three_tests[@]}" ; do
        run_three_tests $i
    done

    echo "Running all tests with single option"
    for i in "${one_test[@]}" ; do
        run_one_test $i
    done
    echo "We are not running filesystem or mdflush, because they can generate error, please run them."
fi

# ./filesystem
# ./md
