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

set response (curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: $LINEAR_API_KEY" \
    -d "$query" \
    https://api.linear.app/graphql)

echo $response | jq -r '
.data.issue |
"# \(.identifier): \(.title)

## Details
- **Status:** \(.state.name)
- **Priority:** \(.priorityLabel // "None")
- **Assignee:** \(.assignee.name // "Unassigned")
- **Project:** \(.project.name // "None")
- **Labels:** \(if .labels.nodes | length > 0 then ([.labels.nodes[].name] | join(", ")) else "None" end)
- **Created:** \(.createdAt)
- **Updated:** \(.updatedAt)

## Description
\(.description // "No description provided.")

## Suggested Branch Names
```
\(.identifier | ascii_downcase)-\(.title | ascii_downcase | gsub("[^a-z0-9]+"; "-") | gsub("^-|-$"; ""))
```
"'
