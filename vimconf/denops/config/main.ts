import type { Entrypoint } from "jsr:@denops/std@^7.0.0";
import * as mapping from "jsr:@denops/std@^7.0.0/mapping";

const dictionary: Readonly<Record<string, number>> = {
  "key1": 100,
  "key2": 200,
  "(":300,
};

export const main: Entrypoint = async (denops) => {
  await mapping.map(denops, "<C-S>", "<CMD>call denops#request('config', 'stst', [])<CR>", { mode: "i" },);
  denops.dispatcher = {
    async sss(): Promise<void> {
      console.log("Plugin is ready!");
      console.log(dictionary["key1"]);
    },
    stst(): void {
      console.log("Plugin is ready!");
      console.log(dictionary["key2"]);
    },
  };
};
