---
name: programming-principles
description: >
  Programming principles and philosophy based on Rob Pike's 5 Rules of Programming,
  with related wisdom from Tony Hoare, Ken Thompson, and Fred Brooks. Make sure to
  use this skill whenever the user is making optimization decisions, choosing
  between simple and complex algorithms, designing data structures, evaluating
  performance tuning approaches, reviewing code for unnecessary complexity, or
  pushing back on premature optimization and over-engineering - even if they do
  not explicitly mention Pike, principles, or philosophy. Also use whenever
  someone proposes clever or elaborate code, debates "fast vs. simple", or argues
  about whether an abstraction is worth it.
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: March 2026
  abstract: >
    Programming principles derived from Rob Pike's 5 Rules of Programming, with
    related wisdom from Tony Hoare, Ken Thompson, and Fred Brooks. Contains rules
    across 5 categories covering premature optimization, measurement-driven tuning,
    algorithm simplicity, correctness, and data structure design. Each rule includes
    explanations, incorrect vs. correct examples, and specific guidance.
---

# Programming Principles

Rob Pike's 5 Rules of Programming and related engineering wisdom for writing simple, correct, and efficient code.

## When to Apply

Reference these guidelines when:
- Deciding whether to optimize code
- Choosing between simple and complex algorithms
- Designing data structures for a new feature
- Reviewing code for unnecessary complexity
- Evaluating performance tuning approaches
- Debating algorithm choice during code review

## Rule Categories by Priority

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Measure Before Optimizing | CRITICAL | `meas-` |
| 2 | Profile Before Tuning | CRITICAL | `prof-` |
| 3 | Simplicity Over Fancy Algorithms | HIGH | `simp-` |
| 4 | Simple Means Correct | HIGH | `corr-` |
| 5 | Data Dominates | HIGH | `data-` |

## How to Use

Read individual rule files for detailed explanations and examples:

- `references/meas-no-premature-optimization.md` -- Rule 1
- `references/prof-measure-then-tune.md` -- Rule 2
- `references/simp-small-n.md` -- Rule 3
- `references/corr-simple-algorithms.md` -- Rule 4
- `references/data-structures-first.md` -- Rule 5

Section definitions live in `references/_sections.md`.

Each rule file contains:
- The original rule statement
- Related quotes from other pioneers
- Incorrect approach with explanation
- Correct approach with explanation

## Key Principles

| Principle | One-liner |
|-----------|-----------|
| No premature optimization | Bottlenecks occur in surprising places |
| Measure first | Don't tune until you've measured |
| Keep it simple | Fancy algorithms have big constants |
| Simple = correct | Fancy algorithms are buggier |
| Data dominates | Right data structures make algorithms obvious |

## References

- Rob Pike's Rules of Programming: https://users.ece.utexas.edu/~adnan/pike.html
- C.A.R. Hoare on premature optimization
- Ken Thompson: "When in doubt, use brute force"
- Fred Brooks, The Mythical Man-Month
