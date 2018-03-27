## Build stage
FROM microsoft/aspnetcore-build AS builder

# Set the working directory to the app directory
WORKDIR /source

# caches restore result by copying csproj file separately
COPY *.csproj .
RUN dotnet restore

# copies the rest of your code
COPY . .
RUN dotnet publish --output /app/ --configuration Release

# build runtime image
FROM microsoft/aspnetcore
WORKDIR /app
COPY --from=builder /app .
EXPOSE 8080

# Define environment variables
# Application Insights
ENV APPINSIGHTS_KEY=b66fcd0f-fb26-4828-882d-a8149ed8d824
ENV CHALLENGEAPPINSIGHTS_KEY=23c6b1ec-ca92-4083-86b6-eba851af9032

# Challenge Logging
ENV TEAMNAME=ContainersOnFire

# AMQP
ENV AMQPURL=amqp://defaultrabbit-rabbitmq-ha:5672

# Mongo/Cosmos
ENV MONGOURL=mongodb://defaultmongo-mongodb


ENTRYPOINT ["dotnet", "captureorderack.dll"]
