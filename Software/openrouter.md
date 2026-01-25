* Traffic to OpenRouter is blocked in Mainland China.
* OpenRouter is a proxy of many other API backend so you don't need use api of other sites like openai or anthropic or google to access LLMs.
```py
import requests
import time

API_KEY = "sk-or-v1-xxxxxxxx"
 
resp = requests.post(
    "https://openrouter.ai/api/v1/chat/completions",
    headers={   "Authorization": f"Bearer {API_KEY}",
                "Content-Type": "application/json",
                "HTTP-Referer": "https://your-project.example",
                "X-Title": "openrouter-rate-limit-test"
    },
    json={  "model": "tngtech/tng-r1t-chimera:free",
            "messages": [ {"role": "user", "content": "tell me a joke please"} ],
            "max_tokens": 50,
    },
    timeout=30,
)

if resp.status_code == 200:
    data = resp.json()
    print("\n--- Model output ---")
    print(data["choices"][0]["message"]) 
```