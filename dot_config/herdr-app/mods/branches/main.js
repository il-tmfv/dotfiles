// Local git branches for the focused folder: ahead/behind, age, and a click to switch.
import { View, div } from "gpui-kit";
import { h_flex, v_flex, Scrollbar } from "gpui-base";
import { spaces, panes, focused, exec, watchFolder, theme, checking } from "herdr";

function location() {
  const space = spaces().find((s) => s.active), f = focused();
  const pane = f?.pane ? panes().find((p) => p.pane === f.pane) : null;
  const on = f?.pane === null ? (f.terminal?.includes("/") ? f.terminal.split("/")[0] : null) : space?.machine ?? null;
  return { cwd: pane?.cwd || f?.cwd || space?.folder, on };
}

const key = () => JSON.stringify(location());
const READ = ["--no-optional-locks", "-c", "core.fsmonitor=false", "-c", "diff.autoRefreshIndex=false"];
const FMT = "%(HEAD)%00%(refname:short)%00%(upstream:short)%00%(upstream:track)%00%(committerdate:relative)%00%(subject)";

function parseTrack(track) {
  return {
    ahead: /ahead (\d+)/.exec(track)?.[1] ?? "",
    behind: /behind (\d+)/.exec(track)?.[1] ?? "",
  };
}

function parseBranches(text) {
  return text.split("\n").filter(Boolean).map((line) => {
    const [head, name, upstream, track, when, subject] = line.split("\0");
    return { current: head === "*", name, upstream, track, when, subject: subject ?? "" };
  });
}

function parseWorktrees(text) {
  const checked = new Map();
  let path = "", branch = "";
  const flush = () => {
    if (path && branch.startsWith("refs/heads/")) checked.set(branch.slice("refs/heads/".length), path);
    path = "";
    branch = "";
  };
  for (const line of text.split("\n")) {
    if (!line) flush();
    else if (line.startsWith("worktree ")) path = line.slice("worktree ".length);
    else if (line.startsWith("branch ")) branch = line.slice("branch ".length);
  }
  flush();
  return checked;
}

function dirtyCount(text) {
  return text.split("\0").filter((entry) => entry.length >= 3 && entry[2] === " ").length;
}

export default class Branches extends View {
  init(_props, cx) {
    this.rows = [];
    this.dirty = 0;
    this.handle = cx.focus_handle();
    if (checking()) return;
    this.refresh(cx);
    cx.timer.every(10000, (cx) => this.refresh(cx));
  }

  watch(root, cx) {
    if (this.on || this.watched === root) return;
    this.watched = root;
    cx.spawn(async (cx) => {
      try {
        while (this.watched === root) {
          await watchFolder(root);
          if (this.watched === root) this.refresh(cx);
        }
      } catch { this.watched = null; }
    });
  }

  refresh(cx) {
    if (this.loading || this.busy) return;
    const { cwd, on } = location(), context = key();
    if (context !== this.context) {
      this.context = context;
      this.root = null;
      this.rows = [];
      this.dirty = 0;
      this.head = "";
      this.error = null;
      this.note = null;
      this.watched = null;
    }
    if (!cwd) return;
    this.loading = true;
    cx.spawn(async (cx) => {
      try {
        const top = await exec("git", ["rev-parse", "--show-toplevel"], { cwd, on });
        if (key() !== context) return;
        if (top.code !== 0) {
          this.root = null;
          this.rows = [];
          this.error = "Not a git repository";
          return;
        }
        const root = top.stdout.trim();
        const git = (args) => exec("git", [...READ, ...args], { cwd: root, on });
        const listed = await git(["for-each-ref", "--sort=-committerdate", "refs/heads", `--format=${FMT}`]);
        if (listed.code !== 0) throw new Error(listed.stderr.trim());
        const status = await git(["status", "--porcelain=v1", "-z", "--untracked-files=normal"]);
        const trees = await git(["worktree", "list", "--porcelain"]);
        const head = await git(["rev-parse", "--abbrev-ref", "HEAD"]);
        if (key() !== context) return;
        const elsewhere = parseWorktrees(trees.code === 0 ? trees.stdout : "");
        const rows = parseBranches(listed.stdout).map((row) => {
          const where = elsewhere.get(row.name);
          return { ...row, elsewhere: where && where !== root ? where : "" };
        });
        rows.sort((a, b) => Number(b.current) - Number(a.current));
        this.root = root;
        this.on = on;
        this.rows = rows.slice(0, 300);
        this.limited = rows.length > 300;
        this.dirty = status.code === 0 ? dirtyCount(status.stdout) : 0;
        this.head = head.code === 0 ? head.stdout.trim() : "";
        this.error = null;
        this.watch(root, cx);
      } catch (e) {
        if (key() === context) this.error = String(e.message ?? e);
      } finally {
        this.loading = false;
        cx.notify();
      }
    });
  }

  switchTo(name, cx) {
    if (!this.root || this.busy || !name) return;
    const current = this.rows.find((row) => row.current);
    if (current?.name === name) return;
    const root = this.root, on = this.on, context = this.context;
    this.busy = true;
    this.note = null;
    cx.spawn(async (cx) => {
      try {
        const switched = await exec("git", [...READ, "switch", "--", name], { cwd: root, on });
        if (key() !== context) return;
        if (switched.code !== 0) this.note = (switched.stderr || switched.stdout).trim();
      } catch (e) {
        if (key() === context) this.note = String(e.message ?? e);
      } finally {
        this.busy = false;
        this.refresh(cx);
        cx.notify();
      }
    });
    cx.notify();
  }

  row(branch, t) {
    const track = parseTrack(branch.track);
    const detail = branch.elsewhere ? `checked out in ${branch.elsewhere}` : branch.subject;
    return v_flex().id(`branch-${branch.name.replace(/[^A-Za-z0-9_.-]+/g, "-")}`).h(46).flex_none().px(8).justify_center().rounded(7).cursor_pointer()
      .when(branch.current, (el) => el.bg(t.selected))
      .hover((s) => s.bg(t.hover))
      .on_click((_e, cx) => this.switchTo(branch.name, cx))
      .child(h_flex().gap(8).items_center()
        .child(div().size(6).rounded(3).flex_none().bg(branch.current ? t.accent : t.border))
        .child(div().flex_1().min_w(0).truncate().child(branch.name))
        .when(branch.current && this.dirty > 0, (el) => el.child(div().text_size(11).text_color(t.blocked).child(`${this.dirty} dirty`)))
        .when(Boolean(track.ahead), (el) => el.child(div().text_size(11).text_color(t.ansi2).child(`↑${track.ahead}`)))
        .when(Boolean(track.behind), (el) => el.child(div().text_size(11).text_color(t.ansi1).child(`↓${track.behind}`)))
        .child(div().text_size(11).text_color(t.dim).flex_none().child(branch.when || "")))
      .child(div().pl(14).truncate().text_size(11).text_color(t.dim).child(detail || branch.upstream || ""));
  }

  render(cx) {
    if (!checking() && key() !== this.context) this.refresh(cx);
    const t = theme();
    const title = this.head && this.head !== "HEAD" ? this.head : "detached";
    return v_flex().id("branches").size_full().min_h(0).rounded(10).overflow_hidden().bg(t.background).border_1().border_color(t.border).text_color(t.foreground).text_size(13).track_focus(this.handle)
      .child(h_flex().h(42).flex_none().px(14).gap(8).items_center().border_b(1).border_color(t.border)
        .child(div().font_semibold().child("Branches"))
        .child(div().px(5).py(1).rounded(4).border_1().border_color(t.border).text_size(10).text_color(t.muted).child(String(this.rows.length)))
        .child(div().flex_1())
        .child(div().text_size(11).text_color(t.dim).truncate().child(this.root ? title : "")))
      .child(div().flex_1().min_h(0).relative()
        .child(v_flex().id("branches-list").absolute().inset_0().overflow_y_scroll().p(6).gap(2)
          .children(this.rows.map((branch) => this.row(branch, t)))
          .when(!this.rows.length, (el) => el.child(div().p(8).text_color(t.dim).child(this.error || (this.loading ? "Loading branches…" : this.root ? "No local branches" : "No folder")))))
        .child(Scrollbar.vertical("branches-list").absolute().inset_0()))
      .when(this.limited, (el) => el.child(div().px(12).py(4).text_size(11).text_color(t.dim).child("Showing the 300 most recently committed branches")))
      .when(Boolean(this.note), (el) => el.child(div().px(12).py(8).text_size(11).text_color(t.ansi1).child(this.note)))
      .when(this.busy, (el) => el.child(div().px(12).py(8).text_size(11).text_color(t.dim).child("Switching…")));
  }
}
