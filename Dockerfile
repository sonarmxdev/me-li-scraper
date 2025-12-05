# Usamos una imagen base de Node robusta
FROM node:18-slim

# Instalamos las dependencias necesarias para correr Chrome/Chromium
# Esto incluye librerías gráficas, fuentes y herramientas básicas
RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg \
    && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Definimos el directorio de trabajo
WORKDIR /app

# Copiamos los archivos de dependencias primero para aprovechar el caché de Docker
COPY package*.json ./

# Instalamos las dependencias de Node
# Puppeteer descargará su propia versión de Chromium compatible
RUN npm install

# Copiamos el resto del código fuente (incluyendo escuchar.js)
COPY . .

# Exponemos el puerto que usa tu app
EXPOSE 3000

# Comando para iniciar la aplicación
CMD [ "node", "escuchar.js" ]