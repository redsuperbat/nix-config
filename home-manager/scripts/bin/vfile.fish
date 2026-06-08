#!/usr/bin/env fish
set rand_file /tmp/rand_(random).txt
nvim $rand_file
cat $rand_file
rm $rand_file
