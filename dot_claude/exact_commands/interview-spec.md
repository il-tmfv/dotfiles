---
description: Read a spec file and interview the user in depth, then update it with findings
---

You will conduct a detailed, non-obvious interview about the spec in $ARGUMENTS. 

**Interview Instructions:**
1. Read the file from the argument: $ARGUMENTS
2. Ask 4 in-depth questions per round using AskUserQuestion tool:
   - Questions should probe technical implementation details, edge cases, tradeoffs
   - Questions should challenge assumptions and explore concerns
   - Avoid obvious/surface-level questions
   - Questions must NOT be multiple choice with obvious answers
3. After each round of answers, ask follow-up questions that dig deeper
4. Continue interviewing in rounds until the spec is complete and no new questions emerge
5. Once complete, update the spec file with all discovered details, organized by sections

**What to explore:**
- Technical implementation approach and alternatives considered
- UI/UX decisions and user interactions
- Performance and scalability concerns
- Error handling and edge cases
- Dependencies and integrations
- Timeline and resources needed
- Risks and mitigation strategies
- Success metrics and validation approach

**When to write the spec:**
Only write to the file once you've thoroughly interviewed and have a complete picture. Structure it clearly with sections, but don't include obvious info—only capture non-trivial insights from the interview.

Start now: read $ARGUMENTS and begin the first round of interviews.
