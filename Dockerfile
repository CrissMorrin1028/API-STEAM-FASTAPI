FROM tiangolo/uvicorn-gunicorn-fastapi:python3.11
 
WORKDIR /app

# Copiar requirements.txt al directorio /app
COPY requirements.txt /app/requirements.txt

# Instalar las dependencias
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY main.py main.py
COPY funciones.py funciones.py
COPY user_item_model.pkl user_item_model.pkl
COPY item_similarity.pkl item_similarity.pkl
COPY games_items.parquet games_items.parquet
COPY games_reviews.parquet games_reviews.parquet
COPY games.parquet games.parquet
COPY item_item.parquet item_item.parquet
COPY user_item_model.parquet user_item_model.parquet
 
EXPOSE 8000
 
CMD [ "uvicorn", "--host", "0.0.0.0", "main:app" ]