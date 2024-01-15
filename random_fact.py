from fastapi import FastAPI
import random
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Your 100 facts stored in a list

def load_facts():
    facts = []
    try:
        with open("raw_facts.md", "r") as file:
            lines = file.readlines()
            for line in lines[2:]:  # Skip the header rows
                split_line = line.split('|')  # Split the line on the pipe character
                print(f'length of splitline is: {len(split_line)}')
                print(f'split_line is: {split_line}')
                if len(split_line) == 4:
                    fact = split_line[2].strip()  # Extract the fact
                    print(f'Fact: {fact}')
                    facts.append(fact)
    except FileNotFoundError:
        print("Error: raw_facts.md file not found.")
    except Exception as e:
        print(f"An error occurred: {e}")
    print(facts)
    return facts
    
def fact():
    return random.choice(facts)

facts = load_facts()
print(facts)

@app.get("/random-fact")
async def random_fact():
    return {"fact": fact()}

if __name__ == "__main__":
    import uvicorn
    facts = load_facts()
    uvicorn.run(app, host="127.0.0.1", port=8000)