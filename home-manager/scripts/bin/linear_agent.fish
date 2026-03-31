#!/usr/bin/env fish

set ticket_id $argv[1]

workmux add -A -p "Fix this ticket:

$(linear $ticket_id)

When you are finished create a PR with the github cli and request review from philip@normain.com"
