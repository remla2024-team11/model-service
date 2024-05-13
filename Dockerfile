
FROM python:3.11-bookworm as python-base

# https://python-poetry.org/docs#ci-recommendations
ENV POETRY_VERSION=1.4.1
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv


# Set environment variables
ENV MODEL_CLOUD="https://drive.google.com/uc?export=download&id=1V24-vhxGFixcUp8sVpOAVSUsYmxJFMWF"
ENV TOKENIZER_CLOUD="https://drive.google.com/uc?export=download&id=1LYSJ6RgO4xQCNvwnm3sKN6m2NmzUp2jO"
# Set the working directory in the container
WORKDIR /root/

# Tell Poetry where to place its cache and virtual environment
ENV POETRY_CACHE_DIR=/opt/.cache

# Create stage for Poetry installation
FROM python-base as poetry-base

# Creating a virtual environment just for poetry and install it with pip
RUN python3 -m venv $POETRY_VENV \
    && $POETRY_VENV/bin/pip install -U pip setuptools \
    && $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}

# Create a new stage from the base python image
FROM python-base as example-app

# Copy Poetry to app image
COPY --from=poetry-base ${POETRY_VENV} ${POETRY_VENV}

# Add Poetry to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"

WORKDIR /app

# Copy Dependencies
COPY poetry.lock pyproject.toml ./

# Install Dependencies
RUN poetry install --no-interaction --no-cache --no-dev

# Copy Application
COPY src /app

# Run Application
CMD [ "poetry", "run", "python", "-m", "flask", "run", "--host=0.0.0.0", "--port=82" ]