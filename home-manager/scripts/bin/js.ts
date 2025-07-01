#!/usr/bin/env deno -A
import process from "node:process";
import { createRequire } from "node:module";
import { inspect } from "node:util";
import { runInNewContext } from "node:vm";

function readStdin() {
	return new Promise<string>((resolve, reject) => {
		let input = "";
		if (process.stdin.isTTY) return resolve(input);
		process.stdin.setEncoding("utf8");
		process.stdin.on("data", (chunk: string) => (input += chunk));
		process.stdin.on("end", () => resolve(input));
		process.stdin.on("error", (err: Error) => reject(err));
	});
}

const stdin = await readStdin();
const result = runInNewContext(process.argv[2], {
	data: eval(stdin),
	require: createRequire(import.meta.url),
});
process.stdout.write(inspect(result, { depth: null, maxArrayLength: null }));
