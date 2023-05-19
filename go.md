# Go

## Testing
```go
// Using testify
func TestUnmarshallJsonToTimedActionStruct(t *testing.T) {
	setups := []string{
		`{"action":"jump", "time":100}`,
		`{"action":"jump", "time":9999}`,
		`{"action":"crawl", "time":-2}`,
	}
	expected := []Action{
		{Action: "jump", Time: 100},
		{Action: "jump", Time: 9999},
		{Action: "crawl", Time: -2},
	}

	for i, json := range setups {
		t.Log(json)
		result, err := unmarshallAction(json)
		require.NoError(t, err)
		assert.Equal(t, expected[i], *result)
	}
}

// Using testing module
func TestReverse(t *testing.T) {
	inputs := []int{123, -123, 120, 1000000009}
	expected := []int{321, -321, 21, 0}

	// Iterate through multiple test cases
	for i, input := range inputs {
		t.Log(input)
		got := reverse(input)
		if got != expected[i] {
			t.Errorf("reverse(%v) == %v, want %v", input, got, expected[i])
		}
	}
}
```