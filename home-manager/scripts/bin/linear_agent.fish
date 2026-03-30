#!/usr/bin/env fish

set ticket_id argv[0]

workmux add -A -p "$(linear $ticket_id)"
