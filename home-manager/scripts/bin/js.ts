#!/usr/bin/env deno -A
import { createRequire } from "node:module";
import process from "node:process";
import { inspect } from "node:util";
import { runInNewContext } from "node:vm";

async function getStdin(): Promise<string> {
  if (Deno.stdin.isTerminal()) return "";
  const stdin = await new Response(Deno.stdin.readable).text();
  if (stdin.trim().length === 0) return "";
  return `(${stdin})`;
}
const result = runInNewContext(process.argv[2], {
  // biome-ignore lint/security/noGlobalEval: This script is only ran by trusted users
  it: eval(await getStdin()),
  require: createRequire(import.meta.url),
});
process.stdout.write(inspect(result, { depth: null, maxArrayLength: null }));
