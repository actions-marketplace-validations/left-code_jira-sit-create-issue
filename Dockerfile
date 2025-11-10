# Set the base image to use for subsequent instructions
FROM mcr.microsoft.com/powershell

# Set the working directory inside the container
WORKDIR /usr/src

# Copy any source file(s) required for the action
COPY entrypoint.ps1 .

# Configure the container to be run as an executable
ENTRYPOINT ["pwsh", "/usr/src/entrypoint.ps1"]