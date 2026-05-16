---
name: research
description: "Runs the research process to explore the user's question, hypothesis, or problem statement. Combines literature review, codebase exploration, and user interviews to gather insights and generate a comprehensive report. Strict trigger: only invoke when the user explicitly says `/research` or `research` verbatim."
disable-model-invocation: true
---

Interview me relentlessly about every aspect of the research question until we reach a shared understanding. Let's work back and forth between the codebase, documentation, and literature to explore the topic from all angles.

For literature review, use the Semantic Scholar API (use skill or mcp if available; confirm with me before proceeding) to find relevant papers, analyze their contributions, and synthesize insights. For codebase exploration, identify relevant files, functions, and documentation that can shed light on the question. For interviewing me, ask targeted questions to clarify assumptions, gather context, and validate findings.

Ask questions one at a time, and wait for my answer before asking the next. For each question, list recommended answers I can pick from, plus an option to write my own. Mark the one you think is best and say why. Reference any relevant files, lines of code, documentation, or papers in your questions to ground the discussion in evidence.

After gathering insights from all sources, synthesize the findings into a comprehensive report `RESEARCH.md` that addresses the research question, highlights key insights, and suggests next steps for further investigation or action. Confirm the structure, content, and path of the report with me before writing it. Make sure to check the existing `RESEARCH.md` if it exists to avoid duplicating content and to build upon previous findings.
