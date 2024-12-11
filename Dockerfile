# Usar la imagen base de .NET
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Usar la imagen para construir el proyecto
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Proyect/Proyect.csproj", "Proyect/"]
RUN dotnet restore "Proyect/Proyect.csproj"
COPY . .
WORKDIR "/src/Proyect"
RUN dotnet build "Proyect.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Proyect.csproj" -c Release -o /app/publish

# Configurar el entorno de ejecución
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Proyect.dll"]
