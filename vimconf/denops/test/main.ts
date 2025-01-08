import type { Entrypoint } from "jsr:@denops/std@^7.0.0";
import * as mapping from "jsr:@denops/std@^7.0.0/mapping";

export const main: Entrypoint = async (denops) => {
  denops.dispatcher = {
    async sss(): Promise<void> {
    },
    stst(): void {
    },
  };
};
