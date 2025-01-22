import type { Entrypoint } from "jsr:@denops/std@^7.0.0";
import Parser from "npm:tree-sitter@^0.22.4";
import C from "npm:tree-sitter-c@^0.23.4";

export const main: Entrypoint = async (denops) => {
  await denops.cmd('echo "Hello, World!"');
  denops.dispatcher = {
    async sss(): Promise<void> {
    },
    stst(): void {
      const parser = new Parser();
      parser.setLanguage(C as unknown as Parser.Language);

      const code = `
      #include <stdio.h>

      int main() {
        printf("Hello, World!\\n");
        return 0;
      }
      `;

      const tree = parser.parse(code);

      function printNodePositions(node: Parser.SyntaxNode, indent = "") {
        console.log(
          `${indent}Type: ${node.type}, ` +
          `Start: (${node.startPosition.row + 1}, ${node.startPosition.column}), ` +
          `End: (${node.endPosition.row + 1}, ${node.endPosition.column})`
        );

        for (const child of node.children) {
          printNodePositions(child, indent + "  ");
        }
      }

      printNodePositions(tree.rootNode);
    },
  };
};
