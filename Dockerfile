FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY AzureFrameworkSample/*.csproj ./AzureFrameworkSample/
COPY AzureFrameworkSample/*.config ./AzureFrameworkSample/
RUN nuget restore

# copy everything else and build app
COPY AzureFrameworkSample/. ./AzureFrameworkSample/
WORKDIR /app/AzureFrameworkSample
RUN msbuild /p:Configuration=Release


FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/AzureFrameworkSample/. ./
