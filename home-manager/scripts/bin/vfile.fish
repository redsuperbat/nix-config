#!/usr/bin/env fish
set rand_file /tmp/rand_(random).txt
nvim $rand_file </dev/tty >/dev/tty 2>&1
cat $rand_file
rm $rand_file
