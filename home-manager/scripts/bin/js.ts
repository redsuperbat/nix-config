#!/usr/bin/env deno -A
import process from "node:process";
import { createRequire } from "node:module";
import util from "node:util";
import { runInNewContext } from "node:vm";

function readStdin() {
	if (process.stdin.isTTY) return "";
	return new Promise<string>((resolve, reject) => {
		let input = "";
		process.stdin.setEncoding("utf8");
		process.stdin.on("data", (chunk: string) => {
			input += chunk;
		});
		process.stdin.on("end", () => resolve(input));
		process.stdin.on("error", (err: Error) => reject(err));
	});
}

const stdin = await readStdin();
const data = eval(stdin);
const program = process.argv[2];
const result = runInNewContext(program, {
	data,
	require: createRequire(import.meta.url),
});

process.stdout.write(
	util.inspect(result, { depth: null, maxArrayLength: null }),
);
