#!/usr/bin/env deno -A
import { $, argv, echo, question, spinner } from "npm:zx@8.8.4";

$.verbose = false;

const draft = !!(argv.d ?? argv.draft ?? false);
const aiGenerate = !!(argv.a ?? argv.ai ?? false);

if (draft) {
  echo`Creating a draft PR`;
}

let { stdout: branchName } = await $`git branch --show-current`;
branchName = branchName.trim();
await spinner(async () => {
  echo`Syncing local changes to remote`;
  await $`git push -u origin ${branchName}`;
});

// Handles this type of branch name:
// nor-1580-automatic-refresh-of-page-when-a-new-version-is-available
function parseBranchNameToPrTitle(branchName: string): string {
  const [team, ticketNr, ...descParts] = branchName.split("-");
  const description = descParts
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(" ");
  return `${team.toUpperCase()}-${ticketNr}: ${description}`;
}

const title = parseBranchNameToPrTitle(branchName);

async function createInputDescription() {
  const description = await question("Add a description: \n");
  return `
${description}

`;
}

function createDescription() {
  if (!aiGenerate) {
    return createInputDescription();
  }

  return spinner(async () => {
    echo`Making pr description with claude`;
    const description =
      await $`claude -p "based on the differences between the current git branch and the main branch formulate a PR description in markdown pinpointing the changes made. Be precise and concise, no need to be more than 10 lines of text." --allowedTools "Bash(git*),Read,Grep"`;

    return description.stdout;
  });
}

const body = await createDescription();

await spinner(async () => {
  echo`Making pr...`;
  const args = ["--title", title, "--body", body];
  if (draft) {
    args.push("-d");
  }
  const pr = await $`gh pr create ${args}`;
  echo(pr);
});
