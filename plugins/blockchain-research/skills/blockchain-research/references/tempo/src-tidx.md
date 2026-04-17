---
title: tidx Tempo Chain Indexer Source Code Navigation
impact: CRITICAL
impactDescription: Primary source for raw and indexed on-chain data analysis -- blocks, txs, logs, receipts, ABI decoding
tags: tidx, indexer, clickhouse, postgres, abi-decode, sync, rpc
---

# tidx Tempo Chain Indexer Source Code Navigation

tidx is a high-throughput Tempo blockchain indexer written in Rust. It indexes all on-chain data (blocks, transactions, logs, receipts) into a hybrid dual-storage backend: PostgreSQL (OLTP, point lookups) and ClickHouse (OLAP, aggregations). Key feature: ABI event decoding without pre-registration -- supply an event signature at query time and the system generates a CTE to decode raw log bytes on-the-fly.

For researchers, tidx is the authoritative source for:
- Raw on-chain data schemas (what fields Tempo blocks/txs/logs expose)
- Tempo-specific transaction fields (fee delegation, nonce abstraction, validity windows)
- How to query indexed data via SQL (PostgreSQL or ClickHouse)
- Understanding the sync and reorg handling pipeline

Local submodule path: `<RESEARCH_ROOT>/tidx`

## Key Directory Map

| Directory / File | Description |
|-----------------|-------------|
| `src/types.rs` | Core data structs: BlockRow, TxRow, LogRow, ReceiptRow, SyncState |
| `src/tempo.rs` | Tempo-alloy type aliases bridging alloy + Tempo-specific tx envelopes |
| `src/config.rs` | Config, ChainConfig, ClickHouseConfig structs and all tunables |
| `src/sync/engine.rs` | SyncEngine orchestrator: realtime sync, gap-fill, reorg handling |
| `src/sync/fetcher.rs` | RPC client: eth_getBlockByNumber, eth_getBlockReceipts, eth_getLogs |
| `src/sync/decoder.rs` | Raw field extraction from RPC types into BlockRow/TxRow/LogRow/ReceiptRow |
| `src/sync/writer.rs` | PostgreSQL binary COPY batch writer (staging table pattern) |
| `src/sync/ch_sink.rs` | ClickHouse direct-write sink (RowBinary + LZ4, 10k-row chunks) |
| `src/sync/sink.rs` | Sink trait + SinkSet fan-out (PG + CH written in parallel) |
| `src/query/mod.rs` | ABI types: AbiParam, AbiType, EventSignature; hex 0x -> \x rewriting |
| `src/query/parser.rs` | SQL AST parsing for columns, predicates, GROUP/ORDER BY |
| `src/query/validator.rs` | SELECT-only allowlist validation, HARD_LIMIT_MAX |
| `src/query/router.rs` | QueryEngine enum: routes to PostgreSQL or ClickHouse |
| `src/service/mod.rs` | CTE generation for event signatures (the ABI decode mechanism) |
| `src/api/mod.rs` | Axum HTTP routes: /health, /status, /query (SSE), /views, /metrics |
| `src/clickhouse.rs` | ClickHouseEngine: HTTP execution, failover, CTE predicate rewrite |
| `src/broadcast.rs` | Tokio broadcast channel for SSE live block streaming |
| `src/metrics.rs` | 20+ Prometheus metrics (counters, gauges, histograms) |
| `db/blocks.sql` | PostgreSQL blocks table schema + indexes |
| `db/txs.sql` | PostgreSQL txs table schema + indexes (incl. Tempo-specific fields) |
| `db/logs.sql` | PostgreSQL logs table schema + indexes |
| `db/receipts.sql` | PostgreSQL receipts table schema + indexes |
| `db/functions.sql` | ABI decode PL/pgSQL functions (abi_uint, abi_int, abi_address, ...) |
| `db/sync_state.sql` | sync_state table (synced_num, tip_num, backfill_num, ch_backfill_block) |
| `db/clickhouse/` | ClickHouse table schemas (ReplacingMergeTree, monthly partitions) |
| `config.toml` | Example config (Moderato testnet + Presto mainnet) |

## Data Schemas

### blocks table

| Field | Type | Description |
|-------|------|-------------|
| num | bigint | Block number |
| hash | bytea | Block hash |
| parent_hash | bytea | Parent block hash |
| timestamp | timestamptz | Block timestamp (second precision) |
| timestamp_ms | bigint | Block timestamp (millisecond precision) |
| gas_limit | numeric | Gas limit |
| gas_used | numeric | Gas used |
| miner | bytea | Block proposer address |
| extra_data | bytea | Extra data field |

### txs table (Tempo-extended)

| Field | Type | Description |
|-------|------|-------------|
| block_num | bigint | Block number |
| hash | bytea | Transaction hash |
| tx_type | smallint | Transaction type (0x76 = Tempo Tx, etc.) |
| from | bytea | Sender address |
| to | bytea | Recipient address (null for contract creation) |
| value | numeric | ETH value |
| input | bytea | Calldata (raw) |
| gas_limit | numeric | Gas limit |
| max_fee_per_gas | numeric | Max fee per gas |
| nonce | numeric | Sender nonce |
| calls | jsonb | Nested call trace with call_count |
| fee_token | bytea | **Tempo-specific**: fee payment token address |
| fee_payer | bytea | **Tempo-specific**: fee delegation address |
| nonce_key | bytea | **Tempo-specific**: 2D nonce key |
| valid_before | bigint | **Tempo-specific**: expiring nonce upper bound |
| valid_after | bigint | **Tempo-specific**: scheduled tx lower bound |
| signature_type | smallint | **Tempo-specific**: signing scheme (secp256k1, P-256, etc.) |

### logs table

| Field | Type | Description |
|-------|------|-------------|
| block_num | bigint | Block number |
| log_idx | integer | Log index within block |
| tx_hash | bytea | Transaction hash |
| address | bytea | Emitting contract address |
| selector | bytea | topic0 (event selector) |
| topic0-3 | bytea | Raw topic bytes |
| data | bytea | Raw log data bytes |

### receipts table

| Field | Type | Description |
|-------|------|-------------|
| tx_hash | bytea | Transaction hash |
| from | bytea | Sender address |
| to | bytea | Recipient address |
| contract_address | bytea | Deployed contract (null if not creation) |
| gas_used | numeric | Gas used |
| cumulative_gas_used | numeric | Cumulative gas used in block |
| effective_gas_price | numeric | Effective gas price paid |
| status | smallint | 1 = success, 0 = failure |
| fee_payer | bytea | **Tempo-specific**: actual fee payer |

## How to Search

```bash
# Find all Tempo-specific transaction fields
grep -rn "fee_payer\|fee_token\|nonce_key\|valid_before\|valid_after\|signature_type" src/

# Find reorg detection and handling
grep -rn "reorg\|handle_reorg\|fork_point\|parent_hash" src/sync/

# Find ABI event signature CTE generation
grep -rn "EventSignature\|AbiParam\|generate_cte\|cte_for_signature" src/query/ src/service/

# Find ClickHouse predicate pushdown rewriting
grep -rn "predicate\|pushdown\|inject_block_filter\|rewrite" src/clickhouse.rs src/query/

# Find PostgreSQL binary COPY path
grep -rn "COPY\|staging\|binary_copy\|ON CONFLICT" src/sync/writer.rs

# Find RPC fetch logic and chunking strategy
grep -rn "eth_getLogs\|chunk\|semaphore\|adaptive" src/sync/fetcher.rs

# Find SSE live query streaming
grep -rn "live\|sse\|EventStream\|broadcast\|inject_block_filter" src/api/ src/broadcast.rs

# Find Prometheus metrics definitions
grep -rn "register_counter\|register_gauge\|register_histogram" src/metrics.rs

# Find sync state management
grep -rn "synced_num\|tip_num\|backfill_num\|ch_backfill_block" src/ db/

# Find the ABI decode SQL functions
grep -n "abi_uint\|abi_int\|abi_address\|abi_bool\|abi_bytes" db/functions.sql
```

## Common Investigation Paths

**"What raw fields does a Tempo transaction expose?"**
- `src/types.rs` -- `TxRow` struct for all indexed fields
- `db/txs.sql` -- PostgreSQL schema with column types and indexes
- `src/sync/decoder.rs` -- how RPC response maps to TxRow fields
- Focus on Tempo-specific fields: `fee_token`, `fee_payer`, `nonce_key`, `valid_before`, `valid_after`, `signature_type`

**"How does ABI event decoding work without pre-registration?"**
- `src/query/mod.rs` -- `EventSignature`, `AbiParam`, `AbiType` types
- `src/service/mod.rs` -- CTE generation from an event signature string
- `db/functions.sql` -- the underlying `abi_uint()`, `abi_address()`, etc. PL/pgSQL functions
- API usage: `GET /query?sql=SELECT * FROM logs&signature=Transfer(address indexed from,address indexed to,uint256 value)`

**"How does the sync pipeline work?"**
- `src/sync/engine.rs` -- three concurrent tasks: realtime (follows head), gap-fill (parallel workers), receipt backfill
- `src/sync/fetcher.rs` -- RPC client with adaptive chunking and semaphore throttling
- `src/sync/decoder.rs` -- raw RPC -> Row struct mapping
- `src/sync/sink.rs` -- `SinkSet` fans out to PG + CH concurrently

**"How does reorg handling work?"**
- `src/sync/engine.rs` -- scans back 128 blocks on hash mismatch
- Finds fork point by walking parent hashes
- Deletes orphaned rows from all tables
- Resumes sync from fork point

**"How to query Tempo-specific transactions?"**

Example SQL queries via the `/query` API:

```sql
-- Find transactions with fee delegation (not self-paying)
SELECT hash, from, to, fee_payer, fee_token
FROM txs
WHERE fee_payer != from
ORDER BY block_num DESC
LIMIT 100;

-- Find scheduled transactions (valid_after set)
SELECT hash, from, to, valid_after, valid_before
FROM txs
WHERE valid_after IS NOT NULL
ORDER BY block_num DESC;

-- Find transactions by nonce key (2D nonce usage)
SELECT hash, from, nonce_key, nonce
FROM txs
WHERE nonce_key != '\x0000000000000000000000000000000000000000000000000000000000000000'
ORDER BY block_num DESC;

-- Decode Transfer events using ABI signature (via ?signature= parameter)
SELECT block_num, tx_hash, topic1, topic2, data
FROM logs
WHERE selector = '\xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
ORDER BY block_num DESC;
```

**"What does the ClickHouse schema look like for analytics?"**
- `db/clickhouse/blocks.sql` -- `ReplacingMergeTree`, monthly partitions
- `db/clickhouse/logs.sql` -- bloom_filter indexes on selector, address, topic0-3
- Use `?engine=clickhouse` in `/query` for aggregation-heavy queries
- Use `?engine=postgres` for hash/address lookups

**"How to get live streaming data?"**
- `GET /query?sql=SELECT * FROM txs&live=true&chainId=42431` -- SSE stream
- `src/broadcast.rs` -- Tokio broadcast channel for new block events
- `src/api/mod.rs` -- SSE handler with `inject_block_filter()` for WHERE clause injection

## HTTP API Reference

| Endpoint | Description |
|----------|-------------|
| `GET /health` | Liveness check ("OK") |
| `GET /status` | Per-chain sync watermarks (PG + CH) |
| `GET /query?sql=...&chainId=...` | Execute SQL (PostgreSQL or ClickHouse) |
| `GET /query?sql=...&live=true` | SSE live streaming |
| `GET /query?sql=...&signature=Event(...)` | SQL with ABI event decoding |
| `GET /views` | List ClickHouse materialized views |
| `POST /views` | Create a materialized view |
| `DELETE /views/{name}` | Delete a view |
| `GET /metrics` | Prometheus metrics (port 9090) |

Query parameters: `sql`, `chainId`, `engine` (postgres|clickhouse), `live`, `signature`, `timeout_ms`, `limit`.

## Network Endpoints

| Network | Chain ID | RPC |
|---------|---------|-----|
| Mainnet (Presto) | 4217 | `https://rpc.tempo.xyz` |
| Testnet (Moderato) | 42431 | `https://rpc.testnet.tempo.xyz` |

## References

- https://github.com/tempoxyz/tidx
- https://docs.tempo.xyz
