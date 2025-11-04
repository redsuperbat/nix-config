#!/usr/bin/env fish

# Parse arguments
set draft false
set manual_desc false

for arg in $argv
    switch $arg
        case -d --draft
            set draft true
        case -m --manual-desc
            set manual_desc true
    end
end

if $draft
    echo "Creating a draft PR"
end

# Get current branch name
set branch_name (git branch --show-current | string trim)

# Sync local changes to remote
echo "Syncing local changes to remote"
git push -u origin $branch_name

# Parse branch name to PR title
# Handles: nor-1580-automatic-refresh-of-page-when-a-new-version-is-available
function parse_branch_name_to_pr_title
    set parts (string split - $argv[1])
    set team $parts[1]
    set ticket_nr $parts[2]
    set desc_parts $parts[3..-1]

    set description ""
    for word in $desc_parts
        set capitalized (string sub -l 1 $word | string upper)(string sub -s 2 $word)
        if test -z "$description"
            set description $capitalized
        else
            set description "$description $capitalized"
        end
    end

    echo (string upper $team)-$ticket_nr: $description
end

set title (parse_branch_name_to_pr_title $branch_name)

# Create description
function create_input_description
    read -P "Add a description: " -l description
    echo ""
    echo $description
    echo ""
end

function create_description
    if $manual_desc
        create_input_description
    else
        claude -p "Based on the differences between the current git branch and the main branch formulate a PR description in markdown pinpointing the changes made. You can also read the git commit messages. Be precise and concise, no need to be more than 10 lines of text. It's IMPERATIVE that you output only the pr description and nothing else" --allowedTools "Bash(git*),Read,Grep"
    end
end

# Create PR

echo "Creating description..."

set body (create_description | string collect)

echo "Creating github pr..."

set args --title "$title" --body "$body"

if $draft
    set args $args -d
end

gh pr create $args
