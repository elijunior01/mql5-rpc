//+------------------------------------------------------------------+
//|                                                     MQL5-RPC.mqh |
//|                                      Copyright 2011, Investeo.pl |
//|                                           http://www.investeo.pl |
//+------------------------------------------------------------------+

#property copyright "Copyright 2011, Investeo.pl"
#property link      "http://Investeo.pl"
#property version   "1.00"

#include <wininet.mqh>
#include <xmlrpctags.mqh>
#include <Strings\String.mqh>
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayInt.mqh>
#include <Arrays\ArrayDouble.mqh>
#include <Arrays\ArrayString.mqh>
#include <Arrays\ArrayBool.mqh>
#include <Arrays\ArrayDatetime.mqh>
#include <Arrays\ArrayMqlRates.mqh>
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CXMLRPCQuery
  {
private:
   CString           s_query;

   void              addValueElement(bool start,bool array);

public:
                     CXMLRPCQuery() {};
                     CXMLRPCQuery(string method="",CArrayObj *param_array=NULL);
   string            toString();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void CXMLRPCQuery::addValueElement(bool isStart,bool isArray)
  {
   if(isArray==true)
      if(isStart==true)
        {
         this.s_query.Append(VALUE_B);
         this.s_query.Append(ARRAY_B);
         this.s_query.Append(DATA_B);
           } else {
         this.s_query.Append(DATA_E);
         this.s_query.Append(ARRAY_E);
         this.s_query.Append(VALUE_E);
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CXMLRPCQuery::CXMLRPCQuery(string method="",CArrayObj *param_array=NULL)
  {
/* constructs a single XMLRPC Query */
   this.s_query.Clear();

   CXMLRPCEncoder encoder;
   this.s_query.Append(HEADER_6);
   this.s_query.Append(METHOD_B);
   this.s_query.Append(METHOD_NAME_B);
   this.s_query.Append(method);
   this.s_query.Append(METHOD_NAME_E);
   this.s_query.Append(PARAMS_B);

//Print("Param array " + param_array.Total());
   for(int i=0; i<param_array.Total(); i++)
     {
      int j=0;
      this.s_query.Append(PARAM_B);

      int type=param_array.At(i).Type();
      int elements=0;

      switch(type)
        {
         case TYPE_INT:
           {
            CArrayInt *arr=param_array.At(i);
            elements=arr.Total();
            if(elements==1) addValueElement(true,false); else addValueElement(true,true);
            for(j=0; j<elements; j++) this.s_query.Append(encoder.fromInt(arr.At(j)));
            break;
           }
         case TYPE_DOUBLE:
           {
            CArrayDouble *arr=param_array.At(i);
            elements=arr.Total();
            if(elements==1) addValueElement(true,false); else addValueElement(true,true);
            for(j=0; j<elements; j++) this.s_query.Append(encoder.fromDouble(arr.At(j)));
            break;
           }
         case TYPE_STRING:
           {
            CArrayString *arr=param_array.At(i);
            elements=arr.Total();
            if(elements==1) addValueElement(true,false); else addValueElement(true,true);
            for(j=0; j<elements; j++) this.s_query.Append(encoder.fromString(arr.At(j)));
            break;
           }
         case TYPE_BOOL:
           {
            CArrayBool *arr=param_array.At(i);
            elements=arr.Total();
            if(elements==1) addValueElement(true,false); else addValueElement(true,true);
            for(j=0; j<elements; j++) this.s_query.Append(encoder.fromBool(arr.At(j)));
            break;
           }
         case TYPE_DATETIME:
           {
            CArrayDatetime *arr=param_array.At(i);
            elements=arr.Total();
            if(elements==1) addValueElement(true,false); else addValueElement(true,true);
            for(j=0; j<elements; j++) this.s_query.Append(encoder.fromDateTime(arr.At(j)));
            break;
           }
         case TYPE_MQLRATES:
           {
            CArrayMqlRates *arr=param_array.At(i);
            elements=arr.Total();
            if(elements==1) addValueElement(true,false); else addValueElement(true,true);
            for(j=0; j<elements; j++)
              {
               MqlRates tmp=arr.At(j);
               this.s_query.Append(encoder.fromMqlRates(tmp));
              }
            break;
           }
        };

      if(elements==1) addValueElement(false,false); else addValueElement(false,true);

      this.s_query.Append(PARAM_E);

     }

   this.s_query.Append(PARAMS_E);
   this.s_query.Append(METHOD_E);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CXMLRPCQuery::toString()
  {
   return this.s_query.Str();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CXMLRPCEncoder
  {
public:
                     CXMLRPCEncoder(){};
   string            header(string path,int contentLength);
   string            fromInt(int param);
   string            fromDouble(double param);
   string            fromBool(bool param);
   string            fromString(string param);
   string            fromDateTime(datetime param);
   string            fromMqlRates(MqlRates &param);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CXMLRPCEncoder::header(string path,int cLen)
  {
   CString s_header;
   s_header.Clear();
   s_header.Append(HEADER_1a + " " + path + " " + HEADER_1b + "\r\n");
   s_header.Append(HEADER_2 + "\r\n");
   s_header.Append(HEADER_3 + "\r\n");
   s_header.Append(HEADER_4 + "\r\n");
   s_header.Append(HEADER_5 + IntegerToString(cLen));

   return s_header.Str();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CXMLRPCEncoder::fromInt(int param)
  {
   CString s_int;
   s_int.Clear();
   s_int.Append(VALUE_B);
   s_int.Append(INT_B);
   s_int.Append(IntegerToString(param));
   s_int.Append(INT_E);
   s_int.Append(VALUE_E);

   return s_int.Str();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CXMLRPCEncoder::fromDouble(double param)
  {
   CString s_double;
   s_double.Clear();
   s_double.Append(VALUE_B);
   s_double.Append(DOUBLE_B);
   s_double.Append(DoubleToString(param, 8));
   s_double.Append(DOUBLE_E);
   s_double.Append(VALUE_E);


   return s_double.Str();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CXMLRPCEncoder::fromBool(bool param)
  {
   CString s_bool;
   s_bool.Clear();
   s_bool.Append(VALUE_B);
   s_bool.Append(BOOL_B);
   if(param==true)
      s_bool.Append("1");
   else s_bool.Append("0");
   s_bool.Append(BOOL_E);
   s_bool.Append(VALUE_E);

   return s_bool.Str();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CXMLRPCEncoder::fromString(string param)
  {
   CString s_string;
   s_string.Clear();
   s_string.Append(VALUE_B);
   s_string.Append(STRING_B);
   s_string.Append(param);
   s_string.Append(STRING_E);
   s_string.Append(VALUE_E);

   return s_string.Str();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CXMLRPCEncoder::fromDateTime(datetime param)
  {
   CString s_datetime;
   s_datetime.Clear();
   s_datetime.Append(VALUE_B);
   s_datetime.Append(DATETIME_B);
   CString s_iso8601;
   s_iso8601.Assign(TimeToString(param, TIME_DATE|TIME_MINUTES));
   s_iso8601.Replace(" ", "T");
   s_iso8601.Remove(":");
   s_iso8601.Remove(".");
   s_datetime.Append(s_iso8601.Str());
   s_datetime.Append(DATETIME_E);
   s_datetime.Append(VALUE_E);

   return s_datetime.Str();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CXMLRPCEncoder::fromMqlRates(MqlRates &param)
  {
   CString s_mqlrates;
   s_mqlrates.Clear();
   s_mqlrates.Append(VALUE_B);
   s_mqlrates.Append(STRUCT_B);

/* mqlrates members */
/* open */
   s_mqlrates.Append(MEMBER_B);
   s_mqlrates.Append(NAME_B);  s_mqlrates.Append("open");  s_mqlrates.Append(NAME_E);
   s_mqlrates.Append(VALUE_B); s_mqlrates.Append(DOUBLE_B); s_mqlrates.Append(DoubleToString(param.open)); s_mqlrates.Append(DOUBLE_E); s_mqlrates.Append(VALUE_E);
   s_mqlrates.Append(MEMBER_E);
/* high */
   s_mqlrates.Append(MEMBER_B);
   s_mqlrates.Append(NAME_B);  s_mqlrates.Append("high");  s_mqlrates.Append(NAME_E);
   s_mqlrates.Append(VALUE_B); s_mqlrates.Append(DOUBLE_B); s_mqlrates.Append(DoubleToString(param.high)); s_mqlrates.Append(DOUBLE_E); s_mqlrates.Append(VALUE_E);
   s_mqlrates.Append(MEMBER_E);

/* low */
   s_mqlrates.Append(MEMBER_B);
   s_mqlrates.Append(NAME_B);  s_mqlrates.Append("low");  s_mqlrates.Append(NAME_E);
   s_mqlrates.Append(VALUE_B); s_mqlrates.Append(DOUBLE_B); s_mqlrates.Append(DoubleToString(param.low)); s_mqlrates.Append(DOUBLE_E); s_mqlrates.Append(VALUE_E);
   s_mqlrates.Append(MEMBER_E);

/* close */
   s_mqlrates.Append(MEMBER_B);
   s_mqlrates.Append(NAME_B);  s_mqlrates.Append("close");  s_mqlrates.Append(NAME_E);
   s_mqlrates.Append(VALUE_B); s_mqlrates.Append(DOUBLE_B); s_mqlrates.Append(DoubleToString(param.close)); s_mqlrates.Append(DOUBLE_E); s_mqlrates.Append(VALUE_E);
   s_mqlrates.Append(MEMBER_E);

/* time */
   s_mqlrates.Append(MEMBER_B);
   s_mqlrates.Append(NAME_B);  s_mqlrates.Append("time");  s_mqlrates.Append(NAME_E);
   s_mqlrates.Append(VALUE_B); s_mqlrates.Append(DATETIME_B); s_mqlrates.Append(this.fromDateTime(param.time)); s_mqlrates.Append(DATETIME_E); s_mqlrates.Append(VALUE_E);
   s_mqlrates.Append(MEMBER_E);

/* tick_volume */
   s_mqlrates.Append(MEMBER_B);
   s_mqlrates.Append(NAME_B);  s_mqlrates.Append("tick_volume");  s_mqlrates.Append(NAME_E);
   s_mqlrates.Append(VALUE_B); s_mqlrates.Append(DOUBLE_B); s_mqlrates.Append(DoubleToString(param.tick_volume)); s_mqlrates.Append(DOUBLE_E); s_mqlrates.Append(VALUE_E);
   s_mqlrates.Append(MEMBER_E);

/* real_volume */
   s_mqlrates.Append(MEMBER_B);
   s_mqlrates.Append(NAME_B);  s_mqlrates.Append("real_volume");  s_mqlrates.Append(NAME_E);
   s_mqlrates.Append(VALUE_B); s_mqlrates.Append(DOUBLE_B); s_mqlrates.Append(DoubleToString(param.real_volume)); s_mqlrates.Append(DOUBLE_E); s_mqlrates.Append(VALUE_E);
   s_mqlrates.Append(MEMBER_E);

/* spread */
   s_mqlrates.Append(MEMBER_B);
   s_mqlrates.Append(NAME_B);  s_mqlrates.Append("spread");  s_mqlrates.Append(NAME_E);
   s_mqlrates.Append(VALUE_B); s_mqlrates.Append(DOUBLE_B); s_mqlrates.Append(DoubleToString(param.spread)); s_mqlrates.Append(DOUBLE_E); s_mqlrates.Append(VALUE_E);
   s_mqlrates.Append(MEMBER_E);

   s_mqlrates.Append(STRUCT_E);
   s_mqlrates.Append(VALUE_E);

   return s_mqlrates.Str();
  }
//+------------------------------------------------------------------+
//|           Parse results to Mql arrays                            |
//+------------------------------------------------------------------+
class CXMLRPCResult
  {
private:
   CArrayObj        *m_resultsArr;

   CString           m_cstrResponse;
   CArrayString      m_params;

   bool              isValidXMLResponse();
   bool              parseXMLValuesToMQLArray(CArrayString *subArr,CString &val);
   bool              parseXMLValuesToMQLArray(CArrayDouble *subArr,CString &val);
   bool              parseXMLValuesToMQLArray(CArrayInt *subArr,CString &val);
   bool              parseXMLValuesToMQLArray(CArrayBool *subArr,CString &val);
   bool              parseXMLValuesToMQLArray(CArrayDatetime *subArr,CString &val);
   bool              parseXMLValuesToMQLArray(CArrayMqlRates *subArr,CString &val);
   bool              parseXMLResponse();

public:
                     CXMLRPCResult() {};
                    ~CXMLRPCResult();
                     CXMLRPCResult(string resultXml);
   
   CArrayObj        *getResults();
   bool              parseXMLResponseRAW();
   string            toString();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CXMLRPCResult::CXMLRPCResult(string resultXml)
  {

// parses xml response to MQL5 structures
   m_cstrResponse.Assign(resultXml);
   m_cstrResponse.Remove("\r");
   m_cstrResponse.Remove("\n");
   while (m_cstrResponse.Find(0, "> ") != -1)
      m_cstrResponse.Replace("> ", ">");
   while (m_cstrResponse.Find(0, " <") != -1)
      m_cstrResponse.Replace(" >", ">");
   Print(m_cstrResponse.Str());
   parseXMLResponse();
  }
  
  
CArrayObj* CXMLRPCResult::getResults(){
   return this.m_resultsArr;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CXMLRPCResult::~CXMLRPCResult()
  {
//delete m_cstrResponse;
//delete m_params;
   delete GetPointer(m_cstrResponse);
   delete GetPointer(m_params);
   delete m_resultsArr;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CXMLRPCResult::isValidXMLResponse(void)
  {
// check if xml response is valid
// xml tag at first
// methodResponse object
   if(m_cstrResponse.Find(0,HEADER_6)!=0) return false;
   if(m_cstrResponse.Find(0, RESPONSE_B) == -1) return false;
   if(m_cstrResponse.Find(0, RESPONSE_E) == -1) return false;


   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool CXMLRPCResult::parseXMLValuesToMQLArray(CArrayString *subArr,CString &val)
  {
// parse XML values and populate MQL array
   int tagStartIdx=0; int tagStopIdx=0;

   while((tagStartIdx!=-1) && (tagStopIdx!=-1))
     {
      tagStartIdx= val.Find(tagStartIdx,VALUE_B);
      tagStopIdx = val.Find(tagStopIdx,VALUE_E);
      if((tagStartIdx!=-1) && (tagStopIdx!=-1))
        {
         CString e;
         e.Assign(val.Mid(tagStartIdx+StringLen(VALUE_B)+StringLen(STRING_B),tagStopIdx-tagStartIdx-StringLen(VALUE_B)-StringLen(STRING_B)-StringLen(STRING_E)));
         subArr.Add(e.Str());
         tagStartIdx++; tagStopIdx++;
        };
     }
   if(subArr.Total()<1) return false;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CXMLRPCResult::parseXMLValuesToMQLArray(CArrayDouble *subArr,CString &val)
  {
// parse XML values and populate MQL array
   int tagStartIdx=0; int tagStopIdx=0;

   while((tagStartIdx!=-1) && (tagStopIdx!=-1))
     {
      tagStartIdx= val.Find(tagStartIdx,VALUE_B);
      tagStopIdx = val.Find(tagStopIdx,VALUE_E);
      if((tagStartIdx!=-1) && (tagStopIdx!=-1))
        {
         CString e;
         e.Assign(val.Mid(tagStartIdx+StringLen(VALUE_B)+StringLen(DOUBLE_B),tagStopIdx-tagStartIdx-StringLen(VALUE_B)-StringLen(DOUBLE_B)-StringLen(DOUBLE_E)));
         subArr.Add(StringToDouble(e.Str()));
         tagStartIdx++; tagStopIdx++;
        };
     }
   if(subArr.Total()<1) return false;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CXMLRPCResult::parseXMLValuesToMQLArray(CArrayBool *subArr,CString &val)
  {
// parse XML values and populate MQL array
   int tagStartIdx=0; int tagStopIdx=0;

   while((tagStartIdx!=-1) && (tagStopIdx!=-1))
     {
      tagStartIdx= val.Find(tagStartIdx,VALUE_B);
      tagStopIdx = val.Find(tagStopIdx,VALUE_E);
      if((tagStartIdx!=-1) && (tagStopIdx!=-1))
        {
         CString e;
         e.Assign(val.Mid(tagStartIdx+StringLen(VALUE_B)+StringLen(BOOL_B),tagStopIdx-tagStartIdx-StringLen(VALUE_B)-StringLen(BOOL_B)-StringLen(BOOL_E)));
         if(e.Str()=="0")
            subArr.Add(false);
         if(e.Str()=="1")
            subArr.Add(true);

         tagStartIdx++; tagStopIdx++;
        };
     }
   if(subArr.Total()<1) return false;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CXMLRPCResult::parseXMLValuesToMQLArray(CArrayInt *subArr,CString &val)
  {
// parse XML values and populate MQL array
   int tagStartIdx=0; int tagStopIdx=0;

   while((tagStartIdx!=-1) && (tagStopIdx!=-1))
     {
      tagStartIdx= val.Find(tagStartIdx,VALUE_B);
      tagStopIdx = val.Find(tagStopIdx,VALUE_E);
      if((tagStartIdx!=-1) && (tagStopIdx!=-1))
        {
         CString e;
         e.Assign(val.Mid(tagStartIdx+StringLen(VALUE_B)+StringLen(INT_B),tagStopIdx-tagStartIdx-StringLen(VALUE_B)-StringLen(INT_B)-StringLen(INT_E)));
         subArr.Add((int)StringToInteger(e.Str()));
         tagStartIdx++; tagStopIdx++;
        };
     }
   if(subArr.Total()<1) return false;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CXMLRPCResult::parseXMLValuesToMQLArray(CArrayDatetime *subArr,CString &val)
  {
// parse XML values and populate MQL array
   int tagStartIdx=0; int tagStopIdx=0;

   while((tagStartIdx!=-1) && (tagStopIdx!=-1))
     {
      tagStartIdx= val.Find(tagStartIdx,VALUE_B);
      tagStopIdx = val.Find(tagStopIdx,VALUE_E);
      if((tagStartIdx!=-1) && (tagStopIdx!=-1))
        {
         CString e;
         e.Assign(val.Mid(tagStartIdx+StringLen(VALUE_B)+StringLen(DATETIME_B),tagStopIdx-tagStartIdx-StringLen(VALUE_B)-StringLen(DATETIME_B)-StringLen(DATETIME_E)));
         e.Replace("T"," "); e.Insert(4,"."); e.Insert(7,".");
         subArr.Add(StringToTime(e.Str()));
         tagStartIdx++; tagStopIdx++;
        };
     }
   if(subArr.Total()<1) return false;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CXMLRPCResult::parseXMLResponse()
  {
   CArrayObj *results=new CArrayObj;

   m_params.Clear();

// find params and put them in m_params array
   int tagStartIdx= 0;
   int tagStopIdx = 0;
   while((tagStartIdx!=-1) && (tagStopIdx!=-1))
     {

      tagStartIdx= m_cstrResponse.Find(tagStartIdx,PARAM_B);
      tagStopIdx = m_cstrResponse.Find(tagStopIdx,PARAM_E);

      if((tagStartIdx!=-1) && (tagStopIdx!=-1))
        {
         m_params.Add(m_cstrResponse.Mid(tagStartIdx+StringLen(PARAM_B),tagStopIdx-tagStartIdx-StringLen(PARAM_B)));
         tagStartIdx++; tagStopIdx++;
        };

     };

   for(int i=0; i<m_params.Total(); i++)
     {
      CString val;
      val.Assign(m_params.At(i));

      // parse value tag

      val.Assign(val.Mid(StringLen(VALUE_B),val.Len()-StringLen(VALUE_B)-StringLen(VALUE_E)));

      // now check first tag and handle it approprietaly

      string param_type=val.Mid(0,val.Find(0,">")+1);

      if(param_type==INT_B || param_type==I4_B)
        {
         val.Assign(m_params.At(i));
         CArrayInt *subArr=new CArrayInt;
         bool isValid=parseXMLValuesToMQLArray(subArr,val);
         if(isValid==true)
            results.Add(subArr);
        }
      else if(param_type==BOOL_B)
        {
         val.Assign(m_params.At(i));
         CArrayBool *subArr=new CArrayBool;
         bool isValid=parseXMLValuesToMQLArray(subArr,val);
         if(isValid==true)
            results.Add(subArr);
        }
      else if(param_type==DOUBLE_B)
        {
         val.Assign(m_params.At(i));
         CArrayDouble *subArr=new CArrayDouble;
         bool isValid=parseXMLValuesToMQLArray(subArr,val);
         if(isValid==true)
            results.Add(subArr);
        }
      else if(param_type==STRING_B)
        {
         val.Assign(m_params.At(i));
         CArrayString *subArr=new CArrayString;
         bool isValid=parseXMLValuesToMQLArray(subArr,val);
         if(isValid==true)
            results.Add(subArr);
        }
      else if(param_type==DATETIME_B)
        {
         val.Assign(m_params.At(i));
         CArrayDatetime *subArr=new CArrayDatetime;
         bool isValid=parseXMLValuesToMQLArray(subArr,val);
         if(isValid==true)
            results.Add(subArr);
        }
      else if(param_type==ARRAY_B)
        {
         val.Assign(val.Mid(StringLen(ARRAY_B)+StringLen(DATA_B),val.Len()-StringLen(ARRAY_B)-StringLen(DATA_E)));
         // find first type and define array
         string array_type=val.Mid(StringLen(VALUE_B),val.Find(StringLen(VALUE_B)+1,">")-StringLen(VALUE_B)+1);

         if(array_type==INT_B || array_type==I4_B)
           {
            CArrayInt *subArr=new CArrayInt;
            bool isValid=parseXMLValuesToMQLArray(subArr,val);
            if(isValid==true)
               results.Add(subArr);
           }
         else if(array_type==BOOL_B)
           {
            CArrayBool *subArr=new CArrayBool;
            bool isValid=parseXMLValuesToMQLArray(subArr,val);
            if(isValid==true)
               results.Add(subArr);
           }
         else if(array_type==DOUBLE_B)
           {
            CArrayDouble *subArr=new CArrayDouble;
            bool isValid=parseXMLValuesToMQLArray(subArr,val);
            if(isValid==true)
               results.Add(subArr);
           }
         else if(array_type==STRING_B)
           {
            CArrayString *subArr=new CArrayString;
            bool isValid=parseXMLValuesToMQLArray(subArr,val);
            if(isValid==true)
               results.Add(subArr);

           }
         else if(array_type==DATETIME_B)
           {
            CArrayDatetime *subArr=new CArrayDatetime;
            bool isValid=parseXMLValuesToMQLArray(subArr,val);
            if(isValid==true)
               results.Add(subArr);
           }
        }
     };

   m_resultsArr=results;

   return true;
  }
  
  
bool CXMLRPCResult::parseXMLResponseRAW()
  {
   CArrayObj *results=new CArrayObj;

   m_params.Clear();
   delete m_resultsArr;

   // find params and put them in m_params array
   int tagStartIdx= 0;
   int tagNextStartIdx= 0;
   int tagStopIdx = 0;
   while (tagStartIdx!=-1)
     {
      tagStartIdx= m_cstrResponse.Find(tagStartIdx,VALUE_B);
      tagNextStartIdx= m_cstrResponse.Find(tagStartIdx + 1,VALUE_B);
      tagStopIdx = m_cstrResponse.Find(tagStartIdx + 1,VALUE_E);
      if((tagStartIdx!=-1) && (tagStopIdx!=-1) && (tagStopIdx<tagNextStartIdx || tagNextStartIdx==-1))
        {
         m_params.Add(m_cstrResponse.Mid(tagStartIdx, tagStopIdx - tagStartIdx + StringLen(VALUE_E)));
        } 
      if(tagStartIdx!=-1) tagStartIdx++;
     };

   for(int i=0; i<m_params.Total(); i++)
     {
      CString val;
      val.Assign(m_params.At(i));
      
      // check tag and handle it approprietaly

      string param_type=val.Mid(StringLen(VALUE_B), val.Find(StringLen(VALUE_B) + 1,">") - StringLen(VALUE_B) + 1);
      //Print("param type : " + param_type);

      if(param_type==INT_B || param_type==I4_B)
        {
         CArrayInt *subArr=new CArrayInt;
         bool isValid=parseXMLValuesToMQLArray(subArr,val);
         if(isValid==true)
            results.Add(subArr);
        }
      else if(param_type==BOOL_B)
        {
         CArrayBool *subArr=new CArrayBool;
         bool isValid=parseXMLValuesToMQLArray(subArr,val);
         if(isValid==true)
            results.Add(subArr);
        }
      else if(param_type==DOUBLE_B)
        {
         CArrayDouble *subArr=new CArrayDouble;
         bool isValid=parseXMLValuesToMQLArray(subArr,val);
         if(isValid==true)
            results.Add(subArr);
        }
      else if(param_type==STRING_B)
        {
         CArrayString *subArr=new CArrayString;
         bool isValid=parseXMLValuesToMQLArray(subArr,val);
         if(isValid==true)
            results.Add(subArr);
        }
      else if(param_type==DATETIME_B)
        {
         CArrayDatetime *subArr=new CArrayDatetime;
         bool isValid=parseXMLValuesToMQLArray(subArr,val);
         if(isValid==true)
            results.Add(subArr);
        };
     };
      
   m_resultsArr=results;

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CXMLRPCResult::toString(void) 
  {
// return results array of arrays as a multiline string
   CString r;
   
   for(int i=0; i<m_resultsArr.Total(); i++) 
     {
      int rtype=m_resultsArr.At(i).Type();
      switch(rtype) 
        {
         case(TYPE_STRING) : 
           {
            CArrayString *subArr=m_resultsArr.At(i);
            //if(subArr.Total()>1) Print("string: more than one element edetected");
            for(int j=0; j<subArr.Total(); j++) 
              {
               r.Append(subArr.At(j)+":");
              }
            break;
           };
         case(TYPE_DOUBLE) : 
           {
            CArrayDouble *subArr=m_resultsArr.At(i);
            //if(subArr.Total()>1) Print("double: more than one element edetected");
            for(int j=0; j<subArr.Total(); j++) 
              {
               r.Append(DoubleToString(NormalizeDouble(subArr.At(j),4))+":");
              }
            break;
           };
         case(TYPE_INT) : 
           {
            CArrayInt *subArr=m_resultsArr.At(i);
            //if(subArr.Total()>1) Print("int: more than one element edetected");
            for(int j=0; j<subArr.Total(); j++) 
              {
               r.Append(IntegerToString(subArr.At(j))+":");
              }
            break;
           };
         case(TYPE_BOOL) : 
           {
            CArrayBool *subArr=m_resultsArr.At(i);
            //if(subArr.Total()>1) Print("bool: more than one element edetected");
            for(int j=0; j<subArr.Total(); j++) 
              {
               if(subArr.At(j)==false) r.Append("false:");
               else r.Append("true:");
              }
            break;
           };
         case(TYPE_DATETIME) : 
           {
            CArrayDatetime *subArr=m_resultsArr.At(i);
            //if(subArr.Total()>1) Print("datetime: more than one element edetected");
            for(int j=0; j<subArr.Total(); j++) 
              {
               r.Append(TimeToString(subArr.At(j),TIME_DATE|TIME_MINUTES|TIME_SECONDS)+" : ");
              }
            break;
           };
        };
     }

   return r.Str();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CXMLRPCServerProxy
  {
private:
   bool              m_isConnected;
   string            m_s_proxy;
   int               m_session;
   int               m_connection;
   string            m_connectionStatus;
   string            m_query_path;
   // default constructor
public:
                     CXMLRPCServerProxy() {};
                     CXMLRPCServerProxy(string s_proxy,int timeout=0);
   // public methods
   bool              isConnected() { return m_isConnected; };
   bool              disconnect();
   bool              reconnect();
   void              setProxy(string s_proxy);
   string            status() { return m_connectionStatus; }
   void              ReadPage(int hRequest,string &Out,bool toFile);

   CXMLRPCResult    *execute(CXMLRPCQuery&);

  };
//+------------------------------------------------------------------+

CXMLRPCServerProxy::CXMLRPCServerProxy(string s_proxy,int timeout=0)
  {
   CString proxy;
   proxy.Assign(s_proxy);
   // find query path
   int sIdx = proxy.Find(0,"/");
   if (sIdx == -1)  
      m_query_path = "/";
   else  {
       m_query_path = proxy.Mid(sIdx, StringLen(s_proxy) - sIdx) + "/";
       s_proxy = proxy.Mid(0, sIdx);
    };
   // find query port. 80 is default
   int query_port = 80;
   int pIdx = proxy.Find(0,":");
   if (pIdx != -1) {
      query_port = (int)StringToInteger(proxy.Mid(pIdx+1, sIdx-pIdx));
      s_proxy = proxy.Mid(0, pIdx);
   };
   //Print(query_port);
   //Print(proxy.Mid(pIdx+1, sIdx-pIdx));
   if(InternetAttemptConnect(0)!=0)
     {
      this.m_connectionStatus="InternetAttemptConnect failed.";
      this.m_session=-1;
      this.m_isConnected=false;
      return;
     }
   string agent = "Mozilla";
   string empty = "";

   this.m_session=InternetOpenW(agent,OPEN_TYPE_PRECONFIG,empty,empty,0);

   if(this.m_session<=0)
     {
      this.m_connectionStatus="InternetOpenW failed.";
      this.m_session=-2;
      this.m_isConnected=true;
      return;
     }
   this.m_connection=InternetConnectW(this.m_session,s_proxy,query_port,empty,empty,SERVICE_HTTP,0,0);
   if(this.m_connection<=0)
     {
      this.m_connectionStatus="InternetConnectW failed.";
      return;
     }
   this.m_connectionStatus="Connected.";

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CXMLRPCResult *CXMLRPCServerProxy::execute(CXMLRPCQuery &query)
  {
   
//--- creating descriptor of the request
   string empty_string = "";
   string query_string = query.toString();
   string query_method = HEADER_1a;
   string http_version = HEADER_1b;
   //string query_path="/";
   uchar data[];
   //Print(m_query_path);
   StringToCharArray(query.toString(),data);
   //Print(query.toString());
   int ivar=0;
   int hRequest=HttpOpenRequestW(this.m_connection,query_method,m_query_path,http_version,
                                 empty_string,0,FLAG_KEEP_CONNECTION|FLAG_RELOAD|FLAG_PRAGMA_NOCACHE,0);
   if(hRequest<=0)
     {
      Print("-Err OpenRequest");
      InternetCloseHandle(this.m_connection);
      return(new CXMLRPCResult);
     }
   //-- sending the request
   CXMLRPCEncoder encoder;
   string header=encoder.header(m_query_path,ArraySize(data));
   //Print(header);
   //Print(CharArrayToString(data));
   int aH=HttpAddRequestHeadersW(hRequest,header,StringLen(header),HTTP_ADDREQ_FLAG_ADD|HTTP_ADDREQ_FLAG_REPLACE);
   bool hSend=HttpSendRequestW(hRequest,empty_string,0,data,ArraySize(data)-1);
   if(hSend!=true)
     {
      int err=0;
      err=GetLastError();
      Print("-Err SendRequest= ",err);
     }
   string res;

   ReadPage(hRequest,res,false);
   CString out;
   out.Assign(res);
   out.Remove("\n");
   //Print(out.Str());
   //--- closing all handles
   InternetCloseHandle(hRequest); InternetCloseHandle(hSend);
   CXMLRPCResult* result = new CXMLRPCResult(out.Str());
   return result;
  }

void CXMLRPCServerProxy::ReadPage(int hRequest,string &Out,bool toFile)
  {
   if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED)) { Print("-DLL not allowed"); return; }
   if(!MQL5InfoInteger(MQL5_DLLS_ALLOWED)) { Print("-DLL not allowed"); return; }
 
   uchar ch[100]; string toStr=""; int dwBytes,h=-1;
   if(toFile) h=FileOpen(Out,FILE_ANSI|FILE_BIN|FILE_WRITE);
   while(InternetReadFile(hRequest,ch,100,dwBytes))
     {
      if(dwBytes<=0) break; toStr=toStr+CharArrayToString(ch,0,dwBytes);
      if(toFile) for(int i=0; i<dwBytes; i++) FileWriteInteger(h,ch[i],CHAR_VALUE);
     }
   if(toFile) { FileFlush(h); FileClose(h); }
   else Out=toStr;
  }
//+------------------------------------------------------------------+

