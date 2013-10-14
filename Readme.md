Cassandra Performance
=====================

Simple script to test the cassandra performance in different usage scenarios,
and generate query query time graphs.

What you need
-------------
* Cassandra up and running accessible via default port on localhost
* Ruby 1.9 or higher
* Rscript for graphing
* Basic shell tools like awk such for data cleanup

Setup
-----

    $ bundle install
    $ forman start # optional!

Foreman will start a forground cassandra process, this is optional, just needed
if no cassandra is running on the local machine

Usage
-----
For a complete roundtrip of cleaning up the Database, initializing the test
columnfamily, running the benchmark, cleaning the data and graphing the results
run

    $ rake benchmark:empty_keys | ./clean_data.sh - | ./graph_time.r

To benchmark the query performance for empty keys, the result will be in the
file Rplots.pdf

For more benchmarks run

    $ rake -T



