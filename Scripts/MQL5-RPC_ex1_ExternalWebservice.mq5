//+------------------------------------------------------------------+
//|                              MQL5-RPC_ex1_ExternalWebService.mq5 |
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
   
   /* web service test */
   CArrayObj* params = new CArrayObj;
   
   CArrayString* from   = new CArrayString;
   CArrayString* to     = new CArrayString;
   CArrayDouble* amount = new CArrayDouble;
   
   from.Add("GBP"); to.Add("USD"); amount.Add(10000.0);
   params.Add(from); params.Add(to); params.Add(amount);
   
   CXMLRPCQuery query("foxrate.currencyConvert", params);
   
   Print(query.toString());
   
   CXMLRPCServerProxy s("foxrate.org/rpc");
   CXMLRPCResult* result;
   
   result = s.execute(query);
   
   result.parseXMLResponseRAW();
   Print(result.toString());
   
   
   delete params;
   delete result;

  }
//+------------------------------------------------------------------+
