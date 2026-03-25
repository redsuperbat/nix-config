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

# Rebase on origin/main
echo "Rebasing on origin/main..."
git fetch origin main
git rebase origin/main
or begin
    echo "Rebase failed. Resolve conflicts and try again."
    exit 1
end

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

set fallback_title (parse_branch_name_to_pr_title $branch_name)

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
        claude -p "Based on the differences between the current git branch and origin/main formulate a PR description about the changes that were made. You can also read the git commit messages. Be precise and concise, no need to be more than 10 lines of text. It's IMPERATIVE that you output only the pr description and nothing else" --allowedTools "Bash(git*),Read,Grep"
    end
end

# Create PR

echo "Creating title and description..."

set title (claude -p "Based on the differences between the current git branch and origin/main, generate a concise PR title. You can also read the git commit messages. Output ONLY the title, nothing else." --allowedTools "Bash(git*),Read,Grep" | string trim)

if test -z "$title"
    echo "Claude failed to generate title, falling back to branch name"
    set title $fallback_title
end

set body (create_description | string collect)

echo "Creating github pr..."

set args --title "$title" --body "$body"

if $draft
    set args $args -d
end

gh pr create $args
