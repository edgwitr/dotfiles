import type { Entrypoint } from "jsr:@denops/std@^7.0.0";

export const main: Entrypoint = async (denops) => {
  denops.dispatcher = {
    async sss(): Promise<void> {
    },
  };
};
