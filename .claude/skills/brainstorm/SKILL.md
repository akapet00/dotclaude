---
name: brainstorm
description: "Interviews the user relentlessly about a plan or design until reaching shared understanding. Strict trigger: only invoke when the user explicitly says `/brainstorm` or `brainstorm` verbatim."
disable-model-invocation: true
---

Interview me relentlessly about every aspect of the plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

Ask the questions one at a time, and wait for my answer before asking the next question.

For each question, provide your recommended answers that I can choose from. Also provide an option for me to provide my own answer if none of the recommendations are suitable. From the recommended answers, provide the one that you think is best, and explain why you think it's the best choice.

If a question can be answered by exploring the codebase or documentation, do so and use that information to inform your next question. Reference any relevant files, lines of code, or documentation in your questions.
