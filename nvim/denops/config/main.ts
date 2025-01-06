import type { Entrypoint } from "jsr:@denops/std@^7.0.0";

export const main: Entrypoint = (denops) => {
  try {
    denops.cmd("set number");
  } catch (error) {
    console.error(`Failed to set line numbers: ${error}`);
  }
};
