// Same footer as the built-in one (folder/branch/session, model, extension statuses),
// but the stats segment shows only context usage: "16k / 1.0M (1.6%)".
// Toggle back with /footer. Remove the file to uninstall completely.
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { isAbsolute, relative, resolve, sep } from "node:path";

type Ctx = {
  mode: string;
  ui: { setFooter: Function };
  getContextUsage: () => any;
  model?: any;
  thinkingLevel?: string;
  sessionManager: { getCwd(): string; getSessionName(): string | undefined };
};
type Theme = { fg: (color: string, text: string) => string };

const fmt = (n: number): string =>
  n < 1e3 ? `${n}` : n < 1e4 ? `${(n / 1e3).toFixed(1)}k` : n < 1e6 ? `${Math.round(n / 1e3)}k` : `${(n / 1e6).toFixed(1)}M`;

const sanitize = (text: string): string => text.replace(/[\r\n\t]/g, " ").replace(/ +/g, " ").trim();

function formatCwd(cwd: string, home: string | undefined): string {
  if (!home) return cwd;
  const rel = relative(resolve(home), resolve(cwd));
  const inside = rel === "" || (rel !== ".." && !rel.startsWith(`..${sep}`) && !isAbsolute(rel));
  return inside ? (rel === "" ? "~" : `~${sep}${rel}`) : cwd;
}

export default function (pi: ExtensionAPI) {
  const install = (ctx: Ctx) => {
    if (ctx.mode !== "tui") return;
    ctx.ui.setFooter((tui: { requestRender(): void }, theme: Theme, footerData: any) => {
      const unsubscribe = footerData.onBranchChange(() => tui.requestRender());
      return {
        dispose: unsubscribe,
        invalidate() {},
        render(width: number): string[] {
          // Line 1: folder (branch) • session name
          let pwd = formatCwd(ctx.sessionManager.getCwd(), process.env.HOME || process.env.USERPROFILE);
          const branch = footerData.getGitBranch();
          if (branch) pwd = `${pwd} (${branch})`;
          const sessionName = ctx.sessionManager.getSessionName();
          if (sessionName) pwd = `${pwd} • ${sessionName}`;
          const pwdLine = truncateToWidth(theme.fg("dim", pwd), width, theme.fg("dim", "..."));

          // Line 2 left: context only
          const u = ctx.getContextUsage();
          const window = u?.contextWindow ?? ctx.model?.contextWindow ?? 0;
          const percent = u?.percent ?? null;
          const text =
            percent == null ? `? / ${fmt(window)}` : `${fmt(u.tokens)} / ${fmt(window)} (${percent.toFixed(1)}%)`;
          const color = percent == null ? "dim" : percent > 90 ? "error" : percent > 70 ? "warning" : "dim";
          const colored = theme.fg(color, text);
          const left = visibleWidth(colored) > width ? truncateToWidth(colored, width, "...") : colored;
          const leftWidth = visibleWidth(left);

          // Line 2 right: model • thinking (provider)
          const model = ctx.model;
          let right = model?.id || "no-model";
          if (model?.reasoning) {
            const level = ctx.thinkingLevel || "off";
            right = level === "off" ? `${right} • thinking off` : `${right} • ${level}`;
          }
          if (footerData.getAvailableProviderCount() > 1 && model) {
            const withProvider = `(${model.provider}) ${right}`;
            if (leftWidth + 2 + visibleWidth(withProvider) <= width) right = withProvider;
          }
          const minPadding = 2;
          const rightWidth = visibleWidth(right);
          let statsLine: string;
          if (leftWidth + minPadding + rightWidth <= width) {
            statsLine = left + " ".repeat(width - leftWidth - rightWidth) + right;
          } else if (leftWidth + minPadding < width) {
            const room = width - leftWidth - minPadding;
            const cut = truncateToWidth(right, room, "");
            statsLine = left + " ".repeat(Math.max(0, room - visibleWidth(cut))) + cut;
          } else {
            statsLine = left;
          }
          const dimStats = theme.fg("dim", statsLine.slice(0, left.length)) + theme.fg("dim", statsLine.slice(left.length));

          // Line 3: extension statuses (ctx.ui.setStatus from other extensions)
          const statuses = footerData.getExtensionStatuses();
          const statusLine =
            statuses.size > 0
              ? truncateToWidth(
                  Array.from(statuses.entries())
                    .sort(([a], [b]) => a.localeCompare(b))
                    .map(([, t]) => sanitize(t))
                    .join(" "),
                  width,
                  theme.fg("dim", "..."),
                )
              : undefined;

          return statusLine === undefined ? [pwdLine, dimStats] : [pwdLine, dimStats, statusLine];
        },
      };
    });
  };

  let customActive = true;
  pi.on("session_start", (_event, ctx) => {
    if (customActive) install(ctx);
  });

  pi.registerCommand("footer", {
    description: "Toggle context-only footer / default footer",
    handler: async (_args, ctx) => {
      if (ctx.mode !== "tui") return;
      if (customActive) {
        ctx.ui.setFooter(undefined);
        customActive = false;
        ctx.ui.notify("Default footer restored", "info");
      } else {
        install(ctx);
        customActive = true;
        ctx.ui.notify("Context-only footer enabled", "info");
      }
    },
  });
}
