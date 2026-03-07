# bbaktaeho-agent-skills

Go 언어 백엔드 개발을 위한 Agent Skills 모음.

## Installation

### 1. Marketplace 등록

```shell
claude plugin marketplace add bbaktaeho/bbaktaeho-agent-skills
```

### 2. Skill 설치

```shell
claude plugin install golang-best-practices@bbaktaeho-agent-skills
claude plugin install postgres-best-practices@bbaktaeho-agent-skills
claude plugin install elasticsearch-best-practices@bbaktaeho-agent-skills
...
```

### 3. 확인

```shell
claude plugin list
```

## Usage

설치 후 별도 명령 없이 자동으로 동작한다. Claude Code가 대화 컨텍스트를 분석하여 관련 skill을 자동 트리거한다.

## License

MIT
