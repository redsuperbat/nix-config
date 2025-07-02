#!/usr/bin/env deno -A
import process from "node:process";
import { createRequire } from "node:module";
import { inspect } from "node:util";
import { runInNewContext } from "node:vm";
import { readAllSync } from "jsr:@std/io";

const stdin = Deno.stdin.isTerminal() ? "" : readAllSync(Deno.stdin).toString();
const result = runInNewContext(process.argv[2], {
	data: eval(stdin),
	require: createRequire(import.meta.url),
});
process.stdout.write(inspect(result, { depth: null, maxArrayLength: null }));
