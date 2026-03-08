# bbaktaeho-agent-skills

개인적으로 사용하는 Claude Code Agent Skills 모음.

## Installation

### 1. Marketplace 등록

```shell
claude plugin marketplace add bbaktaeho/bbaktaeho-agent-skills
```

### 2. Skill 설치

각 skill의 상세 내용은 [plugins/](./plugins) 디렉토리에서 확인할 수 있다.

```shell
claude plugin install golang-best-practices@bbaktaeho-agent-skills
claude plugin install postgres-best-practices@bbaktaeho-agent-skills
claude plugin install elasticsearch-best-practices@bbaktaeho-agent-skills
claude plugin install agent-instructions-setup@bbaktaeho-agent-skills
...
```

### 3. 확인

```shell
claude plugin list
```

## Update

### Marketplace 갱신

```shell
claude plugin marketplace update bbaktaeho-agent-skills
```

### Plugin 업데이트

```shell
claude plugin update golang-best-practices@bbaktaeho-agent-skills
claude plugin update postgres-best-practices@bbaktaeho-agent-skills
claude plugin update elasticsearch-best-practices@bbaktaeho-agent-skills
claude plugin update agent-instructions-setup@bbaktaeho-agent-skills
```

업데이트가 반영되지 않는 경우 marketplace를 제거 후 재등록한다.

```shell
claude plugin marketplace remove bbaktaeho-agent-skills
claude plugin marketplace add bbaktaeho/bbaktaeho-agent-skills
```

## Usage

설치 후 별도 명령 없이 자동으로 동작한다. Claude Code가 대화 컨텍스트를 분석하여 관련 skill을 자동 트리거한다.

## License

MIT
