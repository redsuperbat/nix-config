#!/usr/bin/env fish

set ticket_id $argv[1]

if not set -q LINEAR_API_KEY
    echo "Error: LINEAR_API_KEY environment variable not set"
    exit 1
end

# Get the current user's ID
set me_query '{"query": "query { viewer { id } }"}'
set me_response (curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: $LINEAR_API_KEY" \
    -d "$me_query" \
    https://api.linear.app/graphql)
set user_id (echo $me_response | jq -r '.data.viewer.id')

# Get the issue ID and the "In Progress" state ID for the issue's team
set issue_query '{"query": "query { issue(id: \"'$ticket_id'\") { id identifier title team { states { nodes { id name } } } } }"}'
set issue_response (curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: $LINEAR_API_KEY" \
    -d "$issue_query" \
    https://api.linear.app/graphql)
set issue_id (echo $issue_response | jq -r '.data.issue.id')
set in_progress_id (echo $issue_response | jq -r '.data.issue.team.states.nodes[] | select(.name == "In Progress") | .id')
set branch_name (echo $issue_response | jq -r '(.data.issue.identifier | ascii_downcase) + "-" + (.data.issue.title | ascii_downcase | gsub("[^a-z0-9]+"; "-") | gsub("^-|-$"; ""))')

# Assign to current user and set to In Progress
set update_query '{"query": "mutation { issueUpdate(id: \"'$issue_id'\", input: { assigneeId: \"'$user_id'\", stateId: \"'$in_progress_id'\" }) { success } }"}'
curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: $LINEAR_API_KEY" \
    -d "$update_query" \
    https://api.linear.app/graphql >/dev/null

workmux add "$branch_name" -p "Plan out what changes are needed to fix this ticket:

$(linear $ticket_id)

When you are finished please present the plan and wait for approval before implementing."
