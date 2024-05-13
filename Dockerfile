# Use the official Python 3.11 nightly build as a base image
FROM python:3.11.0a6-buster

# Set environment variables
ENV MODEL_CLOUD="https://drive.google.com/uc?export=download&id=1V24-vhxGFixcUp8sVpOAVSUsYmxJFMWF"
ENV TOKENIZER_CLOUD="https://drive.google.com/uc?export=download&id=1LYSJ6RgO4xQCNvwnm3sKN6m2NmzUp2jO"
# Set the working directory in the container
WORKDIR /root/

# Copy the poetry files into the container at /src
COPY pyproject.toml poetry.lock ./

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Install project dependencies using Poetry
RUN poetry install --no-root --no-interaction --no-ansi

EXPOSE 8000

# Command to run the Flask application
ENTRYPOINT [ "python" ]
CMD ["src/app.py"]
