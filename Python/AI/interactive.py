#!/opt/homebrew/bin/python3

import openai

client = openai.OpenAI(
    base_url="http://localhost:8000/v1",
    api_key="token-not-needed"
)

response = client.chat.completions.create(
    model="empero-ai/Qwythos-9B-Claude-Mythos-5-1M",
    messages=[{"role": "user", "content": "What are the core capabilities of an agentic model?"}],
    max_tokens=200
)

print(response.choices[0].message.content)