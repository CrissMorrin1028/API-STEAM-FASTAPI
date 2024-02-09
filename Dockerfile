FROM python:3-alpine AS builder
 
WORKDIR /app
 
RUN apk add --no-cache gcc musl-dev python3-dev libffi-dev openssl-dev cargo 
RUN python3 -m venv venv
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
 
COPY requirements.txt .
RUN pip install -r requirements.txt
 
# Stage 2
FROM python:3-alpine AS runner
 
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