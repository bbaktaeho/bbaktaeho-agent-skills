---
title: Asset and Token Standards (Indexing Lens)
impact: HIGH
impactDescription: Indexers must recognize and track each asset standard to surface fungible, non-fungible, and composite balances correctly.
tags: indexing, erc-20, erc-721, erc-1155, spl, metaplex, tip-20, token, nft, ethereum, solana, tempo
---

# Asset Standards (Indexing Lens)

## Concept

Asset indexing requires knowing which standard a contract or program implements: the standard dictates event semantics, balance computation rules, metadata location, and transfer mechanics. Standards also layer (EIP-2612 permit atop ERC-20, Token-2022 extensions atop SPL Token) -- indexers must detect and compose them.

## Cross-Chain Comparison

| Aspect | Ethereum | Solana | Tempo |
|--------|----------|--------|-------|
| Fungible token | ERC-20 | SPL Token, SPL Token-2022 | TIP-20 |
| NFT | ERC-721 | Metaplex Token Metadata (legacy), Core (new) | ERC-721 compatible |
| Multi-token | ERC-1155 | Core (composable) | N/A |
| Metadata | `tokenURI` + JSON schema | Metaplex PDA keyed by mint | ERC-compatible metadata |
| Native asset | ETH (not a token) | SOL (native lamports, not a Token-program asset) | Tempo native asset |
| Detection | ERC-165 interface ID or event shape | Program owner = Token program id | ERC-165 / event shape |

## Ethereum

- **ERC-20**: `Transfer(address from, address to, uint256 value)`, `Approval(...)`. Balances derivable from Transfer history.
- **ERC-721**: `Transfer(address from, address to, uint256 tokenId)` with indexed tokenId. Supports `tokenURI(tokenId)`.
- **ERC-1155**: `TransferSingle`, `TransferBatch`, `ApprovalForAll`. Multi-token per contract.
- **ERC-4626**: Vault standard atop ERC-20; adds `Deposit`, `Withdraw` events.
- **EIP-2612 Permit**: extension to ERC-20; indexers do not need to track Permit separately for balance computation.
- **EIP-165**: interface detection via `supportsInterface(bytes4)`.

Relevant code: `<RESEARCH_ROOT>/EIPs/EIPS/` for spec text; contract implementations in OpenZeppelin serve as off-repo reference. Phase 2 file: `ethereum/idx-asset-standards.md`.

## Solana

- **SPL Token**: accounts owned by the Token program. Mint account = token definition; Token account = balance holder. `InitializeAccount`, `Transfer`, `MintTo`, `Burn` instructions. Does not emit Anchor events -- indexer reads instruction data.
- **SPL Token-2022**: extension system adds transfer hooks, confidential transfers, non-transferable tokens, permanent delegate, and more. Detection via program owner = Token-2022 program id.
- **Metaplex Token Metadata**: PDA seeded from mint address holds NFT metadata. Legacy Token Metadata program and newer Core program differ in state layout.
- **Associated Token Accounts (ATA)**: deterministic address per (owner, mint) pair. Indexers canonicalize balances per ATA.

Relevant code: `<RESEARCH_ROOT>/solana-program-library/token/program/`, `<RESEARCH_ROOT>/solana-program-library/token/program-2022/`. Phase 2 file: `solana/idx-asset-standards.md`.

## Tempo

- **TIP-20**: Tempo fungible token standard, shape-compatible with ERC-20. Integrates with Payment Lanes and Fee AMM accounting.
- EVM-compatible contracts deployed on Tempo may implement ERC-20 / 721 / 1155 directly. Indexer detection follows Ethereum patterns.

Relevant code: `<RESEARCH_ROOT>/tempo/crates/contracts/`, Tempo docs. Phase 2 file: `tempo/idx-asset-standards.md`.

## Indexer Design Implications

- Detect standards via on-chain metadata where possible (EIP-165, program owner) rather than inferring from event shape alone.
- Track decimals per token (required for display; set at mint time).
- For NFTs, cache metadata JSON separately; plan for unreachable URIs and mutable metadata.
- For Token-2022, account for non-transferable, transfer hooks, and confidential transfer semantics in downstream balance tracking.
- Reconcile mint / burn events against total supply to catch gaps.
- Native asset (ETH / SOL / Tempo) is not a token -- track it via account state diffs or protocol-level transfers (see `idx-protocol-transfers.md`).
- For SPL Token, canonicalize balances by (owner, mint) even when the underlying Token account is not the ATA.

## References

- ERC-20: https://eips.ethereum.org/EIPS/eip-20
- ERC-721: https://eips.ethereum.org/EIPS/eip-721
- ERC-1155: https://eips.ethereum.org/EIPS/eip-1155
- ERC-4626: https://eips.ethereum.org/EIPS/eip-4626
- SPL Token: https://spl.solana.com/token
- SPL Token-2022: https://spl.solana.com/token-2022
- Metaplex: https://docs.metaplex.com
- Tempo TIP-20: https://docs.tempo.xyz
- Related: `idx-event-decoding.md`, `idx-protocol-transfers.md`
