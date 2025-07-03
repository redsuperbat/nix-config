#!/usr/bin/env deno -A
import { createRequire } from "node:module";
import process from "node:process";
import { inspect } from "node:util";
import { runInNewContext } from "node:vm";

async function getStdin(): Promise<string> {
  if (Deno.stdin.isTerminal()) return "";
  return `(${await new Response(Deno.stdin.readable).text()})`;
}
const result = runInNewContext(process.argv[2], {
  // biome-ignore lint/security/noGlobalEval: This script is only ran by trusted users
  it: eval(await getStdin()),
  require: createRequire(import.meta.url),
});
process.stdout.write(inspect(result, { depth: null, maxArrayLength: null }));
