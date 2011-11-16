//+------------------------------------------------------------------+
//|                                         MQL5-RPC_result_test.mq5 |
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
 
   string sampleXMLResult = "<?xml version='1.0'?>"
                            "<methodResponse>" +
                            "<params>" +
                            "<param>" +
                            "<value><array><data>" +
                            "<value><string>Xupypr</string></value>" +
                            "<value><string>anuta</string></value>" +
                            "<value><string>plencing</string></value>" +
                            "<value><string>aharata</string></value>" +
                            "<value><string>beast</string></value>" +
                            "<value><string>west100</string></value>" +
                            "<value><string>ias</string></value>" +
                            "<value><string>Tim</string></value>" +
                            "<value><string>gery18</string></value>" +
                            "<value><string>ronnielee</string></value>" +
                            "<value><string>investeo</string></value>" +
                            "<value><string>droslan</string></value>" +
                            "<value><string>Better</string></value>" +
                            "</data></array></value>" +
                            "</param>" + 
                            "<param>" +
                            "<value><array><data>" +
                            "<value><double>1.222</double></value>" +
                            "<value><double>0.456</double></value>" +
                            "<value><double>1000000000.10101</double></value>" +
                            "</data></array></value>" +
                            "</param>" + 
                            "<param>" +
                            "<value><array><data>" +
                            "<value><boolean>1</boolean></value>" +
                            "<value><boolean>0</boolean></value>" +
                            "<value><boolean>1</boolean></value>" +
                            "</data></array></value>" +
                            "</param>" + 
                            "<param>" +
                            "<value><array><data>" +
                            "<value><int>-1</int></value>" +
                            "<value><int>0</int></value>" +
                            "<value><int>1</int></value>" +
                            "</data></array></value>" +
                            "</param>" + 
                            "<param>" +
                            "<value><array><data>" +
                            "<value><dateTime.iso8601>20021125T02:20:04</dateTime.iso8601></value>" +
                            "<value><dateTime.iso8601>20111115T00:00:00</dateTime.iso8601></value>" +
                            "<value><dateTime.iso8601>20121221T00:00:00</dateTime.iso8601></value>" +
                            "</data></array></value>" +
                            "</param>" + 
                            "<param><value><string>Single string value</string></value></param>" +
                            "<param><value><dateTime.iso8601>20111115T00:00:00</dateTime.iso8601></value></param>" +
                            "<param><value><int>-111</int></value></param>" +
                            "<param><value><boolean>1</boolean></value></param>" +
                            "</params>" +
                            "</methodResponse>";

   CXMLRPCResult* testResult = new CXMLRPCResult(sampleXMLResult);
   
   
   Print(testResult.toString());

   delete testResult;
  }
//+------------------------------------------------------------------+
