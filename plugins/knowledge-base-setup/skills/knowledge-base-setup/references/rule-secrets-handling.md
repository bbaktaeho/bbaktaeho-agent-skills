---
title: Secrets Handling Rules
impact: CRITICAL
impactDescription: 지식베이스에 자격증명 / 엔드포인트 / 토큰 등 민감 정보가 유입되지 않도록 하는 규칙
tags: secrets, security, gitignore, hooks
---

# Secrets Handling

지식베이스 (`.md` / 커밋된 파일 전반) 에는 **민감 정보를 넣지 않는다**. 유출 위험 + 제거가 어려움 (git 히스토리 영구 잔존).

## 금지 대상

아래 유형은 지식베이스에 **평문으로 남기지 않는다**:

- **자격증명**: 패스워드, API 키, secret, 토큰 (GitHub / AWS / JWT 등)
- **엔드포인트**: 내부 IP, 비공개 도메인, 개발/스테이징 서버 주소 (port 포함)
- **키 파일 내용**: PEM / OpenSSH private key, certificate private half
- **개인식별정보 (PII)**: 실제 이메일, 전화번호, 실명 (테스트 데이터 제외)
- **Basic auth URL**: `https://user:pass@host/...` 형태

예시 — 다음은 **전부 위반**:

```markdown
# 잘못된 예

DB 접속: `postgres://admin:Sup3rSecret@10.0.1.5:5432/app`

API 호출:
```
curl -H "Authorization: Bearer ghp_aBcDeFgH1234567890..." \
     https://internal-api.corp.example.com/v1/users
```

Private key 복구 시:
```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEA...
```
```

## 허용 방법 3가지

### 1. 사용자 입력 프롬프트 (권장)

실행 시점에 사용자가 값을 제공. 문서에는 **변수 플레이스홀더** 만 둔다.

```markdown
# 올바른 예

DB 접속:
```
postgres://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}
```

Bearer 토큰:
```
Authorization: Bearer ${GITHUB_TOKEN}
```
```

AI 가 이 문서를 실행/참조할 때, 실제 값은 사용자 프롬프트 또는 환경변수에서 가져온다.

### 2. `.kb/local/` — gitignored 로컬 파일

로컬에만 존재하는 파일에 민감 정보 저장. 지식 문서는 **경로만 참조**.

```
.kb/
├── local/                        ← gitignored
│   ├── README.md                 ← 이 디렉토리의 용도 설명 (커밋 대상이 아님)
│   ├── secrets.yaml              ← 실제 값 (로컬 전용)
│   └── endpoints.yaml
└── local.example/                ← 커밋 대상 (템플릿)
    ├── secrets.example.yaml      ← 빈 템플릿
    └── endpoints.example.yaml
```

`.gitignore` 에 `.kb/local/` 추가 (스킬이 자동 처리).

지식 문서에서 참조:

```markdown
## 접속 정보

실제 값은 `.kb/local/secrets.yaml` 에 있습니다. 템플릿: `.kb/local.example/secrets.example.yaml`

로컬 셋업 방법:
1. `.kb/local.example/secrets.example.yaml` 을 `.kb/local/secrets.yaml` 로 복사
2. 실제 값으로 채움
3. 절대 커밋하지 말 것 (`.gitignore` 되어 있음)
```

AI 가 참조할 때: 경로로 직접 읽음. 파일이 없으면 사용자에게 "로컬에 `.kb/local/secrets.yaml` 을 생성하세요" 안내.

### 3. 환경변수 / 외부 secret store

CI / 프로덕션 환경: 1Password, AWS Secrets Manager, Vault, 환경변수 등.

지식 문서는 **이름만** 명시:

```markdown
## 필요한 환경변수

- `DB_PASSWORD` — 1Password "prod-db" 항목
- `GITHUB_TOKEN` — 개인 PAT (scope: `repo`)
- `SENTRY_DSN` — Sentry 프로젝트 설정 페이지
```

이름과 획득 위치만. 실제 값은 절대 문서에 없음.

## `.kb/local/` 디렉토리 규약

- **존재 자체가 gitignored**: `.gitignore` 에 `.kb/local/` 추가
- **루트 README.md 에서 언급**: "로컬 전용 데이터는 `.kb/local/` 에"
- **템플릿은 `.kb/local.example/`**: 커밋 대상. 빈 값 또는 샘플 값
- **파일 형식**: YAML / JSON / env 포맷. `.md` 보다 기계 읽기 쉬운 형식 권장

## Git Commit 시 자동 검사 (pre-commit hook)

스킬이 `.kb/hooks/pre-commit-secrets.sh` 를 생성하고 `.git/hooks/pre-commit` 으로 연결한다. 상세: references/template-pre-commit-hook.md

### 차단 패턴 (요약)

| 카테고리 | 패턴 |
|----------|------|
| AWS | `AKIA[0-9A-Z]{16}` |
| GitHub | `ghp_` / `gho_` / `ghs_` / `ghu_` / `github_pat_` |
| Private Key | `-----BEGIN ... PRIVATE KEY-----` |
| JWT | `eyJ...\.eyJ...\.[A-Za-z0-9_-]+` |
| Basic Auth URL | `https?://[^/]+:[^/]+@` |
| 내부 IP (RFC1918) 가 포함된 URL | `https?://(10\.` / `172\.(1[6-9]\|2[0-9]\|3[01])\.` / `192\.168\.)...` |
| 일반 자격증명 할당문 | `(password\|passwd\|secret\|token\|api_?key)\s*[:=]\s*['"]?[A-Za-z0-9_\-]{8,}` |

### False Positive 우회

문서에 의도적으로 예시 값이 포함되어야 할 때 (예: 형식 설명) 같은 줄에 pragma 추가:

```markdown
예시 토큰 형식: `ghp_AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIII` <!-- kb-secrets: allow -->
```

Hook 은 `kb-secrets: allow` 가 같은 줄에 있으면 해당 매치 건너뜀.

## AI 의 행동 규칙

1. 새 지식 생성 시 본문 내용을 스캔. 위 "금지 대상" 패턴이 감지되면 **저장 전 중단**
2. 사용자에게 3가지 허용 방법 중 하나 선택 제안
3. 기존 지식 수정 중 민감 정보가 추가될 뻔하면 즉시 경고
4. `.kb/local/` 의 파일을 읽을 수는 있으나, 그 내용을 다른 `.md` 에 **복사하지 않는다**

## Retrofit — 기존 지식베이스에 민감 정보가 있는 경우

kb-validator 가 감지하면 다음 메시지:

```
[SECRET DETECTED] {path}:{line}
  {matched-snippet}

이미 커밋되었을 수 있습니다. 다음 중 선택:
  1) 이 파일에서만 제거 — 이후 .kb/local/ 로 이동 권고
  2) Pragma 추가 — "<!-- kb-secrets: allow -->" (false positive 라면)
  3) 전체 git 히스토리 정리 필요 — git-filter-repo / BFG 수동 실행 안내

검증은 ERROR 로 차단됩니다. 해결 전까지 kb-validator 가 정지합니다.
```

**이미 커밋된 민감 정보는 삭제만으로 해결되지 않음**. git 히스토리 정리 + 자격증명 즉시 rotation 이 필요함을 안내.

## `.gitignore` 규칙

스킬은 `.gitignore` 에 다음 라인을 추가한다 (멱등):

```
# kb-validator: local-only secrets (never commit)
.kb/local/
.kb/.tag-index
```

`.kb/local.example/` 는 커밋 대상 (gitignore 하지 않음).
