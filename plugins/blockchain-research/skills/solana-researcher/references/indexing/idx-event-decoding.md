---
title: Event, Log, and Inner Instruction Decoding (Solana Indexing Lens)
impact: HIGH
impactDescription: Solana exposes program semantics primarily through inner instructions and program logs; missing either misses most program meaning.
tags: indexing, events, logs, idl, anchor, borsh, cpi, inner-instructions, solana
---

# Event Decoding (Solana Indexing Lens)

## Concept

Solana has no single "event" mechanism. Program semantics surface through three channels: unstructured program logs (`Program log:` / `Program data:`), inner instructions (CPI tree), and Anchor `emit!` events (typed Borsh with an 8-byte discriminator written to `Program data:`). An indexer must read all three.

## Solana

**Program logs** are line-based strings:

- `Program <PID> invoke [<depth>]` -- CPI push.
- `Program log: <text>` -- `sol_log` / `msg!` output.
- `Program data: <base64>` -- `sol_log_data` / Anchor `emit!` payload.
- `Program <PID> consumed <N> of <M> compute units` -- per-frame CU.
- `Program <PID> success` / `failed: <reason>` -- frame close.

**Inner instructions** are in `meta.innerInstructions` and carry the full CPI tree with `stackHeight`. Reconstruct the tree with a stack-based parser: push when `stackHeight` increases, pop when it decreases or equals.

**Anchor `emit!`** writes `[0..8] = sha256("event:<StructName>")[0..8]` followed by Borsh-serialized body. Anchor ix discriminators are `sha256("global:<ix_name>")[0..8]`.

Non-Anchor programs use ad-hoc log strings; the indexer needs per-program custom parsers.

Relevant code:

- `<RESEARCH_ROOT>/solana/runtime/src/message_processor.rs` -- how logs and inner instructions are assembled.
- `<RESEARCH_ROOT>/solana-program-library/` -- SPL program sources as decoding references.

## Indexer Design Implications

- Always read inner instructions alongside logs; logs alone miss program semantics.
- Maintain a per-program IDL / ABI registry keyed by program id. Populate via Anchor IDL endpoints, user upload, or Shyft-style auto-decoders.
- For Anchor programs, extract discriminators and decode Borsh via the IDL; for non-Anchor programs, write custom parsers.
- Run a log-frame parser (push / pop / close) to extract per-frame CU and per-frame events.
- Use balance delta cross-checks to validate event decoding when possible -- a u64 field in an Anchor event matching a balance delta is strong evidence.
- Never drop undecodable events silently; log and store raw for later analysis.

## References

- Anchor events / IDL: https://www.anchor-lang.com/docs/events
- Solana inner instructions: https://solana.com/docs/rpc/http/gettransaction
- Related: `idx-asset-standards.md`, `idx-tx-envelope.md`
