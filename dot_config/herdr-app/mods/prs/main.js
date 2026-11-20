// Open ChatPush pull requests where the current user is author or assignee.
// Same search and fields as https://github.com/il-tmfv/prl/blob/master/prl.sh
import { View, div } from "gpui-kit";
import { h_flex, v_flex, Scrollbar } from "gpui-base";
import { exec, theme, checking, window } from "herdr";

const ORG = "ChatPush";
const REQUIRED_APPROVALS = 1;
const QUERY = `
query($search: String!, $after: String) {
  search(query: $search, type: ISSUE, first: 50, after: $after) {
    pageInfo { hasNextPage endCursor }
    nodes {
      ... on PullRequest {
        title
        url
        number
        createdAt
        isDraft
        body
        reviewDecision
        repository { nameWithOwner }
        latestReviews(first: 50) {
          nodes { state author { login } }
        }
        statusCheckRollup {
          state
          contexts(first: 40) {
            nodes {
              __typename
              ... on CheckRun { name status conclusion }
              ... on StatusContext { context state }
            }
          }
        }
      }
    }
  }
}
`;

function localDate(iso) {
  const date = new Date(iso);
  if (Number.isNaN(date.getTime())) return "";
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${date.getFullYear()}-${month}-${day}`;
}

function preview(body) {
  const lines = (body ?? "").replace(/\r/g, "").split("\n");
  while (lines.length && lines[0] === "") lines.shift();
  return lines.slice(0, 3).join(" ").trim();
}

function failingChecks(rollup) {
  const nodes = rollup?.contexts?.nodes ?? [];
  const names = [];
  for (const node of nodes) {
    if (!node) continue;
    if (node.__typename === "CheckRun") {
      if (node.status !== "COMPLETED" || (node.conclusion ?? "") !== "SUCCESS") names.push(node.name);
    } else if ((node.state ?? "") !== "SUCCESS") names.push(node.context);
  }
  return names.filter(Boolean);
}

function shape(pr) {
  const approvers = new Set();
  for (const review of pr.latestReviews?.nodes ?? []) {
    if (review?.state === "APPROVED" && review.author?.login) approvers.add(review.author.login);
  }
  return {
    createdAt: pr.createdAt ?? "",
    created: localDate(pr.createdAt),
    repo: pr.repository?.nameWithOwner ?? "",
    number: pr.number,
    title: pr.title ?? "",
    url: pr.url,
    draft: Boolean(pr.isDraft),
    decision: pr.reviewDecision ?? "NONE",
    approvals: approvers.size,
    ci: pr.statusCheckRollup?.state ?? "NONE",
    ciBad: failingChecks(pr.statusCheckRollup),
    preview: preview(pr.body),
  };
}

async function gh(args) {
  const result = await exec("gh", args, { timeout: 60_000 });
  if (result.code !== 0) throw new Error((result.stderr || result.stdout).trim() || "gh failed");
  const payload = JSON.parse(result.stdout || "{}");
  if (payload.errors?.length) throw new Error(payload.errors.map((error) => error.message).join("; "));
  return payload.data;
}

async function search(search) {
  const nodes = [];
  let after = "";
  for (let page = 0; page < 4; page++) {
    const args = ["api", "graphql", "-f", `query=${QUERY}`, "-f", `search=${search}`];
    if (after) args.push("-f", `after=${after}`);
    const data = await gh(args);
    const found = data?.search;
    for (const node of found?.nodes ?? []) if (node?.url) nodes.push(node);
    if (!found?.pageInfo?.hasNextPage) return { nodes, limited: false };
    after = found.pageInfo.endCursor ?? "";
    if (!after) return { nodes, limited: false };
  }
  return { nodes, limited: true };
}

function ciColor(state, t) {
  if (state === "SUCCESS") return t.ansi2;
  if (state === "FAILURE" || state === "ERROR") return t.ansi1;
  if (state === "PENDING" || state === "EXPECTED") return t.ansi3;
  return t.dim;
}

export default class PullRequests extends View {
  init(_props, cx) {
    this.rows = [];
    this.handle = cx.focus_handle();
    if (checking()) return;
    this.refresh(cx);
    cx.timer.every(60_000, (cx) => this.refresh(cx));
  }

  refresh(cx) {
    if (this.loading) return;
    this.loading = true;
    cx.spawn(async (cx) => {
      try {
        const authored = await search(`org:${ORG} is:open is:pr author:@me`);
        const assigned = await search(`org:${ORG} is:open is:pr assignee:@me`);
        const byUrl = new Map();
        for (const pr of [...authored.nodes, ...assigned.nodes]) byUrl.set(pr.url, pr);
        this.rows = [...byUrl.values()].map(shape).sort((a, b) => a.createdAt.localeCompare(b.createdAt));
        this.limited = authored.limited || assigned.limited;
        this.loaded = true;
        this.error = null;
        this.note = null;
      } catch (e) {
        const message = String(e.message ?? e);
        if (this.rows.length) this.note = message;
        else this.error = message;
      } finally {
        this.loading = false;
        cx.notify();
      }
    });
  }

  open(url, cx) {
    const platform = window()?.platform;
    const command = platform === "windows" ? "cmd" : platform === "linux" ? "xdg-open" : "open";
    const args = platform === "windows" ? ["/c", "start", "", url] : [url];
    cx.spawn(async (cx) => {
      try {
        const result = await exec(command, args);
        if (result.code !== 0) this.note = (result.stderr || result.stdout).trim() || "Could not open the pull request";
      } catch (e) {
        this.note = String(e.message ?? e);
      }
      cx.notify();
    });
  }

  row(pr, t) {
    const ready = pr.approvals >= REQUIRED_APPROVALS;
    const detail = pr.ciBad.length ? pr.ciBad.join(", ") : (pr.preview || "(no description)");
    const id = `${pr.repo}-${pr.number}`.replace(/[^A-Za-z0-9_.-]+/g, "-");
    return v_flex().id(`pr-${id}`).h(58).flex_none().px(8).justify_center().rounded(7).cursor_pointer()
      .hover((s) => s.bg(t.hover))
      .on_click((_e, cx) => this.open(pr.url, cx))
      .child(h_flex().gap(6).items_center()
        .child(div().text_size(11).text_color(t.dim).flex_none().child(pr.created))
        .child(div().text_size(11).text_color(pr.draft ? t.ansi3 : t.ansi2).flex_none().child(pr.draft ? "DRAFT" : "READY"))
        .child(div().text_size(11).text_color(ciColor(pr.ci, t)).flex_none().child(`CI:${pr.ci}`))
        .child(div().flex_1())
        .child(div().text_size(11).text_color(ready ? t.ansi2 : t.ansi3).flex_none().child(`${pr.approvals}/${REQUIRED_APPROVALS} ${pr.decision}`)))
      .child(div().truncate().child(`${pr.repo}#${pr.number}  ${pr.title}`))
      .child(div().truncate().text_size(11).text_color(t.dim).child(detail));
  }

  render() {
    const t = theme();
    const empty = this.error || (this.loaded ? `No open PRs in ${ORG} where you are author or assignee.` : "Loading pull requests…");
    return v_flex().id("prs").size_full().min_h(0).rounded(10).overflow_hidden().bg(t.background).border_1().border_color(t.border).text_color(t.foreground).text_size(13).track_focus(this.handle)
      .child(h_flex().h(42).flex_none().px(14).gap(8).items_center().border_b(1).border_color(t.border)
        .child(div().font_semibold().child("PRs"))
        .child(div().px(5).py(1).rounded(4).border_1().border_color(t.border).text_size(10).text_color(t.muted).child(String(this.rows.length)))
        .child(div().flex_1())
        .child(div().text_size(11).text_color(t.dim).child(ORG)))
      .child(div().flex_1().min_h(0).relative()
        .child(v_flex().id("prs-list").absolute().inset_0().overflow_y_scroll().p(6).gap(2)
          .children(this.rows.map((pr) => this.row(pr, t)))
          .when(!this.rows.length, (el) => el.child(div().p(8).text_color(t.dim).child(empty))))
        .child(Scrollbar.vertical("prs-list").absolute().inset_0()))
      .when(this.limited, (el) => el.child(div().px(12).py(4).text_size(11).text_color(t.dim).child("Showing the first 200 pull requests of a search")))
      .when(Boolean(this.note), (el) => el.child(div().px(12).py(8).text_size(11).text_color(t.ansi1).child(this.note)));
  }
}
