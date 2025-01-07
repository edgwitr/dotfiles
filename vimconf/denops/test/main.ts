import type { Entrypoint } from "jsr:@denops/std@^7.0.0";
import * as option from "jsr:@denops/std@^7.0.0/option";
import * as fn from "jsr:@denops/std@^7.0.0/function";
import * as buffer from "jsr:@denops/std@^7.0.0/buffer";
import { assert, is } from "jsr:@core/unknownutil@^4.3.0";


export const main: Entrypoint = async (denops) => {
  await option.number.set(denops, true);
  await option.relativenumber.set(denops, true);
  await option.breakindent.set(denops, true);
  await option.autoindent.set(denops, true);
  await option.smartindent.set(denops, true);
  await option.smarttab.set(denops, true);
  await option.expandtab.set(denops, true);
  await option.signcolumn.set(denops, "yes");
  await option.shiftwidth.set(denops, 2);
  await option.list.set(denops, true);
  await option.listchars.set(denops, "tab:>>,trail:-,nbsp:+,eol:$");

  await denops.cmd(`command! -nargs=? Hello call denops#request("${denops.name}", "hello", [<q-args>])`);

  denops.dispatcher = {
    async hello(name) {
      assert(name, is.String);
      await denops.cmd(`echo "Hello, ${name || 'Denops'}!"`);
    },
  };

  // const area = "130000";
  // const res = await fetch(
  //   `https://www.jma.go.jp/bosai/forecast/data/overview_forecast/${area}.json`,
  // );
  // const msg = [
  //   "☆東京の天気情報☆",
  //   "------------------------------",
  //   "",
  //   ...(await res.json()).text.split("\n"),
  // ];
  // const buf = await buffer.open(denops, "forecast");
  // await fn.setbufvar(denops, buf.bufnr, "&buftype", "nofile");
  // await fn.setbufvar(denops, buf.bufnr, "&swapfile", 0);
  // await buffer.replace(denops, buf.bufnr, msg);
  // await buffer.concrete(denops, buf.bufnr);
};
