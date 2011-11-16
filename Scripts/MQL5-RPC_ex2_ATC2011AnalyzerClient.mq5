//+------------------------------------------------------------------+
//|                           MQL5-RPC_ex2_ATC2011AnalyzerClient.mq5 |
//|                                      Copyright 2011, Investeo.pl |
//|                                           http://www.investeo.pl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, Investeo.pl"
#property link      "http://www.investeo.pl"
#property version   "1.00"

#include <MQL5-RPC.mqh>
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayInt.mqh>
#include <Arrays\ArrayDouble.mqh>
#include <Arrays\ArrayString.mqh>
#include <Arrays\ArrayBool.mqh>
#include <Arrays\ArrayDatetime.mqh>
#include <Arrays\ArrayMqlRates.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   
   /* ATC 2011 analyzer test */
   CXMLRPCServerProxy s("192.168.235.168:6666");
   CXMLRPCResult* result;
   
   /* Get list of contestants */
   CArrayObj* params1 = new CArrayObj;
   CArrayDouble* amount = new CArrayDouble;
   
   amount.Add(20000.0); params1.Add(amount);
   CXMLRPCQuery query("listContestants", params1);
   
   Print(query.toString());
   
   result = s.execute(query);
   Print(result.toString());
   delete result;

   /* Get position statistics */
   CArrayObj* params2 = new CArrayObj;
   CArrayString* pair = new CArrayString;
   
   pair.Add("eurusd"); params2.Add(pair);
   CXMLRPCQuery query2("getStats", params2);
   
   Print(query2.toString());
   
   result = s.execute(query2);
   
   CArrayObj* resultArray = result.getResults();
   CArrayInt* stats = resultArray.At(0);
   
   Print("Contestants = " + IntegerToString(stats.At(0)) + 
         ". EURUSD positions = " + IntegerToString(stats.At(1)) +
         ". BUY positions = " + IntegerToString(stats.At(2)));
         
         
   delete params1;
   delete params2;
   
   delete result;

  }
//+------------------------------------------------------------------+
