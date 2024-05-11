# Use the official Python 3.11 nightly build as a base image
FROM python:3.11.0a6-buster

# Set environment variables
ENV MODEL_CLOUD="https://drive.google.com/uc?export=download&id=11GAfuaJqxezEJraNPZgu8wwfsCOfCQUe"

# Set the working directory in the container
WORKDIR /src

# Copy the poetry files into the container at /src
COPY pyproject.toml poetry.lock ./

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Install project dependencies using Poetry
RUN poetry install --no-root --no-interaction --no-ansi

# Copy the rest of the project files into the container at /src
COPY . .

# Command to run the Flask application
CMD ["python", "app.py"]
