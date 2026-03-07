---
title: Table-Driven Tests, Subtests, and Example Functions
impact: CRITICAL
impactDescription: Table-driven tests are the standard Go testing pattern enabling comprehensive coverage with minimal code
tags: table-driven, subtests, parallel, t-run, example, testable-example
---

## Table-Driven Tests

```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive numbers", 2, 3, 5},
        {"negative numbers", -1, -2, -3},
        {"zero values", 0, 0, 0},
        {"mixed signs", -1, 1, 0},
        {"large numbers", 1000000, 2000000, 3000000},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := Add(tt.a, tt.b)
            if got != tt.expected {
                t.Errorf("Add(%d, %d) = %d; want %d",
                    tt.a, tt.b, got, tt.expected)
            }
        })
    }
}
```

## Table-Driven Tests with Error Cases

```go
func TestParseConfig(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        want    *Config
        wantErr bool
    }{
        {
            name:  "valid config",
            input: `{"host": "localhost", "port": 8080}`,
            want:  &Config{Host: "localhost", Port: 8080},
        },
        {
            name:    "invalid JSON",
            input:   `{invalid}`,
            wantErr: true,
        },
        {
            name:    "empty input",
            input:   "",
            wantErr: true,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := ParseConfig(tt.input)

            if tt.wantErr {
                if err == nil {
                    t.Error("expected error, got nil")
                }
                return
            }

            if err != nil {
                t.Fatalf("unexpected error: %v", err)
            }

            if !reflect.DeepEqual(got, tt.want) {
                t.Errorf("got %+v; want %+v", got, tt.want)
            }
        })
    }
}
```

## Organizing Related Subtests

```go
func TestUser(t *testing.T) {
    db := setupTestDB(t)

    t.Run("Create", func(t *testing.T) {
        user := &User{Name: "Alice"}
        err := db.CreateUser(user)
        if err != nil {
            t.Fatalf("CreateUser failed: %v", err)
        }
        if user.ID == "" {
            t.Error("expected user ID to be set")
        }
    })

    t.Run("Get", func(t *testing.T) {
        user, err := db.GetUser("alice-id")
        if err != nil {
            t.Fatalf("GetUser failed: %v", err)
        }
        if user.Name != "Alice" {
            t.Errorf("got name %q; want %q", user.Name, "Alice")
        }
    })
}
```

## Parallel Subtests

```go
func TestParallel(t *testing.T) {
    tests := []struct {
        name  string
        input string
    }{
        {"case1", "input1"},
        {"case2", "input2"},
        {"case3", "input3"},
    }

    for _, tt := range tests {
        tt := tt
        t.Run(tt.name, func(t *testing.T) {
            t.Parallel()
            result := Process(tt.input)
            _ = result
        })
    }
}
```

## Example Functions (Testable Examples)

Example 함수는 실행 가능한 문서다. godoc에 표시되며 `go test`로 검증된다. public 함수를 작성할 때 Example 함수도 함께 작성한다.

### Naming Convention

```go
func Example()              // 패키지 전체 예제
func ExampleFoo()           // Foo 함수 또는 타입 예제
func ExampleBar_Qux()       // Bar 타입의 Qux 메서드 예제
func ExampleFoo_second()    // Foo의 두 번째 예제 (소문자 suffix)
```

### Basic Example

```go
func ExampleAdd() {
    result := Add(2, 3)
    fmt.Println(result)
    // Output: 5
}
```

- `// Output:` 주석으로 기대 출력을 명시한다
- `go test` 실행 시 실제 출력과 비교하여 검증한다
- Output 주석이 없으면 컴파일만 되고 실행 검증은 하지 않는다

### Unordered Output

```go
func ExampleMap() {
    m := map[string]int{"a": 1, "b": 2}
    for k, v := range m {
        fmt.Printf("%s: %d\n", k, v)
    }
    // Unordered output:
    // a: 1
    // b: 2
}
```

- map 순회 등 출력 순서가 보장되지 않는 경우 `// Unordered output:`을 사용한다

### Method Example

```go
func ExampleReader_Read() {
    r := strings.NewReader("hello")
    buf := make([]byte, 5)
    n, err := r.Read(buf)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("%d bytes: %s\n", n, buf[:n])
    // Output: 5 bytes: hello
}
```

### When to Write Examples

- 모든 exported 함수/타입에 Example 함수 작성을 권장한다
- 복잡한 API의 사용법을 보여줄 때 특히 유용하다
- Example은 `_test.go` 파일에 작성한다
- 문서화와 테스트를 동시에 달성한다
