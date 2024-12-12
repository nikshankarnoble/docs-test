# ==============================================================================
# Multi Stage: Dev Image
# ==============================================================================

FROM python:3.11.10 AS dev

# Arguments associated with the non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Set environment variables
ENV POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_HOME=/home/${USERNAME}/poetry \
    PYTHONUNBUFFERED=1

# Add poetry executable to PATH
ENV PATH="$POETRY_HOME/bin:$PATH"

# Add the non-root user
RUN groupadd --gid "${USER_GID}" "${USERNAME}" \
    && useradd --uid "${USER_UID}" --gid "${USER_GID}" -m "${USERNAME}"


# Switch to the non-root user to install applications on the user level
USER ${USERNAME}

# Explicitly populate home directory variable
ENV HOME=/home/${USERNAME}

# Install poetry
RUN mkdir -p ${HOME}/poetry && \
    curl --proto "=https" -sSL https://install.python-poetry.org | python3 - && \
    poetry self add poetry-plugin-up

# Verify Poetry installation
RUN poetry --version



# ==============================================================================
# Multi Stage: Bake Image
# ==============================================================================

FROM python:3.11.10 AS bake

# Arguments associated with the non-root user
ARG USERNAME=zeus-svc
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Set environment variables
ENV POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_HOME=/home/${USERNAME}/poetry \
    PYTHONUNBUFFERED=1

# Add poetry executable to PATH
ENV PATH="$POETRY_HOME/bin:$PATH"

# Set working directory
WORKDIR /app

# Add the non-root user
RUN groupadd --gid "$USER_GID" "$USERNAME" \
    && useradd --uid "$USER_UID" --gid "$USER_GID" -m "$USERNAME"

# Make working directory
RUN mkdir -p /app && chown ${USER_UID}:${USER_GID} /app

# Switch to the non-root user to install applications on the user level
USER ${USERNAME}

# Explicitly populate home directory variable
ENV HOME=/home/${USERNAME}

# Install poetry
RUN mkdir -p /home/${USERNAME}/poetry && \
    curl --proto "=https" -sSL https://install.python-poetry.org | python3 - && \
    poetry self add poetry-plugin-up

# Verify Poetry installation
RUN poetry --version

# Copy source code and python dependency specification
COPY pyproject.toml poetry.lock README.md /app/
COPY src /app/src

# Install python runtime dependencies in container
RUN poetry install --without dev



# ==============================================================================
# Multi Stage: Runtime Image
# ==============================================================================

FROM python:3.11.10 AS runtime

# Create the service user.
ARG USERNAME=zeus-svc
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid "$USER_GID" "$USERNAME" \
    && useradd --uid "$USER_UID" --gid "$USER_GID" -m "$USERNAME"

# Copy over baked environment
# Explicitly copy the possibly ignored .venv folder
COPY --chown=root:root --chmod=755 --from=bake /app /app
COPY --chown=root:root --chmod=755 --from=bake /app/.venv /app/.venv

# Copy over baked environment
# Explicitly copy the possibly ignored .venv folder
COPY --chown=root:root --chmod=755 --from=bake /home /home

# Switch to the service user.
USER ${USERNAME}

# Set working directory
WORKDIR /app

# Set executables in PATH
ENV PATH="/app/.venv/bin:$PATH"

# Expose the service port
EXPOSE 5051

# Auto start the fastapi service on start-up
ENTRYPOINT ["fastapi", "run", "/app/src/zeus/app.py", "--port", "5051"]