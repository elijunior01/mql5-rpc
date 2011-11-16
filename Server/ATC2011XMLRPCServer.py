from SimpleXMLRPCServer import SimpleXMLRPCServer
from SimpleXMLRPCServer import SimpleXMLRPCRequestHandler

from PositionGrabberTest import ContestantParser, ContestantsFinder

class RequestHandler( SimpleXMLRPCRequestHandler ):
    rpc_path = ( '/RPC2', )
    

class ATC2011XMLRPCServer(SimpleXMLRPCServer):

    def __init__(self):
        SimpleXMLRPCServer.__init__( self, ("192.168.235.168", 6666), requestHandler=RequestHandler, logRequests = False)
        
        self.register_introspection_functions()
        self.register_function( self.xmlrpc_contestants, "listContestants" )        
        self.register_function( self.xmlrpc_get_position_stats, "getStats" )        
        
    
    def xmlrpc_contestants(self, min_equity):
        try:
            min_equity = float(min_equity)
        except ValueError as error:
            print error
            return []
    
        self.contestants = ContestantsFinder(min_equity)
        
        return self.contestants.list()
    
    def xmlrpc_get_position_stats(self, pair):
        total_users = len(self.contestants.list())
        holding_pair = 0
        buy_positions = 0
        
        for username in self.contestants.list():
            u = ContestantParser(username)
            position = u.position(pair)
            if position != "none":
                holding_pair += 1
                if position == "buy":
                    buy_positions += 1
        
        return [ total_users, holding_pair, buy_positions ]            
    

if __name__ == '__main__':
    server = ATC2011XMLRPCServer() 
    server.serve_forever()        
