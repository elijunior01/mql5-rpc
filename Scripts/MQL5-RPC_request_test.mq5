//+------------------------------------------------------------------+
//|                                          MQL5-RPC_query_test.mq5 |
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
   /* query test */
   CArrayObj* params = new CArrayObj;
   
   CArrayDouble*   param1 = new CArrayDouble;
   CArrayInt*      param2 = new CArrayInt;
   CArrayString*   param3 = new CArrayString;
   CArrayBool*     param4 = new CArrayBool;
   CArrayDatetime* param5 = new CArrayDatetime;
   CArrayMqlRates* param6 = new CArrayMqlRates;
   
   for (int i=0; i<4; i++)
      param1.Add(20000.0 + i*100.0);
   
   params.Add(param1);
   
   for (int i=0; i<4; i++)
      param2.Add(i);
      
   params.Add(param2);
   
   param3.Add("first_string");
   param3.Add("second_string");
   param3.Add("third_string");
   
   params.Add(param3);
   
   param4.Add(false);
   param4.Add(true);
   param4.Add(false);
   
   params.Add(param4);
   
   param5.Add(TimeCurrent());
   params.Add(param5);
   
   const int nRates = 3;
   MqlRates rates[3];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(Symbol(),0,0,nRates,rates);
   if (copied==nRates) {
      param6.AddArray(rates);
      params.Add(param6);
   }
    
    
   CXMLRPCQuery query("sampleMethodname", params);
   
   Print(query.toString());
   

   delete params;
  }
//+------------------------------------------------------------------+
