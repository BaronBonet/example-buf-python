import grpc
from hello.v1 import hello_pb2
from hello.v1 import hello_pb2_grpc


def run():
    with grpc.insecure_channel('localhost:50051') as channel:
        stub = hello_pb2_grpc.GreeterStub(channel)
        response = stub.SayHello(hello_pb2.HelloRequest(name='you'))
        print("Greeter client received: " + response.message)
        response = stub.SayHelloAgain(hello_pb2.HelloRequest(name='you'))
        print("Greeter client received: " + response.message)


if __name__ == "__main__":
    run()