FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS sdk

WORKDIR /app

COPY . .

RUN cd pmcenter \
    && dotnet restore \
    && dotnet publish -c Release -o ../build

FROM mcr.microsoft.com/dotnet/core/runtime:3.1-alpine AS runtime
ARG LOCALE=en
WORKDIR /app

COPY --from=sdk /app/build ./
COPY --from=sdk /app/locales/pmcenter_locale_$LOCALE.json ./pmcenter_locale.json

CMD ["dotnet", "pmcenter.dll"]
