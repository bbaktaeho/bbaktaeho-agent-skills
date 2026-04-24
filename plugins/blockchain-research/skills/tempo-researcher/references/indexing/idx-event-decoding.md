---
title: Event, Log, and ABI Decoding (Tempo Indexing Lens)
impact: HIGH
impactDescription: tidx decodes events at ingest via its ABI registry. Indexers can query decoded records directly; custom decoders are needed for Tempo-specific tx fields.
tags: indexing, events, logs, abi, tidx, decoding, tempo
---

# Event Decoding (Tempo Indexing Lens)

## Concept

Raw chain data must be decoded into structured records before it is useful. Tempo uses EVM-compatible log structures (topics + data blob). tidx ships an ABI registry and decodes events at ingest time via SQL functions; downstream consumers query decoded rows directly.

## Tempo

**Logs** carry up to 4 topics + a data blob, identical to Ethereum. Topic 0 is `keccak256(event signature)` for standard events. Bloom filters at block and receipt level enable efficient address / topic lookup.

**tidx ABI registry** stores contract ABIs and decodes events at ingest. Decoded fields are accessible via the `/query` API and via SQL functions defined in `<RESEARCH_ROOT>/tidx/db/functions.sql`. For contracts not yet in the registry, tidx stores raw logs and can backfill decoded records when the ABI is added.

**Tempo-specific tx fields** (fee delegator, nonce key, validity window) are not logs and are not in the ABI. They need custom decoders that operate on the envelope. tidx handles this in `<RESEARCH_ROOT>/tidx/src/types.rs`.

**Internal calls** surface via `debug_traceTransaction` (Reth-compatible) or via tidx's own trace ingestion if configured.

Relevant code:

- `<RESEARCH_ROOT>/tempo/crates/evm/` -- EVM execution producing logs.
- `<RESEARCH_ROOT>/tidx/src/service/mod.rs` -- decoding service.
- `<RESEARCH_ROOT>/tidx/db/functions.sql` -- SQL helpers for decoded queries.
- `<RESEARCH_ROOT>/tidx/src/types.rs` -- Tempo tx field layout.

## Indexer Design Implications

- If you need decoded events, query tidx rather than re-implementing ABI decoding. It is already canonical for Tempo.
- For unknown contracts, tidx stores raw logs; add ABIs to the tidx registry rather than decoding client-side.
- Custom decoders are still needed for Tempo-specific tx fields -- copy tidx's approach.
- Keep raw logs alongside decoded records so a re-decode is possible if a schema changes.
- Verify tidx's ABI registry has the contracts you care about before relying on decoded output.

## References

- tidx: https://github.com/tempoxyz/tidx
- Tempo docs: https://docs.tempo.xyz
- Related: `idx-asset-standards.md`, `idx-tx-envelope.md`
