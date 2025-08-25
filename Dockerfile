FROM python:3.8-slim

WORKDIR /project

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./

RUN pip install --upgrade pip

RUN  pip install -r requirements.txt

RUN pip install --no-cache-dir -r requirements.txt     

RUN apt-get update && apt-get install -y unzip curl    

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

RUN  pip install django==3.2

COPY . .

EXPOSE 8001
                                                       
CMD ["python","manage.py","runserver","0.0.0.0:8001"]  
