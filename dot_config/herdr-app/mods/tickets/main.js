// .tmfv artifacts of the focused project (specs, tickets, notes, ADRs, handoffs),
// grouped by task key (the letters-digits prefix in file names, e.g. core-2401),
// then by folder kind: tickets, specs, notes, adr, qa — known kinds get icons.
// Newest files first; a click previews the file, one copy button copies its path,
// the other its contents.
import { View, div, svg } from "gpui-kit";
import { h_flex, v_flex, Scrollbar, InputState, Input } from "gpui-base";
import { spaces, panes, focused, exec, readTextFile, watchFolder, run, theme, checking, settings, window } from "herdr";

function location() {
  const space = spaces().find((s) => s.active), f = focused();
  const pane = f?.pane ? panes().find((p) => p.pane === f.pane) : null;
  const on = f?.pane === null ? (f?.terminal?.includes("/") ? f.terminal.split("/")[0] : null) : space?.machine ?? null;
  return { cwd: pane?.cwd || f?.cwd || space?.folder, on };
}

const key = () => JSON.stringify(location());
const PREFIX = /^([a-z]+-\d+)/i;
const MAX_FILES = 500;
const TUIS = new Set(["nvim", "vim", "vi", "nano", "micro", "helix", "emacs", "joe"]);

// Folder kinds keep a fixed order; unknown kinds follow alphabetically,
// files at the .tmfv root (no folder) go last.
const KIND_ORDER = ["tickets", "specs", "notes", "adr", "qa"];
const KIND_ICONS = {
  tickets: "mods/tickets/ticket.svg",
  specs: "mods/tickets/spec.svg",
  notes: "mods/tickets/note.svg",
  adr: "mods/tickets/adr.svg",
  qa: "mods/tickets/qa.svg",
};

// The folder kind of a file: the first path component under .tmfv
// ("" for files at its root, e.g. GLOSSARY.md).
function kindOf(rel) {
  const slash = rel.indexOf("/");
  return slash < 0 ? "" : rel.slice(0, slash);
}

function kindGroups(files) {
  const byKind = new Map();
  for (const file of files) {
    const kind = kindOf(file.rel);
    if (!byKind.has(kind)) byKind.set(kind, []);
    byKind.get(kind).push(file);
  }
  const rank = (kind) => {
    const at = KIND_ORDER.indexOf(kind);
    return at < 0 ? KIND_ORDER.length : at;
  };
  return [...byKind.entries()]
    .sort((a, b) => rank(a[0]) - rank(b[0]) || (a[0] === "" ? 1 : b[0] === "" ? -1 : (a[0] < b[0] ? -1 : 1)))
    .map(([kind, list]) => ({ kind, files: list }));
}

// The task a file belongs to: the first path component with a letters-digits prefix.
function taskOf(rel) {
  for (const part of rel.split("/")) {
    const found = PREFIX.exec(part);
    if (found) return found[1].toLowerCase();
  }
  return "";
}

// The name shown in the list: the path without the kind folder (its header
// shows it) and without the task — a whole task folder in the middle, or the
// task prefix on the file name itself, e.g. tickets/core-2505-x/04-plan.md
// reads as "04-plan.md" next to the TICKETS header of the CORE-2505 group.
function shortPath(rel, task) {
  if (!rel.includes("/")) return rel; // a file at the .tmfv root: nothing to cut
  const body = rel.split("/").slice(1);
  if (!task) return body.join("/");
  const out = [];
  let cut = false; // only the first task match goes: a later file may carry the same prefix
  for (let i = 0; i < body.length; i++) {
    const part = body[i];
    if (!cut && part.toLowerCase().startsWith(task)) {
      cut = true;
      if (i < body.length - 1) continue; // the task's own folder: gone, the header says it
      const trimmed = part.slice(task.length).replace(/^[-_. ]+/, "");
      out.push(trimmed || part); // a file named just "core-2505.md" keeps its name
      continue;
    }
    out.push(part);
  }
  return out.join("/");
}

function localDate(seconds) {
  const date = new Date(seconds * 1000);
  if (Number.isNaN(date.getTime())) return "";
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${date.getFullYear()}-${month}-${day}`;
}

// BSD (macOS) and GNU (Linux) stat spell mtime differently; probe once per machine.
const STAT_FMT = new Map();
async function statFormat(on) {
  if (STAT_FMT.has(on)) return STAT_FMT.get(on);
  const probe = await exec("stat", ["-f", "%m", "/"], { on }).catch(() => null);
  const fmt = probe?.code === 0 ? ["-f", "%m%t%N"] : ["-c", "%Y%t%n"];
  STAT_FMT.set(on, fmt);
  return fmt;
}

export default class Tickets extends View {
  init(_props, cx) {
    this.files = [];
    this.groups = [];
    this.handle = cx.focus_handle();
    this.expanded = new Set();
    this.expandedKinds = new Set();
    this.input = InputState.new({ placeholder: "Filter by task or file…" });
    this.input.on("change", (_e, cx) => {
      this.filter = this.input.value();
      cx.notify();
    });
    this.open = null;
    this.preview = [];
    this.cache = new Map();
    if (checking()) return;
    this.refresh(cx);
    cx.timer.every(10_000, (cx) => this.refresh(cx));
  }

  watch(tmfv, cx) {
    if (this.watched === tmfv) return;
    this.watched = tmfv;
    cx.spawn(async (cx) => {
      try {
        while (this.watched === tmfv) {
          await watchFolder(tmfv);
          if (this.watched === tmfv) this.refresh(cx);
        }
      } catch { this.watched = null; }
    });
  }

  refresh(cx) {
    if (this.loading) return;
    const { cwd, on } = location(), context = key();
    if (context !== this.context) {
      this.context = context;
      this.root = null;
      this.tmfv = false;
      this.files = [];
      this.groups = [];
      this.error = null;
      this.note = null;
      this.watched = null;
      this.open = null;
      this.preview = [];
      this.previewH = 0;
      this.copied = null;
      this.copiedContent = null;
      this.expanded = new Set();
      this.expandedKinds.clear();
      this.filter = "";
      this.input.set_value("");
      this.cache.clear();
    }
    if (!cwd) return;
    this.loading = true;
    cx.spawn(async (cx) => {
      try {
        const top = await exec("git", ["rev-parse", "--show-toplevel"], { cwd, on });
        if (key() !== context) return;
        const root = top.code === 0 ? top.stdout.trim() : cwd;
        const tmfv = `${root}/.tmfv`;
        const fmt = await statFormat(on);
        const listed = await exec("find", [tmfv, "-type", "f", "-not", "-name", ".*", "-exec", "stat", ...fmt, "{}", "+"], { on });
        if (key() !== context) return;
        this.root = root;
        this.on = on;
        const files = [];
        if (listed.code === 0) {
          this.tmfv = true;
          for (const line of listed.stdout.split("\n")) {
            const cut = line.indexOf("\t");
            if (cut < 0) continue;
            const mtime = Number(line.slice(0, cut)), path = line.slice(cut + 1);
            if (!Number.isFinite(mtime) || !path.startsWith(tmfv + "/")) continue;
            const rel = path.slice(tmfv.length + 1);
            if (rel.split("/").some((part) => part === ".DS_Store")) continue;
            const task = taskOf(rel);
            files.push({ rel, task, short: shortPath(rel, task), mtime });
          }
        } else {
          // find fails when .tmfv is absent: that is the normal empty state, not an error.
          this.tmfv = false;
        }
        files.sort((a, b) => b.mtime - a.mtime);
        this.files = files.slice(0, MAX_FILES);
        this.limited = files.length > MAX_FILES;
        const byTask = new Map();
        for (const file of this.files) {
          if (!byTask.has(file.task)) byTask.set(file.task, []);
          byTask.get(file.task).push(file);
        }
        this.groups = [...byTask.entries()].sort((a, b) => b[1][0].mtime - a[1][0].mtime)
          .map(([task, list]) => ({ task, files: list, newest: list[0].mtime }));
        this.error = null;
        this.note = null;
        if (this.open && !this.files.some((file) => file.rel === this.open)) {
          this.open = null;
          this.preview = [];
        }
        this.watch(tmfv, cx);
      } catch (e) {
        if (key() === context) this.error = String(e.message ?? e);
      } finally {
        this.loading = false;
        cx.notify();
      }
    });
  }

  pick(rel, cx) {
    const file = this.files.find((f) => f.rel === rel);
    if (!file) return;
    if (this.open === rel) {
      this.open = null;
      this.preview = [];
      this.previewH = 0;
      cx.notify();
      return;
    }
    this.open = rel;
    this.previewH = 0;
    const context = this.context, root = this.root, on = this.on;
    const cached = this.cache.get(rel);
    if (cached && cached.mtime === file.mtime) {
      this.preview = cached.lines;
      cx.notify();
      return;
    }
    this.preview = ["…"];
    cx.spawn(async (cx) => {
      try {
        const text = await readTextFile(`${root}/.tmfv/${rel}`, { on });
        const lines = text === null ? ["Cannot preview this file (binary, too large, or unreadable)"]
          : text.includes("\0") ? ["Binary file · no text preview"]
          : text.replace(/\r/g, "").split("\n").slice(0, 200).map((line) => (line.length > 500 ? line.slice(0, 500) + "…" : line));
        this.cache.set(rel, { mtime: file.mtime, lines });
        if (this.cache.size > 20) this.cache.delete(this.cache.keys().next().value);
        if (key() === context && this.open === rel) this.preview = lines;
      } catch (e) {
        if (key() === context && this.open === rel) this.preview = [`Cannot preview this file: ${e.message ?? e}`];
      }
      cx.notify();
    });
    cx.notify();
  }

  copy(rel, cx) {
    cx.write_to_clipboard(`.tmfv/${rel}`);
    this.copied = rel;
    cx.notify();
    cx.timer.after(1500, (cx) => {
      if (this.copied === rel) {
        this.copied = null;
        cx.notify();
      }
    });
  }

  // Full contents, not the truncated preview lines. readTextFile returns null
  // for binary, too large or unreadable files: say so instead of copying nothing.
  copyContent(rel, cx) {
    if (!this.root) return;
    const root = this.root, on = this.on, context = this.context;
    this.note = null;
    cx.spawn(async (cx) => {
      try {
        const text = await readTextFile(`${root}/.tmfv/${rel}`, { on });
        if (key() !== context) return;
        if (text === null) {
          this.note = `Cannot copy ${rel}: binary, too large, or unreadable`;
        } else {
          cx.write_to_clipboard(text);
          this.copiedContent = rel;
          cx.timer.after(1500, (cx) => {
            if (this.copiedContent === rel) {
              this.copiedContent = null;
              cx.notify();
            }
          });
        }
      } catch (e) {
        if (key() === context) this.note = `Cannot copy ${rel}: ${e.message ?? e}`;
      }
      cx.notify();
    });
  }

  // Zed first (this machine's pick), then $VISUAL/$EDITOR as the machine sees it:
  // a TUI editor opens in a terminal tab (in the shown space, when that space
  // lives on the same machine), anything else is launched directly, and with
  // no editor at all the OS handler gets the file.
  openExternal(rel, cx) {
    if (!this.root) return;
    const root = this.root, on = this.on, context = this.context;
    const abs = `${root}/.tmfv/${rel}`;
    this.note = null;
    cx.spawn(async (cx) => {
      try {
        try { await exec("zed", [abs], { on }); return; } catch { /* no zed; keep looking */ }
        const asked = await exec("sh", ["-c", 'printf %s "${VISUAL:-${EDITOR:-}}"'], { on }).catch(() => null);
        const editor = (asked?.code === 0 ? asked.stdout.trim() : "").split(/\s+/)[0].split("/").pop() || "";
        const space = spaces().find((s) => s.active);
        if (editor && TUIS.has(editor) && (space?.machine ?? null) === on) {
          run("terminal.open", { argv: [editor, abs] });
          return;
        }
        if (editor && !TUIS.has(editor)) {
          try { await exec(editor, [abs], { on }); return; } catch { /* not launchable; try the OS handler */ }
        }
        if (on) {
          this.note = `No editor to open ${rel} on that machine`;
        } else {
          const platform = window()?.platform;
          const command = platform === "windows" ? "cmd" : platform === "linux" ? "xdg-open" : "open";
          const args = platform === "windows" ? ["/c", "start", "", abs] : [abs];
          const result = await exec(command, args);
          if (result.code !== 0) this.note = (result.stderr || result.stdout).trim() || "Could not open the file";
        }
      } catch (e) {
        if (key() === context) this.note = String(e.message ?? e);
      }
      cx.notify();
    });
  }

  fileRow(file, t, indent = 0) {
    const open = this.open === file.rel;
    const id = file.rel.replace(/[^A-Za-z0-9_.-]+/g, "-");
    return v_flex().id(`ticket-file-${id}`).flex_none().rounded(7).when(indent, (el) => el.pl(indent)).when(open, (el) => el.bg(t.selected))
      .child(h_flex().h(28).px(8).gap(7).items_center().cursor_pointer().hover((s) => s.bg(t.hover))
        .on_click((_e, cx) => this.pick(file.rel, cx))
        .child(div().flex_1().min_w(0).truncate().child(file.short || file.rel))
        .child(div().text_size(11).text_color(t.dim).flex_none().child(localDate(file.mtime)))
        .child(div().id(`open-${id}`).size(20).flex_none().flex().items_center().justify_center().rounded(4).text_color(t.dim)
          .hover((s) => s.bg(t.hover).text_color(t.foreground))
          .on_click((_e, cx) => { cx.stop_propagation(); this.openExternal(file.rel, cx); })
          .child(svg("mods/tickets/open.svg").size(12)))
        .child(div().id(`copytext-${id}`).size(20).flex_none().flex().items_center().justify_center().rounded(4)
          .text_color(this.copiedContent === file.rel ? t.ansi2 : t.dim)
          .hover((s) => s.bg(t.hover).text_color(t.foreground))
          .on_click((_e, cx) => { cx.stop_propagation(); this.copyContent(file.rel, cx); })
          .child(svg(this.copiedContent === file.rel ? "mods/tickets/check.svg" : "mods/tickets/copy-text.svg").size(12)))
        .child(div().id(`copy-${id}`).size(20).flex_none().flex().items_center().justify_center().rounded(4)
          .text_color(this.copied === file.rel ? t.ansi2 : t.dim)
          .hover((s) => s.bg(t.hover).text_color(t.foreground))
          .on_click((_e, cx) => { cx.stop_propagation(); this.copy(file.rel, cx); })
          .child(svg(this.copied === file.rel ? "mods/tickets/check.svg" : "mods/tickets/copy.svg").size(12))))
      .when(open, (el) => el.child(v_flex().id(`preview-${id}`).max_h(300).overflow_y_scroll().px(10).py(8).gap(0)
        .when(this.previewH > 300, (e) => e.on_scroll_wheel((_e, cx) => cx.stop_propagation()))
        .font_family(settings().font_family ?? "JetBrains Mono").text_size(11).text_color(t.foreground)
        .child(v_flex().on_size_change((size, cx) => {
          if (this.previewH !== size.height) {
            this.previewH = size.height;
            cx.notify();
          }
        })
          .children(this.preview.map((line) => div().whitespace_normal().child(line.length ? line : " "))))));
  }

  groupRow(group, t, filtering) {
    const expanded = filtering || this.expanded.has(group.task);
    const id = (group.task || "none").replace(/[^A-Za-z0-9_.-]+/g, "-");
    return v_flex().id(`ticket-${id}`).flex_none()
      .child(h_flex().id(`ticket-head-${id}`).h(26).px(8).gap(6).items_center().cursor_pointer().hover((s) => s.bg(t.hover))
        .on_click((_e, cx) => {
          if (expanded) this.expanded.delete(group.task);
          else this.expanded.add(group.task);
          cx.notify();
        })
        .child(svg(expanded ? "mods/files/chevron-down.svg" : "mods/files/chevron-right.svg").size(12).flex_none().text_color(t.dim))
        .child(div().font_semibold().text_size(12).child((group.task || "—").toUpperCase()))
        .child(div().px(5).py(1).rounded(4).border_1().border_color(t.border).text_size(10).text_color(t.muted).child(String(group.files.length)))
        .child(div().flex_1())
        .child(div().text_size(11).text_color(t.dim).flex_none().child(localDate(group.newest))))
      .when(expanded, (el) => el.children(kindGroups(group.files).map((kg) => this.kindRow(group.task, kg, t, filtering))));
  }

  // A folder kind inside a task: its own collapsible header with an icon
  // (a known kind's icon, a folder for unknown ones, a file for the root),
  // collapsed until asked.
  kindRow(task, kg, t, filtering) {
    const label = kg.kind || "root";
    const id = `${task || "none"}/${label}`.replace(/[^A-Za-z0-9_.-]+/g, "-");
    const expanded = filtering || this.expandedKinds.has(id);
    const icon = KIND_ICONS[kg.kind] ?? (kg.kind ? "mods/files/folder.svg" : "mods/files/file.svg");
    return v_flex().id(`ticket-kind-${id}`).flex_none()
      .child(h_flex().id(`ticket-kind-head-${id}`).h(22).pl(14).pr(8).gap(6).items_center().cursor_pointer().hover((s) => s.bg(t.hover))
        .on_click((_e, cx) => {
          if (this.expandedKinds.has(id)) this.expandedKinds.delete(id);
          else this.expandedKinds.add(id);
          cx.notify();
        })
        .child(svg(expanded ? "mods/files/chevron-down.svg" : "mods/files/chevron-right.svg").size(11).flex_none().text_color(t.dim))
        .child(svg(icon).size(12).flex_none().text_color(t.muted))
        .child(div().font_semibold().text_size(11).text_color(t.muted).child(label.toUpperCase()))
        .child(div().text_size(10).text_color(t.dim).child(String(kg.files.length)))
        .child(div().flex_1()))
      .when(expanded, (el) => el.children(kg.files.map((file) => this.fileRow(file, t, 24))));
  }

  render(cx) {
    if (!checking() && key() !== this.context) this.refresh(cx);
    const t = theme();
    const filter = (this.filter ?? "").trim().toLowerCase();
    const groups = filter
      ? this.groups
          .map((group) => ({ ...group, files: group.files.filter((file) => file.task.includes(filter) || file.rel.toLowerCase().includes(filter)) }))
          .filter((group) => group.files.length)
      : this.groups;
    const shown = filter ? groups.reduce((n, group) => n + group.files.length, 0) : this.files.length;
    const empty = this.error
      || (filter ? `No matches for “${filter}”` : this.loading && !this.files.length ? "Loading tickets…" : this.root ? (this.tmfv ? "No files in .tmfv" : "No .tmfv folder in this project") : "No folder");
    return v_flex().id("tickets").size_full().min_h(0).rounded(10).overflow_hidden().bg(t.background).border_1().border_color(t.border).text_color(t.foreground).text_size(13).track_focus(this.handle)
      .child(h_flex().h(42).flex_none().px(14).gap(8).items_center().border_b(1).border_color(t.border)
        .child(div().font_semibold().child("Tickets"))
        .child(div().px(5).py(1).rounded(4).border_1().border_color(t.border).text_size(10).text_color(t.muted).child(filter ? `${shown}/${this.files.length}` : String(this.files.length)))
        .child(div().flex_1())
        .child(div().text_size(11).text_color(t.dim).truncate().child(this.root ? (this.root.split("/").pop() || this.root) : "")))
      .child(h_flex().h(30).flex_none().px(8).pt(8).pb(4).items_center()
        .child(div().id("ticket-filter").flex_1().min_w(0).h(24).px(8).flex().items_center().rounded(6).border_1().border_color(t.border).cursor_text()
          .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
          .child(Input.new(this.input).h_full().text_size(12).text_color(t.foreground))))
      .child(div().flex_1().min_h(0).relative()
        .child(v_flex().id("tickets-list").absolute().inset_0().overflow_y_scroll().p(6).gap(2)
          .children(groups.map((group) => this.groupRow(group, t, Boolean(filter))))
          .when(!groups.length, (el) => el.child(div().p(8).text_color(t.dim).child(empty))))
        .child(Scrollbar.vertical("tickets-list").absolute().inset_0()))
      .when(this.limited, (el) => el.child(div().px(12).py(4).text_size(11).text_color(t.dim).child(`Showing the ${MAX_FILES} newest files`)))
      .when(Boolean(this.note), (el) => el.child(div().px(12).py(8).text_size(11).text_color(t.ansi1).child(this.note)));
  }
}
