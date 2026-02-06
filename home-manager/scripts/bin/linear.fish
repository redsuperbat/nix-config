#!/usr/bin/env fish

if test (count $argv) -eq 0
    echo "Usage: linear <ticket-id>"
    echo "Example: linear NOR-1580"
    exit 1
end

set ticket_id $argv[1]

if not set -q LINEAR_API_KEY
    echo "Error: LINEAR_API_KEY environment variable not set"
    exit 1
end

set query '{"query": "query { issue(id: \"'$ticket_id'\") { id identifier title description state { name } priority priorityLabel assignee { name } project { name } labels { nodes { name } } createdAt updatedAt } }"}'

curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: $LINEAR_API_KEY" \
    -d "$query" \
    https://api.linear.app/graphql | jq '.data.issue'
