To run, put dump.rdb into a data/redis folder and build the image:

     docker build -t community .

Then, to run the nodebb, do this:

     docker run -d -P --name community -p 4567:4567 -p 6379:6379 -v /your/path/to/data:/data community

You can then access your running nodebb on 127.0.0.1:4567 and access redis on 127.0.0.1:6379 without password.

To open a shell on a running container:

     docker exec -it community bash
