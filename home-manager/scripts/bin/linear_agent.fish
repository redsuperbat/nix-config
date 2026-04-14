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
set issue_query '{"query": "query { issue(id: \"'$ticket_id'\") { id team { states { nodes { id name } } } } }"}'
set issue_response (curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: $LINEAR_API_KEY" \
    -d "$issue_query" \
    https://api.linear.app/graphql)
set issue_id (echo $issue_response | jq -r '.data.issue.id')
set in_progress_id (echo $issue_response | jq -r '.data.issue.team.states.nodes[] | select(.name == "In Progress") | .id')

# Assign to current user and set to In Progress
set update_query '{"query": "mutation { issueUpdate(id: \"'$issue_id'\", input: { assigneeId: \"'$user_id'\", stateId: \"'$in_progress_id'\" }) { success } }"}'
curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: $LINEAR_API_KEY" \
    -d "$update_query" \
    https://api.linear.app/graphql >/dev/null

workmux add -A -p "Fix this ticket:

$(linear $ticket_id)

When you are finished create a PR with the github cli and request review from PhilipNgo"
