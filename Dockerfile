# ==========================================
# Etapa 1: Compilación (Node.js)
# ==========================================
FROM node:22-alpine AS builder

WORKDIR /app

# Copiar archivos de dependencias para aprovechar la caché de Docker
COPY package*.json ./

# Instalar dependencias limpias
RUN npm ci

# Copiar el código fuente completo
COPY . .

# Compilar el proyecto Astro (genera la carpeta dist/)
RUN npm run build

# ==========================================
# Etapa 2: Servidor Web Ultraligero (Nginx Alpine)
# ==========================================
FROM nginx:alpine AS runner

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar los archivos compilados desde la etapa builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponer el puerto HTTP estándar
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
