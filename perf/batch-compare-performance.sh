#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage   : $0  Test-file                     "
    echo "Example : $0  /cygdrive/d/tmp/large-test.log"
    exit -1
fi

script=$(dirname $0)/compare-performance.sh
TestFile=$1

echo "# Case-1: Both found"
$script $TestFile  Exception "Error.*found"

echo "# Case-2: Both found, simpler regex"
$script $TestFile  Exception "[0-9]*Exception[0-9]*"

echo "# Case-3: Not found, partial matched both"
$script $TestFile  ExceptionX "[0-9]*ExceptionX[0-9]*"

echo "# Case-4: Not found, not matched"
$script $TestFile  Not-Exist "Not-exist.*"
