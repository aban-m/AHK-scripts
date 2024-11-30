package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"
)

type ChatRequest struct {
	Model    string       `json:"model"`
	Messages []ChatMessage `json:"messages"`
	MaxTokens int         `json:"max_tokens"`
	Temperature float64   `json:"temperature"`
}

type ChatMessage struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type ChatResponse struct {
	Choices []struct {
		Message ChatMessage `json:"message"`
	} `json:"choices"`
}
func main() {
	// Parse command line arguments
	model := flag.String("model", "", "The model name (e.g., gpt-4)")
	maxTokens := flag.Int("max_tokens", 120, "The maximum number of tokens to generate")
	temperature := flag.Float64("temperature", 0.7, "The temperature for generation")
	systemPrompt := flag.String("system_prompt", "", "The system prompt for the model")
	message := flag.String("message", "", "The user message to send")
	flag.Parse()

	if *model == "" || *message == "" {
		log.Fatalln("Error: Both --model and --message are required.")
	}

	apiKey := os.Getenv("OPENAI_API_KEY")
	if apiKey == "" {
		log.Fatalln("Error: OPENAI_API_KEY environment variable is not set.")
	}

	// Prepare the request body
	messages := []ChatMessage{
		{Role: "system", Content: *systemPrompt},
		{Role: "user", Content: *message},
	}
	chatRequest := ChatRequest{
		Model:       *model,
		Messages:    messages,
		MaxTokens:   *maxTokens,
		Temperature: *temperature,
	}

	requestBody, err := json.Marshal(chatRequest)
	if err != nil {
		log.Fatalf("Error creating request body: %v\n", err)
	}

	// Make the HTTP request
	ctx := context.Background()
	resp, err := makeRequest(ctx, apiKey, requestBody)
	if err != nil {
		log.Fatalf("Error making request: %v\n", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		log.Fatalf("Error: received status %d, body: %s\n", resp.StatusCode, string(body))
	}

	// Parse the response
	var chatResponse ChatResponse
	if err := json.NewDecoder(resp.Body).Decode(&chatResponse); err != nil {
		log.Fatalf("Error parsing response: %v\n", err)
	}

	if len(chatResponse.Choices) == 0 {
		log.Fatalln("Error: no choices in response.")
	}

	// Output the result
	fmt.Println(strings.TrimSpace(chatResponse.Choices[0].Message.Content))
}

func makeRequest(ctx context.Context, apiKey string, body []byte) (*http.Response, error) {
	req, err := http.NewRequestWithContext(ctx, "POST", "https://api.openai.com/v1/chat/completions", strings.NewReader(string(body)))
	if err != nil {
		return nil, err
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+apiKey)

	client := &http.Client{}
	return client.Do(req)
}
