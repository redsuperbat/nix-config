#!/usr/bin/env deno -A
import { $, argv, echo, question, spinner } from "npm:zx";

$.verbose = false;

const draft = !!(argv.d ?? argv.draft ?? false);

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

const description = await question("Add a description: \n");
const body = `
${description}

`;
await spinner(async () => {
  echo`Making pr...`;
  const args = ["--title", title, "--body", body];
  if (draft) {
    args.push("-d");
  }
  const pr = await $`gh pr create ${args}`;
  echo(pr);
});
