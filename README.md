
# S2I Rust

#### Create the builder image
The following command will create a builder image named s2i-rust based on the Dockerfile that was created previously.
```
docker build -t s2i-rust .
```
The builder image can also be created by using the *make* command since a *Makefile* is included.

Once the image has finished building, the command *s2i usage s2i-rust* will print out the help info that was defined in the *usage* script.

#### Testing the builder image
The builder image can be tested using the following commands:
```
docker build -t s2i-rust-candidate .
IMAGE_NAME=s2i-rust-candidate test/run
```
The builder image can also be tested by using the *make test* command since a *Makefile* is included.

#### Creating the application image
The application image combines the builder image with your applications source code, which is served using whatever application is installed via the *Dockerfile*, compiled using the *assemble* script, and run using the *run* script.
The following command will create the application image:
```
s2i build test/test-app s2i-rust s2i-rust-app
---> Building and installing application from source...
```
Using the logic defined in the *assemble* script, s2i will now create an application image using the builder image as a base and including the source code from the test/test-app directory.

#### Running the application image
Running the application image is as simple as invoking the docker run command:
```
docker run -d -p 8000:8000 s2i-rust-app
```
The application, which consists of a simple static web page, should now be accessible at  [http://localhost:8000](http://localhost:8000).
