import sys
import thrift
sys.path.append('gen-py')
import messages
from messages.ttypes import *
from thrift.protocol import TBinaryProtocol
from thrift.transport import TTransport
from thrift.transport import TSocket

def main():
  trans = TTransport.TBufferedTransport(TSocket.TSocket('localhost', 9092))
  proto = TBinaryProtocol.TBinaryProtocol(trans)
  proto.trans.open()
  req = request(coeffs={0: 42.0, 2: 13.0}, point=7.0)
  req.write(proto)
  proto.trans.flush()
  res = response()
  res.read(proto)
  proto.trans.close()
  print(str(res))

main()
