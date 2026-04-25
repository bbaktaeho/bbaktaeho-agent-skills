---
title: Asset and Token Standards (Solana Indexing Lens)
impact: HIGH
impactDescription: SPL Token and Token-2022 define Solana's asset surface. Detection is via program owner, not event shape; extensions on Token-2022 change transfer semantics.
tags: indexing, spl-token, token-2022, metaplex, ata, nft, solana
---

# Asset Standards (Solana Indexing Lens)

## Concept

Asset indexing on Solana requires knowing which program owns each token account. The SPL Token program and the SPL Token-2022 program have different layouts and different capabilities. Metaplex adds NFT metadata on top. Native SOL (lamports) is not a token and is tracked separately.

## Solana

- **SPL Token** -- accounts owned by `TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA`. Mint account = token definition; Token account = balance holder. Key instructions: `InitializeAccount`, `Transfer`, `MintTo`, `Burn`, `CloseAccount`. Does not emit Anchor-style events -- indexers read instruction data and balance deltas.
- **SPL Token-2022** -- program id `TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb`. Adds extensions: transfer fees, confidential transfers, non-transferable tokens, permanent delegate, transfer hooks, interest-bearing, metadata pointer. Each extension changes balance arithmetic or transfer semantics.
- **Metaplex Token Metadata** (legacy) and **Metaplex Core** (new) -- PDAs carrying NFT metadata keyed on the mint.
- **Associated Token Accounts (ATA)** -- deterministic per `(owner, mint)` pair. Not every token account is an ATA; indexers canonicalize balances per ATA but must still track non-ATA holders.

Native SOL is tracked via `preBalances` / `postBalances`, not through any token program.

Relevant code:

- `<RESEARCH_ROOT>/solana-program-library/token/program/` -- SPL Token.
- `<RESEARCH_ROOT>/solana-program-library/token/program-2022/` -- Token-2022.
- `<RESEARCH_ROOT>/solana-program-library/associated-token-account/` -- ATA program.

## Indexer Design Implications

- Detect standards via program owner (`TokenkegQfe...` vs `TokenzQdB...`), not by inferring from instruction shape.
- For Token-2022, account for transfer fees and transfer hooks in downstream balance tracking; logs and recorded transfer amounts can differ from actual post-fee receipts. Always derive by `post - pre`.
- Canonicalize balances by `(owner, mint)` -- the Token account that holds balance may or may not be the ATA.
- Track decimals per mint (required for display).
- For NFTs, cache Metaplex metadata JSON separately; plan for unreachable URIs and mutable metadata.
- Reconcile mint / burn events against total supply to catch gaps.
- Record the program id that emitted each token transfer -- it is the only reliable way to distinguish SPL and Token-2022 downstream.

## References

- SPL Token: https://spl.solana.com/token
- SPL Token-2022 extensions: https://spl.solana.com/token-2022/extensions
- Metaplex Token Metadata: https://docs.metaplex.com
- Associated Token Account: https://spl.solana.com/associated-token-account
- Related: `idx-event-decoding.md`, `idx-protocol-transfers.md`
