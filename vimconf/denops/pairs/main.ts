import type { Entrypoint } from "jsr:@denops/std@^7.0.0";
import * as mapping from "jsr:@denops/std@^7.0.0/mapping";
import * as fn from "jsr:@denops/std@^7.0.0/function";

const pair_strings = {
  open: {
    "(": ")",
    "[": "]",
    "{": "}",
  },
  close: {
    ")": "(",
    "]": "[",
    "}": "{",
  },
  openclose: {
    "\"": "\"",
    "'": "'",
    "`": "`",
  },
};

export const main: Entrypoint = async (denops) => {
  // map open foreach
  for (const [open, close] of Object.entries(pair_strings.open)) {
    await mapping.map(
      denops,
      open,
      `<CMD>call denops#request("${denops.name}", 'open', ["${open}","${close}"])<CR>`,
      { mode: ["i", "c"] },
    );
  }
  // map close foreach
  for (const [close, open] of Object.entries(pair_strings.close)) {
    await mapping.map(
      denops,
      close,
      `<CMD>call denops#request("${denops.name}", 'close', ["${close}","${open}"])<CR>`,
      { mode: ["i", "c"] },
    );
  }
  denops.dispatcher = {
    async open(str, correstr): Promise<void> {
      const mode = await fn.mode(denops) as string;
      await denops.cmd(`call feedkeys("${str}${correstr}\\<Left>", 'n')`)
      // if (mode === "i") {
      //   const line = await fn.getline(denops, ".") as string;
      //   const col = await fn.col(denops, ".") as number;
      //   const newLine = line.slice(0, col - 1) + str + correstr+ line.slice(col - 1)
      //   await fn.setline(denops, ".", newLine);
      //   await fn.cursor(denops,[0, col + 1]);
      // } else if (mode === "c") {
      //   const line = await fn.getcmdline(denops) as string;
      //   const col = await fn.getcmdpos(denops) as number;
      //   const newLine = line.slice(0, col - 1) + str + correstr+ line.slice(col - 1)
      //   await fn.setcmdline(denops, newLine, col + 1);
      // }
    },
    async close(...args: unknown[]): Promise<void> {
      // const [str, correstr] = args as [string, string];
      // const mode = await fn.mode(denops) as string;
      // function makeLine(str: string, line: string, col: number): string {
      //   console.log(line[col - 2])
      //   if (line[col - 2] == correstr) {
      //     return line
      //   } else {
      //     return line.slice(0, col - 1) + str + line.slice(col - 1)
      //   }
      // }
      // if (mode === "i") {
      //   const line = await fn.getline(denops, ".") as string;
      //   const col = await fn.col(denops, ".") as number;
      //   const newLine = makeLine(str, line, col);
      //   await fn.setline(denops, ".", newLine);
      //   await fn.cursor(denops,[0, col + 1]);
      // } else if (mode === "c") {
      //   const line = await fn.getcmdline(denops) as string;
      //   const col = await fn.getcmdpos(denops) as number;
      //   const newLine = makeLine(str, line, col);
      //   await fn.setcmdline(denops, newLine, col + 1);
      // }
    },
    async openclose(): Promise<void> {
      "openclose"
    },
  };
};
