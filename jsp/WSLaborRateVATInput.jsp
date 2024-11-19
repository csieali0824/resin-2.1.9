<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,Array2DimensionInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function NeedConfirm()
{ 
 flag=confirm("是否確定刪除?"); 
 return flag;
}
function setSubmit(URL)
{
   warray=new Array(document.MYFORM.VAT.value,document.MYFORM.MONTH1.value,document.MYFORM.MONTH2.value,document.MYFORM.MONTH3.value,
                    document.MYFORM.MONTH4.value,document.MYFORM.MONTH5.value,document.MYFORM.MONTH6.value,
				    document.MYFORM.MONTH7.value,document.MYFORM.MONTH8.value,document.MYFORM.MONTH9.value,
				    document.MYFORM.MONTH10.value,document.MYFORM.MONTH11.value,document.MYFORM.MONTH12.value,
                    document.MYFORM.MONTH13.value,document.MYFORM.MONTH14.value,document.MYFORM.MONTH15.value,
                    document.MYFORM.MONTH16.value,document.MYFORM.MONTH17.value,document.MYFORM.MONTH18.value,
				    document.MYFORM.MONTH19.value,document.MYFORM.MONTH20.value,document.MYFORM.MONTH21.value,
					document.MYFORM.MONTH22.value,document.MYFORM.MONTH23.value,document.MYFORM.MONTH24.value );   
   for (i=0;i<12;i++)
   {     
      if (warray[i]=="" || warray[i]==null)
     { 
      alert("Before you want to add , please do not let the Monthly Cost of forecast data be Null !!");   
      return(false);
      } 
   } //end of for  null check
   
   for (i=0;i<12;i++)
   {     
      txt=warray[i];
	  for (j=0;j<txt.length;j++)      
     { 
	  c=txt.charAt(j);
	    if ("0123456789.".indexOf(c,0)<0) 
	    {
            alert("Monthly forecast data should be numerical!!");   
            return(false);
		 }
      } 
   } //end of for  null check

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setSubmit2(URL,dim1,dim2)
{    
   if (dim1<1)  //若沒有任何資料則不能存檔
   {
       alert("No Need to Save because there is no any data being Added!!");   
       return(false);
   }

   for (i=0;i<dim1;i++)
   {     
      for (j=1;j<dim2;j++)
	  {
	     if (document.MYFORM.elements["MONTH"+i+"-"+j].value=="" || document.MYFORM.elements["MONTH"+i+"-"+j].value==null)
		 { 
           alert("Before you want to save , please do not let the Monthly Cost of forecast  detail be Null !!");   
           return(false);
		 }  
	  } //enf for of jj             
   } //end of for null check
   
    for (i=0;i<dim1;i++)
   {     
      for (k=1;k<dim2;k++)
	  {
         txt=document.MYFORM.elements["MONTH"+i+"-"+k].value;
	     for (j=0;j<txt.length;j++)      
         { 
	       c=txt.charAt(j);
	        if ("0123456789.".indexOf(c,0)<0) 
	       {
             alert("Monthly cost of forecast detail should be numerical!!");   
             return(false);
		    }
         }
	   } //enf for of k
   } //end of for  null check

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="session" class="DateBean"/> <!--用來抓出目前為幾月-->

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sales Forecast Labor Load Rate VAT Input Form</title>
</head>
<body>
<FORM ACTION="WSLaborRateVATInput.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> <font color="#000000" size="+2" face="Times New Roman"><strong>Sales Forecast Labor Load、ExRate and VAT Input </strong></font> <BR></strong></font> 
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to C&F sub menu</A>  
<%   
String vYear=request.getParameter("VYEAR");
String vMonth=request.getParameter("VMONTH");
dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1); 
int commitmentMonth=0;
array2DimensionInputBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
String comp=request.getParameter("COMP");
String type=request.getParameter("TYPE");
String region=request.getParameter("REGION");
String country=request.getParameter("COUNTRY");     
String curr=request.getParameter("CURR");
String [] addItems=request.getParameterValues("ADDITEMS");
String chooseItem=request.getParameter("CHOOSEITEM");
String vat=request.getParameter("VAT");
String month1=request.getParameter("MONTH1"),month2=request.getParameter("MONTH2"),month3=request.getParameter("MONTH3");
String month4=request.getParameter("MONTH4"),month5=request.getParameter("MONTH5"),month6=request.getParameter("MONTH6");
String month7=request.getParameter("MONTH7"),month8=request.getParameter("MONTH8"),month9=request.getParameter("MONTH9");
String month10=request.getParameter("MONTH10"),month11=request.getParameter("MONTH11"),month12=request.getParameter("MONTH12");
String month13=request.getParameter("MONTH13"),month14=request.getParameter("MONTH14"),month15=request.getParameter("MONTH15");
String month16=request.getParameter("MONTH16"),month17=request.getParameter("MONTH17"),month18=request.getParameter("MONTH18");
String month19=request.getParameter("MONTH19"),month20=request.getParameter("MONTH20"),month21=request.getParameter("MONTH21");
String month22=request.getParameter("MONTH22"),month23=request.getParameter("MONTH23"),month24=request.getParameter("MONTH24");
String [] allMonth={month1,month2,month3,month4,month5,month6,month7,month8,month9,month10,month11,month12,month13,month14,month15,month16,month17,month18,month19,month20,month21,month22,month23,month24,vat};
String ymh1="",ymh2="",ymh3="",ymh4="",ymh5="",ymh6="",ymh7="",ymh8="",ymh9="",ymh10="",ymh11="",ymh12="";
String ymh1LBL="",ymh2LBL="",ymh3LBL="",ymh4LBL="",ymh5LBL="",ymh6LBL="",ymh7LBL="",ymh8LBL="",ymh9LBL="",ymh10LBL="",ymh11LBL="",ymh12LBL="";
String ymh1RATE="",ymh2RATE="",ymh3RATE="",ymh4RATE="",ymh5RATE="",ymh6RATE="",ymh7RATE="",ymh8RATE="",ymh9RATE="",ymh10RATE="",ymh11RATE="",ymh12RATE=""; 

out.println("<BR><font color='#330099' face='Arial Black'><strong>This Month is :"+thisDateBean.getYearString()+"/"+thisDateBean.getMonthString()+"</strong></font>");

try 
{    
   String at[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容     
  //*************依Detail資料user可能再修改內容,故必須將其內容重寫入陣列內
   if (at!=null) 
   {
      for (int ac=0;ac<at.length;ac++)
	  {    	        
            for (int subac=1;subac<at[ac].length;subac++)
	      {
		      at[ac][subac]=request.getParameter("MONTH"+ac+"-"+subac); //取上一頁之輸入欄位
		   }  //end for array second layer count
	  } //end for array first layer count
   	 array2DimensionInputBean.setArray2DString(at);  //reset Array
   }   //end if of array !=null
   //********************************************************************

  if (addItems!=null) //若有選取則表示要刪除
  {
    String a[][]=array2DimensionInputBean.getArray2DContent();//重新取得陣列內容        
    if (a!=null && addItems.length>0)      
    { 		 
	 if (a.length>addItems.length)
	 {	  	  	    
       String t[][]=new String[a.length-addItems.length][a[0].length];     
	   int cc=0;
	   for (int m=0;m<a.length;m++)
	   {
	    String inArray="N";		
		for (int n=0;n<addItems.length;n++)  
		{
		 if (addItems[n].equals(a[m][0])) inArray="Y";
		} //end of for addItems.length  		 
		if (inArray.equals("N")) 
		{
		  for (int gg=0;gg<13;gg++) //置入陣列中元素數
		  {
    		 t[cc][gg]=a[m][gg];
	      }
		 cc++;			     
		}  
	   } //end of for a.length	   
	   array2DimensionInputBean.setArray2DString(t);
	 } else { 	   			 
	   array2DimensionInputBean.setArray2DString(null); //將陣列內容清空
	 }  
	}//end of if a!=null
  } 
 
  if ( bringLast!=null   && bringLast.equals("Y"))  //若要帶出前一版本資料則執行以下動作
  {
    Statement blstat=con.createStatement();
    ResultSet blrs=null;
                for (int jj=0;jj<12;jj++)  //因為有12個月
				{			   				  				
				  blrs=blstat.executeQuery("select FCCOST,FCMVER FROM PSALES_FORE_COST where FCCOMP='"+comp+"' and FCTYPE='"+type+"' and FCREG='"+region+"' and FCCOUN='"+country+"' and FCPRJCD='"+chooseItem+"' and FCMONTH='"+dateBean.getMonthString()+"' and FCYEAR='"+dateBean.getYearString()+"' and FCCURR='"+curr+"' order by FCMVER DESC");                  				  
				  if (blrs!=null)
				  {				    					 
					 if ( blrs.next())
					 {
				       allMonth[jj]=blrs.getString("FCCOST");					  					    						
					 } else {
					    allMonth[jj]="0";
					 }				  				    
				  } //end if of blrs!=null				  
				  blrs.close();
				  dateBean.setAdjMonth(1);	
				} //end for of tj loop      			
	  blstat.close();			
  } //enf of bringLast if   
  dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//將日期調回初始值
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}  
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      
      <td width="28%" height="23" bordercolor="#FFFFFF"> 
        <p><font color="#330099" size="2" face="Arial Black"><strong>Forecast Type:
          <% 				 		 
	     try
         {		  		  		 	    		  		 		 		  
		  Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery("select TYPE_DESC_GBL  from WSTYPE_CODE where TYPE='"+type+"'");
          if (rs.next())  out.println(rs.getString("TYPE_DESC_GBL"));		
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
	    </strong></font> 
      </td>
      <td width="17%"><font color="#333399" size="2" face="Arial Black"><strong>Region: <%=region%>  </strong></font>        
      </td>
      <td width="24%"><font size="2"> <font color="#333399" face="Arial Black"><strong>Country: 
        <% 		 		 		 
	     try
         { 		 		  				  		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery("select LOCALE_ENG_NAME from WSLOCALE where LOCALE='"+country+"'");         
           if (rs.next())  out.println(rs.getString("LOCALE_ENG_NAME"));		 
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %> 
	   </strong></font>
        <INPUT TYPE="button"  value="Add" onClick='setSubmit("../jsp/WSLaborRateVATInput.jsp")' >
	  </font></td>     
  </tr>
</table>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
  <tr>      
      <td width="96" bgcolor="#FFFFCC"><font color="#006666" size="2"><strong>Internal Model</strong></font></td>
      <td width="54" bgcolor="#FFFFCC"><font color="#006666" size="2"><strong>VAT</strong></font></td> 
	  <td width="105" colspan="1" bgcolor="#009999"><div align="center"><font size="2">
          <%
		ymh1=dateBean.getYearString()+"/"+dateBean.getMonthString();
        ymh1LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh1+" LABOR</strong></div></font>";
        ymh1RATE=ymh1+" RATE";  
		out.println(ymh1LBL+"<BR>RATE");
		%>
      </font></div></td> 
	  <td width="64" colspan="1" bgcolor="#009999"><div align="center"><font  size="2">
	    <%dateBean.setAdjMonth(1); 
	    ymh2=dateBean.getYearString()+"/"+dateBean.getMonthString();
        ymh2LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh2+" LABOR</strong></div></font>";
        ymh2RATE=ymh2+" RATE";  
		out.println(ymh2LBL+"<BR>RATE");
	  %>
      </font></div></td> 
	  <td width="64" colspan="1" bgcolor="#009999"><div align="center"><font  size="2">
	      <%dateBean.setAdjMonth(1);
		ymh3=dateBean.getYearString()+"/"+dateBean.getMonthString();
        ymh3LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh3+" LABOR</strong></div></font>";
        ymh3RATE=ymh3+" RATE";  
		out.println(ymh3LBL+"<BR>RATE");
	  %>
      </font></div></td>
	  <td width="64" colspan="1" bgcolor="#009999"><div align="center"><font  size="2">
	      <%dateBean.setAdjMonth(1);
		ymh4=dateBean.getYearString()+"/"+dateBean.getMonthString();
        ymh4LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh4+" LABOR</strong></div></font>";
        ymh4RATE=ymh4+" RATE";  
		out.println(ymh4LBL+"<BR>RATE");
	  %>
      </font></div></td> 
	  <td width="64" colspan="1" bgcolor="#009999"><div align="center"><font  size="2">
	      <%dateBean.setAdjMonth(1);
		  ymh5=dateBean.getYearString()+"/"+dateBean.getMonthString();
          ymh5LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh5+" LABOR</strong></div></font>";
          ymh5RATE=ymh5+" RATE";  
		  out.println(ymh5LBL+"<BR>RATE");
	  %>
      </font></div></td> 
	  <td width="64" bgcolor="#009999"><div align="center"><font  size="2">
          <%dateBean.setAdjMonth(1);
		  ymh6=dateBean.getYearString()+"/"+dateBean.getMonthString();
          ymh6LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh6+" LABOR</strong></div></font>";
          ymh6RATE=ymh6+" RATE";  
		  out.println(ymh6LBL+"<BR>RATE");
	 %>
      </font></div></td>
	  <td width="64" bgcolor="#009999"><div align="center"><font  size="2">
	      <%dateBean.setAdjMonth(1);
		  ymh7=dateBean.getYearString()+"/"+dateBean.getMonthString();
          ymh7LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh7+" LABOR</strong></div></font>";
          ymh7RATE=ymh7+" RATE";  
		  out.println(ymh7LBL+"<BR>RATE");
	 %>
      </font></div></td>
	  <td width="64" bgcolor="#009999"><div align="center"><font  size="2">
	      <%dateBean.setAdjMonth(1);
		  ymh8=dateBean.getYearString()+"/"+dateBean.getMonthString();
          ymh8LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh8+" LABOR</strong></div></font>";
          ymh8RATE=ymh8+" RATE";  
		  out.println(ymh8LBL+"<BR>RATE");
	 %>
      </font></div></td>
	  <td width="64" bgcolor="#009999"><div align="center"><font  size="2">
	      <%dateBean.setAdjMonth(1);
		  ymh9=dateBean.getYearString()+"/"+dateBean.getMonthString();
          ymh9LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh9+" LABOR</strong></div></font>";
          ymh9RATE=ymh9+" RATE";  
		  out.println(ymh9LBL+"<BR>RATE");
	 %>
      </font></div></td>
	  <td width="64" bgcolor="#009999"><div align="center"><font  size="2">
	      <%dateBean.setAdjMonth(1);
		  ymh10=dateBean.getYearString()+"/"+dateBean.getMonthString();
          ymh10LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh10+" LABOR</strong></div></font>";
          ymh10RATE=ymh10+" RATE";  
		  out.println(ymh10LBL+"<BR>RATE");
	 %>
      </font></div></td>
	  <td width="64" bgcolor="#009999"><div align="center"><font  size="2">
	      <%dateBean.setAdjMonth(1);
		  ymh11=dateBean.getYearString()+"/"+dateBean.getMonthString();
          ymh11LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh11+" LABOR</strong></div></font>";
          ymh11RATE=ymh11+" RATE";  
		  out.println(ymh11LBL+"<BR>RATE");
	 %>
      </font></div></td>
	  <td width="64" colspan="1" bgcolor="#009999"><div align="center"><font  size="2">
	      <%dateBean.setAdjMonth(1);
		 ymh12=dateBean.getYearString()+"/"+dateBean.getMonthString();
         ymh12LBL="<font color='#FFFF00'><div align='center'><strong>"+ymh12+" LABOR</strong></div></font>";
         ymh12RATE=ymh12+" RATE";  
		 out.println(ymh12LBL+"<BR>RATE");
	 %>
      </font></div></td>	  
    </tr>
  <tr>
    <td> <font size="2">
      <%	    	     		 		 
	     try
         {   
		   //String cntModel = "0";
           String modelGet = "'null'";     
           String sSqlA = "select count(INT_MODEL) as CNT, INT_MODEL  from PSALES_LBLRATE_VAT ";		  
		   String sWhereA= "where COUNTRY='"+country+"' and INT_MODEL in(select DISTINCT INTER_MODEL from PSALES_PROD_CENTER ) "+
                    "group by INT_MODEL ";
           sSqlA = sSqlA + sWhereA;	
           Statement stateA=con.createStatement();
           ResultSet rsA=stateA.executeQuery(sSqlA);     
           while (rsA.next() )
           {
              int cntModel = rsA.getInt("CNT");
              if (cntModel>=12) 
              {  modelGet=modelGet+",'"+rsA.getString(2)+"'"; }
           }  
           rsA.close();      
		   stateA.close();	
         
		   String modelArray[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容
		   String aString="'--'";
		   if (bringLast==null || chooseItem.equals("--"))
		   {            
   		     aString="'"+chooseItem+"'";
		   }			 
	        if (modelArray!=null) 
	        {
	           for (int l=0;l<modelArray.length;l++)
	          {
	            aString=aString+",'"+modelArray[l][0]+"'";
   	          }
	        }		 
		  

		  String sSqlC = "";
		  String sWhereC = "";
		  
		  sSqlC = "select DISTINCT INTER_MODEL as x , INTER_MODEL from PSALES_PROD_CENTER ";		  
		  sWhereC= "where INTER_MODEL not in("+modelGet+") order by x";		             		 
		  sSqlC = sSqlC+sWhereC;		  
		  //out.println(sSqlC);	      
          Statement statementC=con.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (bringLast!=null && bringLast.equals("Y") && !chooseItem.equals("--"))  comboBoxBean.setSelection(chooseItem);		  		  		  
	      comboBoxBean.setFieldName("CHOOSEITEM");	   
          out.println(comboBoxBean.getRsString());
		 
          rsC.close();      
		  statementC.close();			 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
    </font> </td>
   <td><input type="text" name="VAT"  size="7"  <%if (allMonth[24]!=null) out.println("value="+allMonth[24]); else out.println("value=");%> >  </td>
    <td>
     <input type="text" name="MONTH1"  size="7"  <%if (allMonth[0]!=null) out.println("value="+allMonth[0]); else out.println("value=0.0");%> ><BR>
     <input type="text" name="MONTH2"  size="7"  <%if (allMonth[1]!=null) out.println("value="+allMonth[1]); else out.println("value=0");%> >
    </td>
    <td>
     <input type="text" name="MONTH3"  size="7" <%if (allMonth[2]!=null) out.println("value="+allMonth[2]); else out.println("value=0.0");%> ><BR>
     <input type="text" name="MONTH4"  size="7" <%if (allMonth[3]!=null) out.println("value="+allMonth[3]); else out.println("value=0");%> >    
    </td>
    <td>
     <input type="text" name="MONTH5"  size="7" <%if (allMonth[4]!=null) out.println("value="+allMonth[4]); else out.println("value=0.0");%>><BR>
     <input type="text" name="MONTH6"  size="7" <%if (allMonth[5]!=null) out.println("value="+allMonth[5]); else out.println("value=0");%>>   
    </td>
    <td>
      <input type="text" name="MONTH7"  size="7" <%if (allMonth[6]!=null) out.println("value="+allMonth[6]); else out.println("value=0.0");%>>
      <input type="text" name="MONTH8"  size="7" <%if (allMonth[7]!=null) out.println("value="+allMonth[7]); else out.println("value=0");%>>   
    </td>
    <td>
      <input type="text" name="MONTH9"  size="7" <%if (allMonth[8]!=null) out.println("value="+allMonth[8]); else out.println("value=0.0");%>>
      <input type="text" name="MONTH10"  size="7" <%if (allMonth[9]!=null) out.println("value="+allMonth[9]); else out.println("value=0");%>> 
    </td>
    <td>
      <input type="text" name="MONTH11"  size="7" <%if (allMonth[10]!=null) out.println("value="+allMonth[10]); else out.println("value=0.0");%>>
      <input type="text" name="MONTH12"  size="7" <%if (allMonth[11]!=null) out.println("value="+allMonth[11]); else out.println("value=0");%>>    
    </td>
    <td>
      <input type="text" name="MONTH13"  size="7"  <%if (allMonth[12]!=null) out.println("value="+allMonth[12]); else out.println("value=0.0");%> >
      <input type="text" name="MONTH14"  size="7"  <%if (allMonth[13]!=null) out.println("value="+allMonth[13]); else out.println("value=0");%> >
    </td>
    <td>
      <input type="text" name="MONTH15"  size="7"  <%if (allMonth[14]!=null) out.println("value="+allMonth[14]); else out.println("value=0.0");%> >
      <input type="text" name="MONTH16"  size="7"  <%if (allMonth[15]!=null) out.println("value="+allMonth[15]); else out.println("value=0");%> >    
    </td>
    <td>
      <input type="text" name="MONTH17"  size="7"  <%if (allMonth[16]!=null) out.println("value="+allMonth[16]); else out.println("value=0.0");%> >
      <input type="text" name="MONTH18"  size="7"  <%if (allMonth[17]!=null) out.println("value="+allMonth[17]); else out.println("value=0");%> >
    </td>
    <td>
      <input type="text" name="MONTH19"  size="7"  <%if (allMonth[18]!=null) out.println("value="+allMonth[18]); else out.println("value=0.0");%> >
      <input type="text" name="MONTH20"  size="7"  <%if (allMonth[19]!=null) out.println("value="+allMonth[19]); else out.println("value=0");%> > 
    </td>
    <td>
      <input type="text" name="MONTH21"  size="7"  <%if (allMonth[20]!=null) out.println("value="+allMonth[20]); else out.println("value=0.0");%> >
      <input type="text" name="MONTH22"  size="7"  <%if (allMonth[21]!=null) out.println("value="+allMonth[21]); else out.println("value=0");%> >
    </td>
    <td>
      <input type="text" name="MONTH23"  size="7"  <%if (allMonth[22]!=null) out.println("value="+allMonth[22]); else out.println("value=0.0");%> >
      <input type="text" name="MONTH24"  size="7"  <%if (allMonth[23]!=null) out.println("value="+allMonth[23]); else out.println("value=0");%> >  
    </td>
    </tr>  
  <tr bgcolor="#FFCC33">
    <td colspan="14"><div align="center">      <strong>
      <%
	  try
      {
        
	    String oneDArray[]= {"","INTER MODEL","VAT",ymh1LBL,ymh1RATE,ymh2LBL,ymh2RATE,ymh3LBL,ymh3RATE,ymh4LBL,ymh4RATE,ymh5LBL,ymh5RATE,ymh6LBL,ymh6RATE,ymh7LBL,ymh7RATE,ymh8LBL,ymh8RATE,ymh9LBL,ymh9RATE,ymh10LBL,ymh10RATE,ymh11LBL,ymh11RATE,ymh12LBL,ymh12RATE}; 	 	     			  
    	array2DimensionInputBean.setArrayString(oneDArray);
	     String a[][]=array2DimensionInputBean.getArray2DFrToContent();//取得目前陣列內容  	   			    
		 int i=0,j=0,k=0;
         String dupFLAG="FALSE";
	     if (chooseItem!=null && !chooseItem.equals("--") && bringLast==null) //bringLast是用來識別是否帶出上一次輸入之最新版本資料
		 {               		    
		   if (a!=null) 
		   {
		     String b[][]=new String[a.length+1][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 {
			  for (j=0;j<a[i].length;j++)
			  {
			    b[i][j]=a[i][j];	
                if (a[k][0].equals(chooseItem)) { dupFLAG = "TRUE"; }				
			  }
			  k++;
			 }
             if (dupFLAG=="TRUE" || dupFLAG.equals("TRUE")) { out.println("Duplicate last Input : "+chooseItem+" on your list"); }
             else
             { 

			   b[k][0]=chooseItem;			 
			   b[k][1]=month1;b[k][2]=month2;b[k][3]=month3;b[k][4]=month4;b[k][5]=month5;b[k][6]=month6;	
			   b[k][7]=month7;b[k][8]=month8;b[k][9]=month9;b[k][10]=month10;b[k][11]=month11;b[k][12]=month12;
               b[k][13]=month13;b[k][14]=month14;b[k][15]=month15;b[k][16]=month16;b[k][17]=month17;b[k][18]=month18;	
			   b[k][19]=month19;b[k][20]=month20;b[k][21]=month21;b[k][22]=month22;b[k][23]=month23;b[k][24]=month24;	
               b[k][25]=vat;
			   array2DimensionInputBean.setArray2DString(b);
               dupFLAG = "FALSE"; 
             } 			 						 			 	   			              
		   } else {		     			  
			 String c[][]={{chooseItem,vat,month1,month2,month3,month4,month5,month6,month7,month8,month9,month10,month11,month12,month13,month14,month15,month16,month17,month18,month19,month20,month21,month22,month23,month24}};			             			 
		     array2DimensionInputBean.setArray2DString(c); 						 	                
		   }                   	                       		        		  
		 } else {
		   if (a!=null) 
		   {
		     array2DimensionInputBean.setArray2DString(a);     			       	                
		   } 
		 }
		 //end if of chooseItem is null
		 
		 //###################針對目前陣列內容進行檢查機制#############################		  
		  Statement chkstat=con.createStatement();
          ResultSet chkrs=null;
		  String T2[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容做為暫存用;	  			  	
		  String tp[]=array2DimensionInputBean.getArrayContent();
		  if  (T2!=null) 
		  {  		   
		    //-------------------------取得轉存用陣列-------------------- 		    
	        String temp[][]=new String[T2.length][T2[0].length];		    
			 for (int ti=0;ti<T2.length;ti++)
			 {
			    for (int tj=0;tj<T2[ti].length;tj++)  
			   {				 
				  temp[ti][tj]=T2[ti][tj];
				}
		      }		
		    //--------------------------------------------------------------------
			
			 for (int ti=0;ti<temp.length;ti++)
			 {
			    for (int tj=1;tj<=commitmentMonth;tj++)  //因為只有n個月為commitment
				{
				  String tpym=tp[tj+1]; 				  
				  String tpy=tpym.substring(0,4); //get year String				  
				  String tpm=tpym.substring(5,7); //get month String	   								  
				  chkrs=chkstat.executeQuery("select FCCOST,FCMVER FROM PSALES_FORE_COST where FCCOMP='"+comp+"' and FCTYPE='"+type+"' and FCREG='"+region+"' and FCCOUN='"+country+"' and FCPRJCD='"+temp[ti][0]+"' and FCYEAR='"+tpy+"' and FCMONTH='"+tpm+"' and FCCURR='"+curr+"' order by FCMVER DESC");                  				  
				  if (chkrs!=null)
				  {				    					 
					 if ( chkrs.next())
					 {					   
				       temp[ti][tj]=chkrs.getString("FCCOST");
					  } else {
					    temp[ti][tj]="N";						
					  }
				  } else {
				     temp[ti][tj]="N";					 
				  } //end if of chkrs!=null
				  chkrs.close();
				} //end for of tj loop
			 }  //end for of ti loop
		     array2DimensionInputBean.setArray2DCheck(temp);  //置入檢查陣列以為控制之用			   
		  } else {    		      		     
		      array2DimensionInputBean.setArray2DCheck(null);
		  }	 //end if of T2!=null	   
		  if (chkrs!=null) chkrs.close();
		  chkstat.close();		  
		 //##############################################################	    	 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </strong></div></td>    
    </tr>
</table>
<input name="button" type=button onClick="this.value=check(this.form.ADDITEMS)" value="Select All">
-----DETAIL you choosed to be saved-------------------------------------------------------------------------------------------<BR>
<% 
     int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
	  try
      {	
	    String a[][]=array2DimensionInputBean.getArray2DFrToContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {
		        div1=a.length;
				div2=a[0].length;
	        	array2DimensionInputBean.setFieldName("ADDITEMS");			 			 	   			 
                out.println(array2DimensionInputBean.getArray2DFrToString());  		   	 				
		 }	//enf of a!=null if
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
<BR>
<INPUT name="button2" TYPE="button" onClick='setSubmit("../jsp/WSLaborRateVATInput.jsp")'  value="DELETE" >
-------------------------------------------------------------------------------------------------------
<INPUT TYPE="button"  value="SAVE" onClick='setSubmit2("../jsp/WSLaborRateVATInsert.jsp",<%=div1%>,<%=div2%>)' >
---------------------
<!-- 表單參數 -->  
    <input name="COMP" type="HIDDEN" value="<%=comp%>" > 
    <input name="TYPE" type="HIDDEN" value="<%=type%>" > 
	<input name="REGION" type="HIDDEN" value="<%=region%>" >
	<input name="COUNTRY" type="HIDDEN" value="<%=country%>" > 
	<input name="CURR" type="HIDDEN" value="<%=curr%>" > 
	<input name="VYEAR" type="HIDDEN" value="<%=vYear%>" > 
	<input name="VMONTH" type="HIDDEN" value="<%=vMonth%>" > 
</FORM>   
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
