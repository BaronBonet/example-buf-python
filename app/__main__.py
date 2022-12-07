from concurrent import futures

import grpc

from hello.v1 import hello_pb2_grpc
from hello.v1 import hello_pb2


class Greeter(hello_pb2_grpc.GreeterServicer):

    def SayHello(self, request, context):
        return hello_pb2.HelloReply(message='Hello, %s!' % request.name)

    def SayHelloAgain(self, request, context):
        return hello_pb2.HelloReply(message='Hello again, %s!' % request.name)


def serve():
    port = '50051'
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    hello_pb2_grpc.add_GreeterServicer_to_server(Greeter(), server)
    server.add_insecure_port('[::]:' + port)
    server.start()
    print("Server started, listening on " + port)
    print("Success!")
    server.wait_for_termination()


if __name__ == '__main__':
    serve()
