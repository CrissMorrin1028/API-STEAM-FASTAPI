FROM python:3-slim-buster AS builder
 
WORKDIR /app
 
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libffi-dev \
    libssl-dev \
    cargo \
    && rm -rf /var/lib/apt/lists/*
    
RUN python3 -m venv venv
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Ensure pip is installed in the virtual environment
RUN python3 -m ensurepip

# Actualizar pip antes de instalar las dependencias del proyecto
RUN pip install --upgrade pip

# Instalar wheel antes de las demás dependencias
RUN pip install wheel

 
COPY requirements.txt .

RUN pip install --no-cache-dir --use-pep517 -r requirements.txt
# RUN pip install --use-pep517 -r requirements.txt

 
# Stage 2
FROM python:3-slim-buster AS runner
 
WORKDIR /app
 
COPY --from=builder /app/venv venv
COPY main.py main.py
COPY funciones.py funciones.py
COPY user_item_model.pkl user_item_model.pkl
COPY item_similarity.pkl item_similarity.pkl
COPY games_items.parquet games_items.parquet
COPY games_reviews.parquet games_reviews.parquet
COPY games.parquet games.parquet
COPY item_item.parquet item_item.parquet
COPY user_item_model.parquet user_item_model.parquet
 
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
 
EXPOSE 8000
 
CMD [ "uvicorn", "--host", "0.0.0.0", "main:app" ]