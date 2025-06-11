from fastapi import FastAPI
import random
from fastapi.middleware.cors import CORSMiddleware
import sqlite3
import os

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

def get_random_fact():
    conn = sqlite3.connect('facts.db')
    cursor = conn.cursor()
    cursor.execute("SELECT COUNT(*) FROM facts")
    count = cursor.fetchone()[0]
    random_id = random.randint(1, count)
    cursor.execute("SELECT fact FROM facts WHERE id = ?", (random_id,))
    fact = cursor.fetchone()
    conn.close()
    return fact[0] if fact else "No fact found."

def initialize_db():
    conn = sqlite3.connect('facts.db')
    conn.execute('''CREATE TABLE IF NOT EXISTS facts
                    (id INTEGER PRIMARY KEY,
                     fact TEXT NOT NULL);''')
    conn.commit()
    conn.close()

def load_facts_into_db():
    initialize_db()  # Ensure the database and table are set up

    # Connect to the database
    conn = sqlite3.connect('facts.db')
    cursor = conn.cursor()

    # Clear existing data
    cursor.execute("DELETE FROM facts")

    try:
        with open("raw_facts.md", "r") as file:
            lines = file.readlines()
            for line in lines[2:]:  # Skip the header rows
                split_line = line.split('|')  # Split the line on the pipe character
                if len(split_line) == 4:
                    fact = split_line[2].strip()  # Extract the fact
                    cursor.execute("INSERT INTO facts (fact) VALUES (?)", (fact,))
    except FileNotFoundError:
        print("Error: raw_facts.md file not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

    # Commit changes and close the connection
    conn.commit()
    conn.close()

load_facts_into_db()

@app.get("/random-fact")
async def random_fact():
    return {"fact": get_random_fact()}

if __name__ == "__main__":
    import uvicorn
    # facts = load_facts()
    print('loading facts')
    load_facts_into_db()
    uvicorn.run(app, host="127.0.0.1", port=8000)