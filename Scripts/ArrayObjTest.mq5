//+------------------------------------------------------------------+
//|                                                 ArrayObjTest.mq5 |
//|                                      Copyright 2011, Investeo.pl |
//|                                               http://Investeo.pl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, Investeo.pl"
#property link      "http://Investeo.pl"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayInt.mqh>
#include <Arrays\ArrayDouble.mqh>
#include <Arrays\ArrayString.mqh>
#include <Arrays\ArrayBool.mqh>
#include <Arrays\ArrayMqlRates.mqh>
#include <Arrays\ArrayDatetime.mqh>

void OnStart()
  {
//---
   CArrayObj* params = new CArrayObj;
   
   CArrayInt* arrInt = new CArrayInt;
   
   arrInt.Add(1001);
   arrInt.Add(1002);
   arrInt.Add(1003);
   arrInt.Add(1004);
   
   CArrayDouble* arrDouble = new CArrayDouble;
   
   arrDouble.Add(1001.0);
   arrDouble.Add(1002.0);
   arrDouble.Add(1003.0);
   arrDouble.Add(1004.0);
      
   CArrayString* arrString = new CArrayString;
   
   arrString.Add("s1001.0");
   arrString.Add("s1002.0");
   arrString.Add("s1003.0");
   arrString.Add("s1004.0");
   
   CArrayDatetime* arrDatetime = new CArrayDatetime;
   
   arrDatetime.Add(TimeCurrent());
   arrDatetime.Add(TimeTradeServer()+3600);
   arrDatetime.Add(TimeCurrent()+3600*24);
   arrDatetime.Add(TimeTradeServer()+3600*24*7);
   
   CArrayBool* arrBool = new CArrayBool;
   
   arrBool.Add(false);
   arrBool.Add(true);
   arrBool.Add(true);
   arrBool.Add(false);
   
   CArrayMqlRates* arrRates = new CArrayMqlRates;
   
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(Symbol(),0,0,4,rates);
   
   arrRates.Add(rates[0]);
   arrRates.Add(rates[1]);
   arrRates.Add(rates[2]);
   arrRates.Add(rates[3]);
   
   params.Add(arrInt);
   params.Add(arrDouble);
   params.Add(arrString);
   params.Add(arrDatetime);
   params.Add(arrBool);
   params.Add(arrRates);
   
   Print("params has " + IntegerToString(params.Total()) + " arrays.");
 
   for (int p=0; p<params.Total(); p++)
   {
      int type = params.At(p).Type();
      
      switch (type) {
         case TYPE_INT: { 
            CArrayInt *arr = params.At(p); 
            for (int i=0; i<arr.Total(); i++)
               PrintFormat("%d %d %d", p, i, arr.At(i));
            break; }
         case TYPE_DOUBLE: { 
            CArrayDouble *arr = params.At(p); 
            for (int i=0; i<arr.Total(); i++)
               PrintFormat("%d %d %f", p, i, arr.At(i));
            break; }
         case TYPE_STRING: { 
            CArrayString *arr = params.At(p); 
            for (int i=0; i<arr.Total(); i++)
               PrintFormat("%d %d %s", p, i, arr.At(i));
            break; }
         case TYPE_BOOL: { 
            CArrayBool *arr = params.At(p); 
            for (int i=0; i<arr.Total(); i++)
               if (arr.At(i) == true)
                  PrintFormat("%d %d true", p, i);
               else
                  PrintFormat("%d %d false", p, i);
            break; }
         case TYPE_DATETIME: { 
            CArrayDatetime *arr = params.At(p); 
            for (int i=0; i<arr.Total(); i++)
               PrintFormat("%d %d %s", p, i, TimeToString(arr.At(i), TIME_DATE|TIME_MINUTES));
            break; }
         case TYPE_MQLRATES: {  //  
            CArrayMqlRates *arr = params.At(p); 
            for (int i=0; i<arr.Total(); i++)
               PrintFormat("%d %d %f %f %f %f", p, i, arr.At(i).open, arr.At(i).high, arr.At(i).low, arr.At(i).close);
            break; }
      };
         
   };
   delete params;
   
  }
//+------------------------------------------------------------------+
