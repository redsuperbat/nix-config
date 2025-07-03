#!/opt/homebrew/bin/deno -A
import { $, argv, echo, question, spinner } from "npm:zx";

$.verbose = false;

const draft = argv.d ?? argv.draft ?? "";

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
// maxnetterberg/team-1337-refactor-all-the-code
function parseBranchNameToPrTitle(branchName: string): string {
  const [, rest] = branchName.split("/");
  const [team, ticketNr, ...descParts] = rest.split("-");
  const description = descParts
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(" ");
  return `${team.toUpperCase()}-${ticketNr}: ${description}`;
}

const title = parseBranchNameToPrTitle(branchName);

const description = await question("Add a description: \n");
const body = `
${description}

`;
await spinner(async () => {
  echo`Making pr...`;
  const pr =
    await $`gh pr create --title ${title} --body ${body} ${draft ? "-d" : ""}`;
  echo(pr);
});
