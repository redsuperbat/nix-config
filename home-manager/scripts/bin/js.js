#!/usr/bin/env deno -A
import { createRequire } from "node:module";
import { runInNewContext } from "node:vm";

function readStdin() {
	if (process.stdin.isTTY) return "";
	return new Promise((resolve, reject) => {
		let input = "";
		process.stdin.setEncoding("utf8");
		process.stdin.on("data", (chunk) => {
			input += chunk;
		});
		process.stdin.on("end", () => resolve(input));
		process.stdin.on("error", (err) => reject(err));
	});
}

async function main() {
	const stdin = await readStdin();
	const data = eval(stdin);
	const program = process.argv[2];
	const result = runInNewContext(program, {
		data,
		require: createRequire(import.meta.url),
	});
	console.log(result);
}

main();
