<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="ComboBoxAllBean,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Ship Statistics</title>
</head>
<body>
<FORM ACTION="../jsp/WSShipStatistic.jsp" METHOD="post" NAME="MYFORM" >
  <table width="100%" border="0">
    <tr> 
      <td><div align="center"><strong><font color="#0000FF" size="3" face="Arial">Taipei 
          DBTEL Industry Co.,Ltd. </font></strong></div></td>
    </tr>
    <tr> 
      <td align="center"><strong><font color="#0000FF" size="+2" face="Arial">Shipping 
        Statistic of&nbsp; 
        <% 
	   String locale=request.getParameter("LOCALE");
       String YearFr=request.getParameter("YEARFR");
       String MonthFr=request.getParameter("MONTHFR"); 
       String model=request.getParameter("MODEL"); 
	   String item=request.getParameter("ITEM");	 
	   String thisMonthString="",previous1MonthString="",previous2MonthString="",previous3MonthString="";//月份字串
	   String thisDayString="",previous1DayString="",previous2DayString="",previous3DayString="";
	   String previous4DayString="",previous5DayString="",previous6DayString="";  	   
	   
	   
	   if (MonthFr==null)	   
	   { MonthFr=dateBean.getMonthString();}	 	    
	     try
        {   
	       Statement stateM=con.createStatement();
	       String sqlM = "select MENG from WSADMIN.WSMONTH_CODE where  MMON_AR =  '"+MonthFr+"'  ";
		   ResultSet rsM=stateM.executeQuery(sqlM);
		   if (rsM.next())
		   {
		    out.println(rsM.getString("MENG"));			
		   }
		   else
		   {}
		   rsM.close();
		   stateM.close();
		 } //end of try
         catch (Exception e)
        {
          out.println("Exception:"+e.getMessage());		  
        }  
	   
	%>
        </font></strong></td>
    </tr>
  </table>
  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> 
  <table width="100%" border="0" bordercolor="#CCFFFF" >
    <tr bgcolor="#66CCFF"> 
      <td width="23%"><font color="#000000" face="Arial Black"><strong>Model:</strong></font> 
        <% 		 		 		 
	     try
         {		  		  
		  //out.println(sSql);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery("select unique MPROJ,MPROJ from PRODMODEL,PSALES_FORE_MONTH where trim(MPROJ)=trim(FMPRJCD)");
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(model);
	      comboBoxAllBean.setFieldName("MODEL");	   
          out.println(comboBoxAllBean.getRsString());		
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %> </td>
      <td width="34%"> <font color="#000000" face="Arial Black"><strong>Item No.:</strong></font> 
        <% 		 		 		 
	     try
         {		  		  
		  //out.println(sSql);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery("select unique MITEM,MITEM from PRODMODEL,PSALES_FORE_MONTH where trim(MPROJ)=trim(FMPRJCD)");
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(item);
	      comboBoxAllBean.setFieldName("ITEM");	   
          out.println(comboBoxAllBean.getRsString());		
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %> </td>
      <td><input name="Search"  type="submit" value="Query"></td>
    </tr>
  </table>

  <table width="100%" border="1" cellspacing="0" cellpadding="0">
    <tr bordercolor="#000000" bgcolor="#CCFFFF" > 
      <td width="7%" rowspan="2"><div align="center"><font size="2"><font face="新細明體">ITEM 
          NO.</font></font></div></td>
      <td width="7%" rowspan="2" ><div align="center"><font size="2" face="新細明體">MODEL</font></div></td>
      <td width="7%" rowspan="2"><div align="center"><font size="2" face="新細明體">Color</font></div></td>
      <td colspan="4" align=center>庫存資訊</td>
      <td colspan="5" align=center>月 出貨資訊</td>
      <td colspan="7" align=center>日 出貨資訊</td>
      <td width="5%"><div align="center"><font size="2" face="新細明體">樣品領取</font></div></td>
    </tr>
    <tr bordercolor="#000000" > 
      <td width="5%" bgcolor="#CCFFFF"><div align="center"><font size="2" face="新細明體">前日結存</font></div></td>
      <td width="5%" bgcolor="#CCFFFF"><div align="center"><font size="2" face="新細明體">本日入庫</font></div></td>
      <td width="5%" bgcolor="#CCFFFF"><div align="center"><font size="2" face="新細明體">本日出庫</font></div></td>
      <td width="5%" bgcolor="#CCFFFF"><div align="center"><font size="2" face="新細明體">本日結存</font></div></td>
      <td width="6%" bgcolor="#CCFFFF"><font size="2">累計</font></td>
      <td width="5%" bgcolor="#CCFFFF"><font size="2"> 
        <%
	     dateBean.setAdjMonth(-3);
		 out.println(dateBean.getMonth()+"月");
		 previous3MonthString=dateBean.getYearString()+dateBean.getMonthString();
		 dateBean.setAdjMonth(3);
	  %></strong>
        </font> </font></td>
      <td width="5%" bgcolor="#CCFFFF"><font size="2"> 
        <%
	     dateBean.setAdjMonth(-2);
		 out.println(dateBean.getMonth()+"月");
		 previous2MonthString=dateBean.getYearString()+dateBean.getMonthString();
		 dateBean.setAdjMonth(2);
	  %></strong>
        </font> </font></td>
      <td width="5%" bgcolor="#CCFFFF"><font size="2"> 
        <%
	     dateBean.setAdjMonth(-1);
		 out.println(dateBean.getMonth()+"月");
		 previous1MonthString=dateBean.getYearString()+dateBean.getMonthString();
		 dateBean.setAdjMonth(1);
	  %>
        </font></td>
      <td width="5%" bgcolor="#CCFFFF"><strong><font size="2" face="新細明體">本月</font></strong>
	  <%
	   thisMonthString=dateBean.getYearString()+dateBean.getMonthString();
	  %>
	  </td>
      <td width="4%" bgcolor="#CCFFFF"><div align="center"><strong><font size="2" face="新細明體">當日</font></strong></div>
	   <%
	   thisDayString=dateBean.getYearMonthDay();
	  %>
	  </td>
      <td width="4%" bgcolor="#CCFFFF"><font size="2"> 
        <%
	     dateBean.setAdjDate(-1);
		 out.println(dateBean.getMonth()+"/"+dateBean.getDay());
		 previous1DayString=dateBean.getYearMonthDay();
		 dateBean.setAdjDate(1);
	  %>
        </font></td>
      <td width="4%" bgcolor="#CCFFFF"><font size="2"> 
        <%
	     dateBean.setAdjDate(-2);
		 out.println(dateBean.getMonth()+"/"+dateBean.getDay());
		 previous2DayString=dateBean.getYearMonthDay();
		 dateBean.setAdjDate(2);
	  %>
        </font></td>
      <td width="4%" bgcolor="#CCFFFF"><font size="2"> 
        <%
	     dateBean.setAdjDate(-3);
		 out.println(dateBean.getMonth()+"/"+dateBean.getDay());
		 previous3DayString=dateBean.getYearMonthDay();
		 dateBean.setAdjDate(3);
	  %>
        </font></td>
      <td width="4%" bgcolor="#CCFFFF"><font size="2"> 
        <%
	     dateBean.setAdjDate(-4);
		 out.println(dateBean.getMonth()+"/"+dateBean.getDay());
		 previous4DayString=dateBean.getYearMonthDay();
		 dateBean.setAdjDate(4);
	  %>
        </font></td>
      <td width="4%" bgcolor="#CCFFFF"><font size="2"> 
        <%
	     dateBean.setAdjDate(-5);
		 out.println(dateBean.getMonth()+"/"+dateBean.getDay());
		 previous5DayString=dateBean.getYearMonthDay();
		 dateBean.setAdjDate(5);
	  %>
        </font></td>
      <td width="4%" bgcolor="#CCFFFF"><font size="2"> 
        <%
	     dateBean.setAdjDate(-6);
		 out.println(dateBean.getMonth()+"/"+dateBean.getDay());
		 previous6DayString=dateBean.getYearMonthDay();
		 dateBean.setAdjDate(6);
	  %>
        </font></td>
      <td width="5%" bgcolor="#CCFFFF">累計</td>
    </tr>
    <% // ***  Main Loop  Start   ***//
      int rs1__numRows = 35;
      int rs1__index = 0;
      int rs_numRows = 0;
      rs_numRows += rs1__numRows;
	  String fmPrjCode = "";
	  String fmItem = "";
	  String fmColor="";
	  long totalAllMonthShipAmt=0,totalThisMonthShipAmt=0,totalPrevious1MonthShipAmt=0,totalPrevious2MonthShipAmt=0,totalPrevious3MonthShipAmt=0;
      long totalSampleOut=0;	  
	  long totalThisDayShipAmt=0,totalPrevious1DayShipAmt=0,totalPrevious2DayShipAmt=0,totalPrevious3DayShipAmt=0;
	  long totalPrevious4DayShipAmt=0,totalPrevious5DayShipAmt=0,totalPrevious6DayShipAmt=0;  	  	  
      long totalThisDayBalance=0,totalPreviousDayBalance=0,totalThisDayIn=0,totalThisDayOut=0;
   
      boolean getDataFlag = false;
	
        Statement statement=con.createStatement();   		
		try
		{		 
         String sql = "select unique MPROJ,MITEM,colordesc from PRODMODEL,PSALES_FORE_MONTH,picolor_master";
		 if (model!=null && !model.equals("--"))
		 {
		   if (item!=null && !item.equals("--"))
		   {
		     sql = sql+" where trim(MITEM)='"+item+"' and trim(MPROJ)=trim(FMPRJCD) and mcolor=colorcode";
		   } else {
		     sql = sql+" where trim(MPROJ)='"+model+"' and trim(MPROJ)=trim(FMPRJCD) and mcolor=colorcode";
		   }
		 } else {
		   if (item!=null && !item.equals("--"))
		   {
		     sql = sql+" where trim(MITEM)='"+item+"' and trim(MPROJ)=trim(FMPRJCD) and mcolor=colorcode";
		   } else {
		     sql = sql+" where trim(MPROJ)=trim(FMPRJCD) and mcolor=colorcode";
		   }
		 }		 
		 
         ResultSet rs=statement.executeQuery(sql);		 
		
		 boolean rs_isEmpty = !rs.next();
         boolean rs_hasData = !rs_isEmpty;
         Object rs_data;		
		
		while ((rs_hasData)&&(rs1__numRows-- != 0)) 
		{		 
		  long opb=0,rct=0,adju=0,issu=0;
		  long previousDayBalance=0,thisDayBalance=0,thisDayIn=0,thisDayOut=0,thisDayAdj=0;
          long thisDaySampleOut=0,thisDaySampleRec=0,thisDaySalesReturn=0;
		  long thisMonthShipAmt=0,previous1MonthShipAmt=0,previous2MonthShipAmt=0,previous3MonthShipAmt=0;//月份累積出貨量
		  long thisDayShipAmt=0,previous1DayShipAmt=0,previous2DayShipAmt=0,previous3DayShipAmt=0;
		  long previous4DayShipAmt=0,previous5DayShipAmt=0,previous6DayShipAmt=0;
		  long sampleOut=0;
		  		
		  getDataFlag = true;
		  fmPrjCode = rs.getString("MPROJ");
		  fmItem = rs.getString("MITEM");
		  fmColor=rs.getString("colordesc");
       %>
    <tr bordercolor="#000000"> 
      <td height="29"><font color="#990033" size="2"> 
        <%
	  out.println(fmItem);
	  %>
        </font></td>
      <td ><font color="#990033" size="2"> 
        <%
         out.println(fmPrjCode);
        %>
        </font></td>
      <td><div align="right"><font color="#990033" size="2"> 
          <%
		  out.println(fmColor);		
  %>
          </font></div></td>
      <td> <div align="right"><font color="#0000FF" size="2"> 
          <%
    try
    {  
	  Statement docstatement=bpcscon.createStatement();	  
      ResultSet docrs=docstatement.executeQuery("SELECT SUM(LOPB),SUM(LRCT),SUM(LADJU),SUM(LISSU) FROM ILI WHERE LPROD='"+fmItem+"' and LWHS=52");	  	  
	   while (docrs.next()) //取得期初餘額OPB
       { 	     
	     if (docrs.getString(1)!=null) 
		 {		 
		   opb=docrs.getInt(1);		   		   
		 }
		 if (docrs.getString(2)!=null) 
		 {		 
		   rct=docrs.getInt(2);
		 }		  
		 if (docrs.getString(3)!=null) 
		 {		 
		   adju=docrs.getInt(3);
		 }
		 if (docrs.getString(4)!=null) 
		 {		 
		   issu=docrs.getInt(4);
		 }
	   } //end of docrs while
	   docrs.close();  	    		   
	   
       docrs=docstatement.executeQuery("SELECT SUM(TQTY) FROM ITH WHERE TPROD='"+fmItem+"' and TTYPE='R' and TTDTE ="+dateBean.getYearMonthDay()+" and TWHS=52");	 	  	     	   
       while (docrs.next())
       {	 
	     if (docrs.getString(1)!=null)
		 {
		  thisDayIn=docrs.getInt(1); //取得入庫量		  
		 }		  
	   } //end of docrs while
	   docrs.close(); 	   
	   
	   docrs=docstatement.executeQuery("SELECT ABS(SUM(TQTY)),trim(TTYPE) FROM ITH WHERE TPROD='"+fmItem+"' and TTYPE in ('B','S') and TTDTE ="+dateBean.getYearMonthDay()+" and TWHS in (52,71,72,73) group by TTYPE");	 	  	     
       while (docrs.next())
       {	
	     String id1=docrs.getString(2);	 	    
	     if (docrs.getString(1)!=null && id1.equals("B"))
		 {
		  thisDayOut=docrs.getInt(1); //取得出庫量
		 }				 
		 if (docrs.getString(1)!=null && id1.equals("S"))
		 {
		  thisDaySampleOut=docrs.getInt(1); //取得樣品出庫量
		 }		  
	   } //end of docrs while
	   docrs.close(); 	   
	   
       docrs=docstatement.executeQuery("SELECT SUM(TQTY) FROM ITH WHERE TPROD='"+fmItem+"' and (TTYPE='O' or TTYPE='CN') and TTDTE ="+dateBean.getYearMonthDay()+" and TWHS=52");	 	  	     
       while (docrs.next())
       {	 
	     if (docrs.getString(1)!=null)
		 {
		  thisDayAdj=docrs.getInt(1); //取得調整量
		 }		  
	   } //end of docrs while
	   docrs.close();  	  
	   
      docrs=docstatement.executeQuery("SELECT SUM(TQTY),trim(TTYPE) FROM ITH WHERE TPROD='"+fmItem+"' and TTYPE in ('SR','RM') and TTDTE ="+dateBean.getYearMonthDay()+" and TWHS in (52,71,72,73) group by TTYPE");	 	  	     
       while (docrs.next())
       {	 
	     String id2=docrs.getString(2);
	     if (docrs.getString(1)!=null && id2.equals("SR"))
		 {
		  thisDaySampleRec=docrs.getInt(1); //取得樣品回收量
		 }		  
		 
		 if (docrs.getString(1)!=null && id2.equals("RM"))
		 {
		  thisDaySalesReturn=docrs.getInt(1); //取得銷退量
		 }		
	   } //end of docrs while
	   docrs.close();          	   		 	   
        	   
	   docstatement.close();
	   previousDayBalance=opb+rct+adju-issu-thisDayIn-thisDayAdj+thisDayOut-thisDaySalesReturn;//前日結存	   
	   if (previousDayBalance != 0) {out.println(previousDayBalance);  }
	   else {out.println("&nbsp;"); }
	   
	   thisDayBalance=previousDayBalance+thisDayIn-thisDayAdj-thisDayOut-thisDaySampleOut+thisDaySampleRec;      	   
	   
	    //以下為計算total數	   
	   totalThisDayIn=totalThisDayIn+thisDayIn;  
	   totalThisDayOut=totalThisDayOut+thisDayOut;
	   totalThisDayBalance=totalThisDayBalance+thisDayBalance;
	   totalPreviousDayBalance=totalPreviousDayBalance+previousDayBalance;	   
    } //end of try
    catch (Exception e)
    {
      out.println("Exception:"+e.getMessage());
    }	   
  %>
          </font></div></td>
      <td> <div align="right"><font color="#0000FF" size="2"> 
          <% if (thisDayIn!=0){out.println(thisDayIn); }
	                                                                                                 else {out.println("&nbsp;"); }%>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <% if (thisDayOut!=0){out.println(thisDayOut); }
	                                                                                                 else {out.println("&nbsp;"); }%>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <% if (thisDayBalance!=0){out.println(thisDayBalance); }
	                                                                                                 else {out.println("&nbsp;"); }%>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <%
    try
    {  
	  Statement docstatement=bpcscon.createStatement();
	  String dateBegin = previous3MonthString+"01";  
	  String dateEnd = thisMonthString+"31";  	  
	  String sqlTT =  "SELECT abs(SUM(TQTY)),TTDTE FROM ITH WHERE TPROD='"+fmItem+"' and trim(TTYPE) in ('B','RM') and TTDTE between "+dateBegin+" and "+dateBean.getYearMonthDay()+" and TWHS in ('52','71','72','73') group by TTDTE";  	  
      ResultSet docrs=docstatement.executeQuery(sqlTT);
	   while (docrs.next()) 
	   {	 
	    String ttid1=docrs.getString(2);
		ttid1=ttid1.substring(0,6);		
	     if (docrs.getString(1)!=null && ttid1.equals(thisMonthString)) 
		 {		 
		   thisMonthShipAmt=thisMonthShipAmt+docrs.getInt(1);//當月累積出貨量
		 }		 
		 if (docrs.getString(1)!=null && ttid1.equals(previous1MonthString))
		 {
		  previous1MonthShipAmt=previous1MonthShipAmt+docrs.getInt(1); //取得前1月出貨量		  
		 }	 
		 if (docrs.getString(1)!=null && ttid1.equals(previous2MonthString))
		 {
		  previous2MonthShipAmt=previous2MonthShipAmt+docrs.getInt(1); //取得前2月出貨量		  
		 }	
		 if (docrs.getString(1)!=null && ttid1.equals(previous3MonthString))
		 {
		  previous3MonthShipAmt=previous3MonthShipAmt+docrs.getInt(1); //取得前3月出貨量		  
		 }	
	   } //end of docrs while
	   docrs.close(); 	    		   	      					   
	   
	   docstatement.close();	
	   long  t3MonShipAmt = thisMonthShipAmt+previous1MonthShipAmt+previous2MonthShipAmt+previous3MonthShipAmt;
	   if (t3MonShipAmt!= 0){ out.println(t3MonShipAmt);}
	   else {out.println("&nbsp;");}
	   //out.println(thisMonthShipAmt+previous1MonthShipAmt+previous2MonthShipAmt+previous3MonthShipAmt);
	   
	   //以下為計算total數	   
	   totalAllMonthShipAmt=totalAllMonthShipAmt+thisMonthShipAmt+previous1MonthShipAmt+previous2MonthShipAmt+previous3MonthShipAmt;  	       	   
	   totalThisMonthShipAmt=totalThisMonthShipAmt+thisMonthShipAmt;
	   totalPrevious1MonthShipAmt=totalPrevious1MonthShipAmt+previous1MonthShipAmt;
	   totalPrevious2MonthShipAmt=totalPrevious2MonthShipAmt+previous2MonthShipAmt;
	   totalPrevious3MonthShipAmt=totalPrevious3MonthShipAmt+previous3MonthShipAmt;
    } //end of try
    catch (Exception e)
    {
      out.println("Exception:"+e.getMessage());
    }	   
  %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <% if (previous3MonthShipAmt!=0){out.println(previous3MonthShipAmt); }
	                                                      else {out.println("&nbsp;"); }
	                                               %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <% if (previous2MonthShipAmt!=0){out.println(previous2MonthShipAmt); }
	                                                      else {out.println("&nbsp;"); }
	                                                 %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <% if (previous1MonthShipAmt!=0){out.println(previous1MonthShipAmt); }
	                                                     else {out.println("&nbsp;"); }
	                                                %>
          </font></div></td>
      <td bgcolor="#FFFFCC"><div align="right"><strong><font color="#0000FF" size="2"> 
          <% if (thisMonthShipAmt!=0){out.println(thisMonthShipAmt); }
	                                                 else {out.println("&nbsp;"); }
											    %>
          </font></strong></div></td>
      <td bgcolor="#FFFFCC"><div align="right"><strong><font color="#0000FF" size="2"> 
          <%
    try
    {  
	  Statement docstatement=bpcscon.createStatement();
      ResultSet docrs=docstatement.executeQuery("SELECT abs(SUM(TQTY)),TTDTE FROM ITH WHERE TRIM(TPROD)='"+fmItem+"' and trim(TTYPE) in ('B','RM') and TTDTE in ("+thisDayString+","+previous1DayString+","+previous2DayString+","+previous3DayString+","+previous4DayString+","+previous5DayString+","+previous6DayString+") and TWHS in (52,71,72,73) group by TTDTE");
	   while (docrs.next()) 
	   {	     	 		   			
		 if (docrs.getString(1)!=null && thisDayString.equals(docrs.getString(2)) ) 
		 {		 
		   thisDayShipAmt=docrs.getInt(1);//當日出貨量
		 }  
		 
		 if (docrs.getString(1)!=null && previous1DayString.equals(docrs.getString(2)) ) 
		 {		 
		   previous1DayShipAmt=docrs.getInt(1);//前1日出貨量
		 }  
		 
		 if (docrs.getString(1)!=null && previous2DayString.equals(docrs.getString(2)) ) 
		 {		 
		   previous2DayShipAmt=docrs.getInt(1);//前2日出貨量
		 } 
		 
		 if (docrs.getString(1)!=null && previous3DayString.equals(docrs.getString(2)) ) 
		 {		 
		   previous3DayShipAmt=docrs.getInt(1);//前3日出貨量
		 } 
		 
		 if (docrs.getString(1)!=null && previous4DayString.equals(docrs.getString(2)) ) 
		 {		 
		   previous4DayShipAmt=docrs.getInt(1);//前4日出貨量
		 } 
		 
		 if (docrs.getString(1)!=null && previous5DayString.equals(docrs.getString(2)) ) 
		 {		 
		   previous5DayShipAmt=docrs.getInt(1);//前5日出貨量
		 } 
		 
		 if (docrs.getString(1)!=null && previous6DayString.equals(docrs.getString(2)) ) 
		 {		 
		   previous6DayShipAmt=docrs.getInt(1);//前6日出貨量
		 } 
	   } //end of docrs while
	   docrs.close();	  	 	   
	   docstatement.close();	   
	   if (thisDayShipAmt != 0) {out.println(thisDayShipAmt); }
	   else {out.println("&nbsp;");}
	   //out.println(thisDayShipAmt); 
	   
	   //計算total數
	   totalThisDayShipAmt=totalThisDayShipAmt+thisDayShipAmt;
	   totalPrevious1DayShipAmt=totalPrevious1DayShipAmt+previous1DayShipAmt;
	   totalPrevious2DayShipAmt=totalPrevious2DayShipAmt+previous2DayShipAmt; 
	   totalPrevious3DayShipAmt=totalPrevious3DayShipAmt+previous3DayShipAmt;
	   totalPrevious4DayShipAmt=totalPrevious4DayShipAmt+previous4DayShipAmt;
	   totalPrevious5DayShipAmt=totalPrevious5DayShipAmt+previous5DayShipAmt;
	   totalPrevious6DayShipAmt=totalPrevious6DayShipAmt+previous6DayShipAmt;
    } //end of try
    catch (Exception e)
    {
      out.println("Exception:"+e.getMessage());
    }	   
  %>
          </font></strong></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <% if (previous1DayShipAmt!=0){out.println(previous1DayShipAmt); }
	                                                      else {out.println("&nbsp;"); }
	                                                %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <% if (previous2DayShipAmt!=0){out.println(previous2DayShipAmt); }
	                                                      else {out.println("&nbsp;"); } 
												    %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <% if (previous3DayShipAmt!=0){out.println(previous3DayShipAmt); }
	                                                      else {out.println("&nbsp;"); } 
	                                               %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <% if (previous4DayShipAmt!=0){out.println(previous4DayShipAmt); }
	                                                      else {out.println("&nbsp;"); } 
	                                               %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <% if (previous5DayShipAmt!=0){out.println(previous5DayShipAmt); }
	                                                      else {out.println("&nbsp;"); } 
	                                               %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <% if (previous6DayShipAmt!=0){out.println(previous6DayShipAmt); }
	                                                      else {out.println("&nbsp;"); } 
	                                               %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2"> 
          <%
    try
    {  
	  Statement docstatement=bpcscon.createStatement();
      ResultSet docrs=docstatement.executeQuery("SELECT abs(SUM(TQTY)) FROM ITH WHERE TRIM(TPROD)='"+fmItem+"' and trim(TTYPE) in ('S','SR')  and TWHS in (52)");
	   while (docrs.next()) 
	   {	 
	     if (docrs.getString(1)!=null) 
		 {		 
		   sampleOut=docrs.getInt(1);//樣品領出量
		 }		  
	   } //end of docrs while
	   docrs.close(); 	  	    		   	  					   
	   
	   docstatement.close();	   
	   if (sampleOut!=0){out.println(sampleOut);}
	   else {out.println("&nbsp;");}
	   //out.println(sampleOut);
	   totalSampleOut=totalSampleOut+sampleOut;  	       	   
    } //end of try
    catch (Exception e)
    {
      out.println("Exception:"+e.getMessage());
    }	   
  %>
          </font></div></td>
    </tr>
    <%
       rs1__index++;
       rs_hasData = rs.next();
     }
	 rs.close();
	 statement.close();
   } //end of try
   catch (Exception e)
   {
       out.println("Exception:"+e.getMessage());
   }   
 %>
    <tr bordercolor="#000000"> 
      <td colspan="3"><div align="right"><font color="#800040" size="2"><strong>Total</strong></font></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalPreviousDayBalance!=0){out.println(totalPreviousDayBalance); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                            %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalThisDayIn!=0){out.println(totalThisDayIn); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                            %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalThisDayOut!=0){out.println(totalThisDayOut); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                            %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalThisDayBalance!=0){out.println(totalThisDayBalance); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                            %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalAllMonthShipAmt!=0){out.println(totalAllMonthShipAmt); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                            %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalPrevious3MonthShipAmt!=0){out.println(totalPrevious3MonthShipAmt); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                           %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalPrevious2MonthShipAmt!=0){out.println(totalPrevious2MonthShipAmt); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                           %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalPrevious1MonthShipAmt!=0){out.println(totalPrevious1MonthShipAmt); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                           %>
          </font></strong></div></td>
      <td bgcolor="#FFFFCC"><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalThisMonthShipAmt!=0){out.println(totalThisMonthShipAmt); }
	                                                                                                                  else {out.println("&nbsp;"); } 
	                                                                                                            %>
          </font></strong></div></td>
      <td bgcolor="#FFFFCC"><div align="right"><strong><font size="2"><font color="#800040"> 
          <% if (totalThisDayShipAmt!=0){out.println(totalThisDayShipAmt); }
	                                                                                                                                                          else {out.println("&nbsp;"); } 
	                                                                                                                                                     %>
          </font></font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalPrevious1DayShipAmt!=0){out.println(totalPrevious1DayShipAmt); }
	                                                                                  else {out.println("&nbsp;"); } 
	                                                                           %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalPrevious2DayShipAmt!=0){out.println(totalPrevious2DayShipAmt); }
	                                                                                 else {out.println(" &nbsp;"); } 
	                                                                           %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalPrevious3DayShipAmt!=0){out.println(totalPrevious3DayShipAmt); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                           %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalPrevious4DayShipAmt!=0){out.println(totalPrevious4DayShipAmt); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                            %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalPrevious5DayShipAmt!=0){out.println(totalPrevious5DayShipAmt); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                            %>
          </font></strong></div></td>
      <td><div align="right"><strong><font color="#800040" size="2"> 
          <% if (totalPrevious6DayShipAmt!=0){out.println(totalPrevious6DayShipAmt); }
	                                                                                 else {out.println("&nbsp;"); } 
	                                                                            %>
          </font></strong></div></td>
      <td><div align="right"><font size="2"><strong><font color="#800040"> 
          <%  if (totalSampleOut!=0){out.println(totalSampleOut); }
	                                                                                                                          else {out.println("&nbsp;"); } 
	                                                                                                                    %>
          </font></strong></font></div></td>
    </tr>
  </table>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>