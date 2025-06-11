# Use an official Python runtime as a parent image
# Updated to 3.13 on 11 Jun 2025
FROM python:3.13-slim 

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file into the container at /app
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application's code
COPY . /app

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Run app.py when the container launches
CMD ["uvicorn", "random_fact:app", "--host", "0.0.0.0", "--port", "8000"]
