<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnREPAIRPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="page" class="DateBean"/>
<%   
  String thisYear=thisDateBean.getYearString(); //存為今天當天日期年份
  String thisMonth=thisDateBean.getMonthString(); //存為今天當天日期月份
  thisDateBean.setAdjMonth(2); //今天當天日期往後調整2個月,即看三個月後
  String vYear=request.getParameter("VYEAR");
  String vMonth=request.getParameter("VMONTH"); 
  if (vYear!=null && vMonth!=null) dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1); 
  String comp=request.getParameter("COMP");
  String type=request.getParameter("TYPE");
  String regionNo=request.getParameter("REGION");
  String country=request.getParameter("COUNTRY");
  if (country!=null && country.equals("--")) country="00"; 
  
  //Statement repairStat=conREPAIR.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY); 
  Statement repairStat=dmcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY); 
  ResultSet repairRs=null;  
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  ResultSet rs=null;  
%>
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
function NeedConfirm(URL1,URL2,field)
{   
  for (i = 0; i < field.length; i++) 
  {
    if (field[i].checked == true)  //只檢查有選定的項目
	{	      	   
	   limit=document.MYFORM.elements[field[i].value+"-LIMIT"].value; //取得其限制值	   
	   curInput=document.MYFORM.elements[(field[i].value)+"-4"].value; //取得其輸入值	   
	   model=document.MYFORM.elements[(field[i].value)+"-0"].value;
	   color=document.MYFORM.elements[(field[i].value)+"-2"].value;	   
	   
	   if (curInput>limit || curInput<"0")	//不得大於限制值也不得小於0
	   {
	      alert("Sorry!!The "+model+"|"+color+"'s input value of PR QTY("+curInput+") should not bigger than estimated value("+limit+") or smaller than zero !!");  
	      return(false);
	   }  
	}	
  }  
  
  if (document.MYFORM.COMP.value=="--" || document.MYFORM.COMP.value==null)
  { 
   alert("Please Check the BUSINESS UNIT!!It should not be null or blanked");   
   return(false);
  } 

  flag=confirm("Submit Confirm?");  
  if (flag==true)
  {
    setSubmit(URL1,URL2);
  } else {
   return flag;   
  } 
}
function setSubmit(URL1,URL2)
{  
   if (document.MYFORM.TYPE.value=="--" || document.MYFORM.TYPE.value==null)
  { 
   alert("Please Check the TYPE!!It should not be null or blanked");   
   return(false);
  } 

   if (document.MYFORM.REGION.value=="--" || document.MYFORM.REGION.value==null)
  { 
   alert("Please Check the REGION!!It should not be null or blanked");   
   return(false);
  }   
 
  if (document.MYFORM.TYPE.value=="003") //如果為SOURCING旳FORECAST則用其他處理
  { 
   document.MYFORM.action=URL1;
  } else {
   document.MYFORM.action=URL2;
  } 
 document.MYFORM.submit();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Forecast Application Form</title>
</head>
<body>
<FORM ACTION="WSForToApply.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> Purchase Requirement for Forecast</strong></font>
<BR>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back
to submenu</A>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<strong><font color="#FF0000">SET THE TARGET DATE-&gt;</font></strong><font color="#333399" face="Arial Black"><strong>Year</strong></font>
                  <%    	      		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
          arrayComboBoxBean.setArrayString(a);
		  if (vYear==null)
		  {		    
		    arrayComboBoxBean.setSelection(thisDateBean.getYearString());
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(vYear);
		  }
	      arrayComboBoxBean.setFieldName("VYEAR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
      %>
                  <font color="#330099" face="Arial Black"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Month</strong></font>
                  <%		       		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (vMonth==null)
		  {		    
		    arrayComboBoxBean.setSelection(thisDateBean.getMonthString());			
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(vMonth);
		  }
	      arrayComboBoxBean.setFieldName("VMONTH");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %> 
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="23%" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black"><strong>Bussiness
            Unit:</strong></font>
			<BR>
			<% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select trim(MCCOMP),MCDESC from WSMULTI_COMP";		  
		  sWhere = " where MCACCT='Y' order by MCCOMP";		 
		  sSql = sSql+sWhere;		  		  		      
		            
          rs=statement.executeQuery(sSql);		 
		 
          comboBoxBean.setRs(rs);		  
		  comboBoxBean.setSelection(comp);
	      comboBoxBean.setFieldName("COMP");	   
          out.println(comboBoxBean.getRsString());		 
          rs.close();      		  		                     		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>  
	</td> 
      <td width="20%" height="23" bordercolor="#FFFFFF"> 
        <p><font color="#330099" face="Arial Black"><strong>Type</strong></font> 
		<BR>
          <% 		
	     try
         {   
		  String sSql = "";		 
		  sSql = "select TYPE , TYPE|| '('|| TYPE_DESC_GBL||')' from WSADMIN.WSTYPE_CODE "; 		  		 		 		  		
          
          rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  
		  comboBoxBean.setSelection(type);
	      comboBoxBean.setFieldName("TYPE");	   
          out.println(comboBoxBean.getRsString());		 
          rs.close();   		  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
      </td>
      <td width="22%"><font color="#333399" face="Arial Black"><strong>Region</strong></font> 
	  <BR>
        <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select Unique REGION as x , REGION from WSREGION";		  
		  sWhere = " order by x";		 
		  sSql = sSql+sWhere;			  		      
          
          rs=statement.executeQuery(sSql);
		  
		  out.println("<select NAME='REGION' onChange='setSubmit("+'"'+"../jsp/WSForeToApply.jsp"+'"'+","+'"'+"../jsp/WSForeToApply.jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->--");     
          while (rs.next())
          {            
           String s1=(String)rs.getString(1); 
           String s2=(String)rs.getString(2); 
                        
            if (s1.equals(regionNo)) 
           {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
            } else {
              out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
           } //end of while
           out.println("</select>"); 	  		  		  
        
          rs.close();  		   		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>  
      </td>
      <td colspan="2"> <font color="#333399" face="Arial Black"><strong>Country</strong></font>
	  <BR> 
        <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select x.LOCALE, LOCALE_ENG_NAME from WSREGION x,WSLOCALE y";		  
		  sWhere = " where REGION='"+regionNo+"' and x.LOCALE=y.LOCALE  order by LOCALE_ENG_NAME";		              
		  sSql = sSql+sWhere;
		  
		  //out.println(sSqlRCenter);	               
          rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  		 
		  if (country!=null) comboBoxBean.setSelection(country);
	      comboBoxBean.setFieldName("COUNTRY");	   
          out.println(comboBoxBean.getRsString());		  
          rs.close();  		    		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %> 
	 </td>  
	  <td width="8%" colspan="2"><input name="submit1" type="submit" value="Query" onClick='return setSubmit("../jsp/WSForeToApply.jsp","../jsp/WSForeToApply.jsp")'>
</td> 
	</tr>	
	<tr>
	    <td colspan="6"><div align="left"> <HR>       </div></td>
	</tr>
    <tr bgcolor="#FFFFFF"> 	   
       <td colspan="6">
         <div align="left">
<% 
  String yearMonthString[][]=new String[3][2]; //做為存入year及month陣列         
  String endYear=dateBean.getYearString(); //表示為目標日期年份
  String endMonth=dateBean.getMonthString();//表示為目標日期月份
  yearMonthString[2][0]=dateBean.getYearString();
  yearMonthString[2][1]=dateBean.getMonthString();
  dateBean.setAdjMonth(-1);
  yearMonthString[1][0]=dateBean.getYearString();
  yearMonthString[1][1]=dateBean.getMonthString();
  dateBean.setAdjMonth(-1);
  String beginYear=dateBean.getYearString();
  String beginMonth=dateBean.getMonthString();
  yearMonthString[0][0]=dateBean.getYearString();
  yearMonthString[0][1]=dateBean.getMonthString();
 
  try
  {     
   String sSql = "";
   Statement subStmt=con.createStatement();
   ResultSet subRs=null;
   rs=statement.executeQuery("select sum(a.FMQTY) from PSALES_FORE_MONTH a,PICOLOR_MASTER,PIMASTER where a.FMVER=(select max(b.FMVER) from PSALES_FORE_MONTH b where a.FMYEAR=b.FMYEAR and a.FMMONTH=b.FMMONTH and a.FMCOLOR=b.FMCOLOR and a.FMPRJCD=b.FMPRJCD and a.FMCOUN=b.FMCOUN and a.FMTYPE=b.FMTYPE) and FMYEAR||FMMONTH='"+endYear+endMonth+"' and a.FMCOLOR=COLORCODE and a.FMPRJCD=PROJECTCODE(+) and a.FMCOUN="+country+" and a.FMTYPE='"+type+"'");                  
   rs.next();   
   if (rs.getInt(1)>0)   //若有資料且數量大於零才顯示
   {     
    rs.close();      	     	    
	rs=statement.executeQuery("select Unique '@'||FMPRJCD||'@'||FMCOLOR,FMPRJCD,SALESCODE,COLORDESC,FMCOLOR,FMQTY,FMTYPE from PSALES_FORE_MONTH a,PICOLOR_MASTER,PIMASTER where a.FMVER=(select max(b.FMVER) from PSALES_FORE_MONTH b where a.FMYEAR=b.FMYEAR and a.FMMONTH=b.FMMONTH and a.FMCOLOR=b.FMCOLOR and a.FMPRJCD=b.FMPRJCD and a.FMCOUN=b.FMCOUN and a.FMTYPE=b.FMTYPE) and FMYEAR||FMMONTH='"+endYear+endMonth+"' and a.FMCOLOR=COLORCODE and a.FMPRJCD=PROJECTCODE(+) and a.FMCOUN="+country+" and a.FMTYPE='"+type+"' order by FMPRJCD"); 
    String bgColor="B0E0E6";
    String s="";    
%>	
	<TABLE width="694" bordercolor="#999999" border="1" cellspacing="0">	 	
	<TR bordercolor="#999999" bgcolor="#99CCFF">
	  <td width="64"><input name='button2' type=button onClick='this.value=check(this.form.CH)' value='Select All'></td>
	  <td width="457"><font color="#333399" size="2" face="Arial Black"><strong>REMARK:</strong></font>
        <input name="REMARK" type="text" size="40">	</td>	
	  <td width="96"><font color="#FF0000"><strong>(Unit/K pcs)</strong></font></td>
	  <td width="59">
	  <div align="right">
	    <input name='button' type=button onClick='return NeedConfirm("../jsp/WSForeToApplyInsert.jsp","../jsp/WSForeToApplyInsert.jsp",this.form.CH)' value='Submit'>
	    </div></td>
	<TR>
	</TABLE>
<font color="#0000FF"></font>
<%	
    out.println("<TABLE>"); 
    out.println("<TR><TH BGCOLOR=BLACK>&nbsp;</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>INTER MODEL</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>EXT MODEL</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>COLOR</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>FORECAST</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>PR QTY</TH></TR>");
	String prevModelColor="";
     while (rs.next()) {      
	   int totalShipQty=0;//今天日期之前一月份以前之所有累積出貨數	
	   int currFCQty=0;//target日期當月之銷售預測數字
	   int totalFCQty=0;//今天日期當月(含)之後到target日期前一個月之間的銷售預測數字總數
	   int totalPRQty=0;//target日期前一個月以前之所有已核准購料需求總數
	   int etm_prQty=0; //推估之target日期之購料數量
	   String etm_prQtySTR="0";
	      	 
	   if (rs.getFloat("FMQTY")>0 && !prevModelColor.equals(rs.getString(1))  ) //只有當不與前一個model重覆時才顯示       	 
	   {
	     int elementCount=0;
         out.println("<TR BGCOLOR="+bgColor+"><TD><INPUT TYPE=checkbox NAME='CH' VALUE='"+(String)rs.getString(1)+"'></TD>");
         for (int i=2;i<5;i++)
         {
          s=(String)rs.getString(i);
          out.println("<TD><FONT SIZE=2>"+s+"<input type='HIDDEN' name='"+(String)rs.getString(1)+"-"+elementCount+"' value='"+s+"'></TD>");
		  elementCount++;
         } //end of for	  	 	   
	   
	     //取得Target日期當月的銷售預測數字 
	     subRs=subStmt.executeQuery("select FMVER,FMQTY from PSALES_FORE_MONTH where FMYEAR='"+endYear+"' and FMMONTH ='"+endMonth+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' and FMCOUN="+country+" and FMTYPE='"+type+"' order by FMVER DESC"); 		 		 
		 if (subRs.next())
		 {
		  s=(String)subRs.getString("FMQTY");		  
		  currFCQty=Math.round((Float.parseFloat(subRs.getString("FMQTY")))*1000);  //因為銷售預測是以K(1000)為單位,故乘以1000
		  out.println("<TD ALIGN='CENTER'><FONT SIZE=2>"+s+"<input type='HIDDEN' name='"+(String)rs.getString(1)+"-"+elementCount+"' value='"+s+"'></TD>");				  
		 } 	
		 elementCount++;	 
		 subRs.close();
		 
		 //取得Target日期當月之前到今天當天日期間之月份的銷售預測數字加總 
	     subRs=subStmt.executeQuery("select sum(f.FMQTY) as totalqty from PSALES_FORE_MONTH f where f.FMTYPE='"+type+"' and f.FMCOUN="+country+" and f.FMCOLOR='"+rs.getString("FMCOLOR")+"' and f.FMPRJCD='"+rs.getString("FMPRJCD")+"' and f.FMYEAR||f.FMMONTH>='"+thisYear+thisMonth+"' and f.FMYEAR||f.FMMONTH<'"+endYear+endMonth+"' and f.FMVER=(select max(FMVER) from PSALES_FORE_MONTH where FMYEAR=f.FMYEAR and FMMONTH=f.FMMONTH and FMCOUN=f.FMCOUN and FMTYPE=f.FMTYPE and FMPRJCD=f.FMPRJCD and FMCOLOR=f.FMCOLOR)"); 		 		 
		 if (subRs.next())
		 {
		   if (subRs.getString("totalqty")!=null && !subRs.getString("totalqty").equals("0") )
		    {	
		       totalFCQty=Math.round((Float.parseFloat(subRs.getString("totalqty")))*1000);  //因為銷售預測是以K(1000)為單位,故乘以1000  			  
            }			   
		 } 			 	 
		 subRs.close();
		 
		 //取得target日期當月(含)以前之所有已核准購料需求總數(由200410為起始日)
	     subRs=subStmt.executeQuery("select sum(l.RQQTY) as prqty from PSALES_FORE_APP_LN l,PSALES_FORE_APP_HD h where l.DOCNO=h.DOCNO and h.CANCEL!='Y' and h.APPROVED='Y' and h.RQYEAR||h.RQMONTH between '200410' and '"+endYear+endMonth+"' and h.COUNTRY="+country+" and h.TYPE='"+type+"' and l.PRJCD='"+rs.getString("FMPRJCD")+"' and l.COLOR='"+rs.getString("COLORDESC")+"'"); 		 		 
		 if (subRs.next())
		 {				    
		    if (subRs.getString("prqty")!=null && !subRs.getString("prqty").equals("0") )
		    {			   
		      totalPRQty=Math.round((Float.parseFloat(subRs.getString("prqty")))*1000);  //因為銷售預測是以K(1000)為單位,故乘以1000
		    }				    					  
		 } 			 	 
		 subRs.close();
		 
		 //自維修系統中取得今天當月之前累計出貨數字資訊   
         // 2005.06.20 Ivy Yang改自Data Center取得出貨統計
		 //sSql="select sum(PCOUNT) as shqty from PISSHIPCNT "
		 //+" where PCLASS='MO' and COUNTRY='"+country+"' and PMODEL='"+rs.getString("FMPRJCD")+"' and PCOLOR='"+rs.getString("COLORDESC")+"'"
		 //+" and PYEAR||PMONTH <'"+thisYear+thisMonth+"' and PYEAR||PMONTH >='200410'"; //200410是購料需求的導入日期月份,以此為限是為使出貨及購料需求不致相差太多而變成換算出來的數字太離譜	     
     	sSql = "SELECT sum(a.ssqty) AS shqty FROM dmadmin.stock_ship_mon a,wsadmin.prodmodel b "
  		+" WHERE a.ssitemno=b.mitem "+" AND b.mcountry='"+country+"' and a.ssmodelno='"+rs.getString("FMPRJCD")+"' and b.mCOLOR='"+rs.getString("FMCOLOR")+"'"
  		+" AND ((a.ssyear<"+thisYear+") OR (a.ssyear="+thisYear+" and a.ssmonth<"+thisMonth+"))" //跨年的處理
		+" AND ((a.ssyear>2004) OR (a.ssyear=2004 and a.ssmonth>=10))";
		//out.println(sSql);
		repairRs=repairStat.executeQuery(sSql);
		
		 if (repairRs.next())   {		  
		    if (repairRs.getString("shqty")!=null && !repairRs.getString("shqty").equals("0") )
		    {
		      totalShipQty=repairRs.getInt("shqty");
			}          
         } //enf of repairRs.next if
         repairRs.close(); 
		 
		 etm_prQty=(totalShipQty+totalFCQty)-(totalPRQty)+(currFCQty);
		 //out.println((String)rs.getString(1)+"|"+"totalShipQty:"+totalShipQty+"|totalFCQty:"+totalFCQty+"|totalPRQty:"+totalPRQty+" %");
		 if (etm_prQty>currFCQty)  etm_prQty=currFCQty; //若推估出來target日期當月之購料需求值大於當月之銷售預測數字則,以銷售預測為主
		 if (etm_prQty>0)
		 { 
		   float qq=Float.parseFloat(String.valueOf(etm_prQty));
		   etm_prQtySTR=String.valueOf(qq/1000);
		   int wp=etm_prQtySTR.indexOf(".");
		   if (etm_prQtySTR.substring(wp+1,wp+2).equals("0"))
		   {
		     etm_prQtySTR=etm_prQtySTR.substring(0,wp);
		   } else {
		     etm_prQtySTR=etm_prQtySTR.substring(0,wp+2);
		   }	 		   
		 } //end of etm_prQty>0 if
	     	
		 out.println("<TD><INPUT TYPE='text' NAME='"+(String)rs.getString(1)+"-"+elementCount+"' SIZE=6 value='"+etm_prQtySTR+"'></TD>"); //推估出之target日期的購料需求數
         out.println("<TD><input type='HIDDEN' NAME='"+(String)rs.getString(1)+"-LIMIT' value='"+etm_prQtySTR+"'></TD>");		 
         out.println("</TR>");
      
         if (bgColor.equals("B0E0E6")) //間隔列顏色改換
         {
           bgColor="ADD8E6";
         } else {
           bgColor="B0E0E6";
         }           
		prevModelColor=rs.getString(1);		 
	   }//END prevModel.equals(rs.getString("FMPRJCD") if	   
      } //end of while	
      out.println("</TABLE>");          
   } //end of rs.next() if     
   
   rs.close();   
   if (subRs!=null)  subRs.close();
   subStmt.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
%>
         </div></td></tr>
</table>
<!-- 表單參數 --> 
<input name="TARGETYEAR" type="HIDDEN" value="<%=endYear%>" > <!--表示為目標日期年份-->
<input name="TARGETMONTH" type="HIDDEN" value="<%=endMonth%>" > <!--表示為目標日期月份-->
</FORM>
</body>
<%
  statement.close();
  repairStat.close();
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnREPAIRPage.jsp"%>
<!--=================================-->
</html>
