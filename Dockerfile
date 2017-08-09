# Set the working directory to /mongo
WORKDIR /mongo

# Copy the current directory contents into the container at /mongo
ADD . /mongo
