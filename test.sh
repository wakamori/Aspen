#!/bin/bash

export QUERY_STRING="int%20fib%28int%20n%29%20%7B%0D%0A%20%20if%28n%20%3C%203%29%20%7B%0D%0A%20%20%20%20return%201%3B%0D%0A%20%20%7D%0D%0A%20%20return%20fib%28n%20-%201%29%20%2B%20fib%28n%20-%202%29%3B%0D%0A%7D%0D%0ASystem.p%28fib%2830%29%29%3B";
./index.cgi
