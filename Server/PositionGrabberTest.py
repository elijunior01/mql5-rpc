import re
import urllib
from BeautifulSoup import BeautifulSoup

class ContestantParser(object):
    URL_PREFIX = 'http://championship.mql5.com/2011/en/users/'
    
    def __init__(self, name):
        print "User:", name
        url = ContestantParser.URL_PREFIX + name
        feed = urllib.urlopen(url)
        s = BeautifulSoup(feed.read())
        account = s.findAll('td', attrs={'class' : 'alignRight'})
        self.balance = float(account[0].contents[0].replace(' ', ''))
        self.equity = float(account[2].contents[0].replace(' ', ''))
        terminals = s.findAll('table', attrs={'class': 'terminal'})
        terminal = terminals[0]
        trs = terminal.findAll('tr')
        pairs = terminal.findAll('span', attrs={'class':'stateText'})
        self.stats = {}
        for i in range(len(pairs)-1):
            if len(pairs[i].string)> 6:
                break
            self.stats[str(pairs[i].string)] = str(trs[i+1].contents[7].string)

    def __str__(self):
        for k in self.stats.keys():
            print k, self.stats[k] 
        
        return "Bal " + str(self.balance) + " Equ " +  str(self.equity)
    
    def position(self, pair):
        if pair in self.stats.keys():
            return self.stats[pair]
        else:
            return "none"
        
class ContestantsFinder(object):
    URL_PREFIX = "http://championship.mql5.com/2011/en/users/index/page"
    URL_SUFFIX = "?orderby=equity&dir=down"
    
    def __init__(self, min_equity):
        self.min_equity = min_equity        
        self.user_list = []
        self.__find()
        
    def __find(self):
        isLastPage = False
        pageCnt = 1
        while isLastPage == False:
            url = ContestantsFinder.URL_PREFIX + str(pageCnt) + \
                  ContestantsFinder.URL_SUFFIX
            feed = urllib.urlopen(url)
            s = BeautifulSoup(feed.read())
            urows = s.findAll('tr', attrs={'class' : re.compile('row.*')})
            for row in urows:
                user_name = row.contents[5].a.string
                equity = float(row.contents[19].string.replace(' ',''))
                if equity <= self.min_equity:
                    isLastPage = True
                    break
                self.user_list.append(str(user_name))
                print user_name, equity
            pageCnt += 1
    
        
    def list(self):
        return self.user_list
    
    
 
if __name__ == "__main__":
        
    # find all contestants with equity larger than initial
    contestants = ContestantsFinder(20000.0)
    print contestants.list()
    # display statistics
    print "* Statistics *"
    for contestant in contestants.list():
        u = ContestantParser(contestant)    
        print u
        print u.position('eurusd')
        print '-' * 60
    