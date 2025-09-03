# lukas runtime

Google defines CPU time as follows:

To convert CPU time percentage to CPU time, multiply the percentage by the total elapsed time. For example, if a process uses 50% of the CPU over a total elapsed time of 10 seconds, the CPU time would be 5 seconds (0.50 x 10).

For measuring the CPU and Real Time, the program was run with the inputs:
lukas 1000000 24

The average CPU utilization was 13.4, and it took 21.2 seconds to run. Therefore the CPU time is 2.84.
The ratio of CPU time to Real time is 7.46. The number of cores on the machine is 8.

# Work Unit

The best work unit was determined to be 256 calculations per actor. We determined this by running the program with various work unit sizes and measuring the time taken to complete the program.

# Largest Problem

The largest problem that lukas managed to solve was:
lukas 50000000 24


# Output

The output for running lukas 1000000 4

There were no values that matched the lukas constraint.



