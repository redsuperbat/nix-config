#!/usr/bin/env fish

set ticket_id $argv[1]

workmux add -A -p "$(linear $ticket_id)"
