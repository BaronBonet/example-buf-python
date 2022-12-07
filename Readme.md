# gRPC Python Example

Example taken from the [gRPC quick start](https://grpc.io/docs/languages/python/quickstart/#install-grpc-tools) using [buf](https://docs.buf.build/installation) to generate .py files.

To test locally be sure to set up a virtual environment and install dependencies with poetry. 

Also install buf

```bash
brew install bufbuild/buf/buf
```

and generate the code with

```bash
buf generate
```


## Issues

Currently, in python, there doesn't seem to be a way for the generated files to be generated in a single directory (e.g. `generated`). Therefor we have to generate each of the generated modules in the project root. See [this issue](https://github.com/protocolbuffers/protobuf/issues/1491) for more details. 
