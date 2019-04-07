#!/bin/bash

# The world's simplest database written in Bash, borrwed from 
# _Designing Data-Intensive Applications_ by Kleppmann (2017) p.70
# Note: sed command only properly works on Linux, syntax slightly different on macOS 

db_set() {
  echo "$1,$2" >> database
}

db_get() {
  grep "^$1," database | sed -e "s/^$1,//" | tail -n 1
}
