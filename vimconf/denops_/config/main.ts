import type { Entrypoint } from "jsr:@denops/std@^7.0.0";
import * as option from "jsr:@denops/std@^7.0.0/option";
import * as fn from "jsr:@denops/std@^7.0.0/function";
import * as buffer from "jsr:@denops/std@^7.0.0/buffer";
import { assert, is } from "jsr:@core/unknownutil@^4.3.0";


export const main: Entrypoint = async (denops) => {
  // await Promise.all([
  //   option.number.set(denops, true),
  //   option.relativenumber.set(denops, true),
  //   option.breakindent.set(denops, true),
  //   option.autoindent.set(denops, true),
  //   option.smartindent.set(denops, true),
  //   option.smarttab.set(denops, true),
  //   option.expandtab.set(denops, true),
  //   option.signcolumn.set(denops, "yes"),
  //   option.shiftwidth.set(denops, 2),
  //   option.list.set(denops, true),
  //   option.listchars.set(denops, "tab:>>,trail:-,nbsp:+,eol:$"),
  //   denops.cmd(`command! -nargs=? Hello call denops#request("${denops.name}", "hello", [<q-args>])`),
  // ]);

  // denops.dispatcher = {
  //   async hello(name) {
  //     assert(name, is.String);
  //     await denops.cmd(`echo "Hello, ${name || 'Denops'}!"`);
  //   },
  // };

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
