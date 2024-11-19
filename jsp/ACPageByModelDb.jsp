<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.sql.*,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>ACpageByModelDb.jsp</title>
</head>
<body topmargin="0">
<jsp:useBean id='dateBean' scope='page' class='DateBean' />
<%
  int Month=dateBean.getMonth();
  int Day=dateBean.getDay();
  String MPROJ=request.getParameter("MPROJ");
  String YEARFR=request.getParameter("YEARFR");
  String MONTHFR=request.getParameter("MONTHFR");
  String RCTPSGet="";
  int RCTPlight=0;
  int COUNTnu=0;
%>
<table width="100%" border="0">
  <tr><td><strong><font size="+2"><%=MPROJ%>生產月報表</font></strong><BR></td>
      <td><div align="right"><strong><em>資料最後更新:<%=Month%>月<%=Day-1%>日</em></strong></div></td>
  </tr>
</table>  	  
<table width="100%" border="0">
  <tr>
    <td width="44%" height="24"> <font size="-1" >	
      <%  
	    try
       {     
			if(MPROJ==null || MPROJ.equals("--")){
			int count=31;
			String j;
			ResultSet rsRPEDTP=null;
			ResultSet rsRPED=null;
			int per=0;
			String model;
			String COUNTnu2="";
			String montherarray[]={"","1日","2日","3日","4日","5日","6日","7日","8日","9日","10日","11日","12日","13日","14日","15日","16日","17日","18日","19日","20日","21日","22日","23日","24日","25日","26日","27日","28日","29日","30日","31日"};
			Statement stmentMES=con.createStatement();
			out.println("<TABLE >");
			out.println("<body background=../image/b01.jpg>");
			out.println("<TR>");
			for(int i=1; i<=count; i++){
				if(i<10){	
				 j="0"+(i);
				}else{
				 j=String.valueOf(i);
				 }
				String sSqlTP = "select count(serial_number) as COUNT from MES_WIP_TRACKING where to_char(IN_STATION_TIME,'YYYYMMDD')='"+YEARFR+MONTHFR+j+"' and line_name='ACLINE1' and group_name='AC_PACKING' and pallet_full_flag='Y'";            
				rsRPEDTP=stmentMES.executeQuery(sSqlTP);
				if (rsRPEDTP.next())
				  {
			           COUNTnu=rsRPEDTP.getInt("COUNT");
					   COUNTnu2=COUNTnu2+"<TD align=center bgcolor=#6AE1FF nowrap><font size='-1'>"+COUNTnu+"</font></TD>";
					   per=COUNTnu/500;
					   out.println("<TD align=center valign=bottom>"+"<IMG SRC=/wins/image/100.gif Height="+per*25+" Width=15 Align=bottom>"+"</TD>");
				  }//End of if
			}//End of for
			  out.println("</TR>");
			  
			  out.println("<TR>");
			  out.println(COUNTnu2);//先把資料丟給字串變數在一次println出來
			  out.println("</TR>");
			  
				 out.println("<TR>");
			     for(int m=1; m<=31; m++)
				 {
			     out.println("<TD align=center bgcolor=#FFFFB3 nowrap><font size=-1 >"+montherarray[m]+"</font ></TD>");
                 }
				 out.println("</TR>"); 
				 
			out.println("</BODY>");	 
			out.println("</TABLE>");
			out.println("<HR>");
			
			
			
			
			out.println("<strong><font size=+2>"+"機種別生產月報表"+"</font></strong>");
			out.println("<TABLE >");
			out.println("<body>");
			String sSql ="select a.mproj as model,count(b.serial_number) as COUNT from prodmodel a,MES_WIP_TRACKING b where to_char(b.IN_STATION_TIME,'YYYYMM')='"+YEARFR+MONTHFR+"' and b.line_name='ACLINE1'and b.group_name='AC_PACKING' and b.pallet_full_flag='Y' and a.mitem=b.model_name group by a.mproj";
			rsRPED=stmentMES.executeQuery(sSql);
			while (rsRPED.next())
			{
			  out.println("<TR>");
			  model=rsRPEDTP.getString("model");
			  COUNTnu=rsRPED.getInt("COUNT");
			       //out.println("<TD align=center bgcolor=#FFFFB3 nowrap><font size='-1'>"+montherarray[i]+"</font></TD>");
				   out.println("<TD align=center bgcolor=#84FF84 nowrap><font size='-1'>"+model+"</font></TD>");
				   out.println("<TD align=center bgcolor=#6AE1FF nowrap><font size='-1'>"+COUNTnu+"</font></TD>");
				   per=COUNTnu/100;
				   out.println("<TD align=left>"+"<IMG SRC=/wins/image/100.gif Height=16 Width="+per*1+" Align=bottom>"+"</TD>");
				   out.println("</TR>");
              }//End of if
			out.println("</BODY>");	 
			out.println("</TABLE>");
			stmentMES.close();
			rsRPEDTP.close();
			rsRPED.close();
			//以上為取得每月之總數數量
			//out.println("<img src='ACMESModelChart.jsp?YEARFR="+YEARFR+"&&MONTHFR="+MONTHFR+"&&MPROJ="+MPROJ+"'>");
            }//end of if
			
			
	
	
	else{
			String sSqlTP = "select distinct MITEM from PRODMODEL where  MPROJ='"+MPROJ+"' ";
            Statement stment=con.createStatement();
            ResultSet rsRCTP = stment.executeQuery(sSqlTP);
			String RCTPString = "";
			while(rsRCTP.next())
			{
			   RCTPString =rsRCTP.getString("MITEM");
			   RCTPSGet = RCTPSGet+"'"+RCTPString+"'"+",";
			   //out.print(RCTPSGet);
			}
			 RCTPlight=RCTPSGet.length()-1;
			 RCTPSGet = RCTPSGet.substring(0, RCTPlight);
			//out.print(RCTPSGet);
			rsRCTP.close();
			stment.close();
			//以上為取得MITEM欄位丟至RCTPSGet變數
			
			int count=31;
			String j;
			ResultSet rsRPEDTP=null;
			int per=0;
			String montherarray[]={"","1日","2日","3日","4日","5日","6日","7日","8日","9日","10日","11日","12日","13日","14日","15日","16日","17日","18日","19日","20日","21日","22日","23日","24日","25日","26日","27日","28日","29日","30日","31日"};
			Statement stmentMES=con.createStatement();
			out.println("<TABLE >");
			out.println("<body background=../image/b01.jpg>");
			for(int i=1; i<=count; i++){
				if(i<10){	
				 j="0"+(i);
				}else{
				 j=String.valueOf(i);
				 }
				sSqlTP = "select count(*) as COUNT from MES_WIP_TRACKING where MODEL_NAME in("+RCTPSGet+") and to_char(IN_STATION_TIME,'YYYYMMDD')='"+YEARFR+MONTHFR+j+"' and line_name='ACLINE1' and group_name='AC_PACKING' and pallet_full_flag='Y'";            
				rsRPEDTP=stmentMES.executeQuery(sSqlTP);
				while (rsRPEDTP.next())
				  {
				  out.println("<TR>");
				   COUNTnu=rsRPEDTP.getInt("COUNT");
					   out.println("<TD align='left' bgcolor='#FFFFB3' nowrap><font size='-1'>"+montherarray[i]+"</font></TD>");
					   out.println("<TD align='left' bgcolor='#6AE1FF' nowrap><font size='-1' >"+COUNTnu+"</font></TD>");
					   per=COUNTnu/50;
					   out.println("<TD align=left>"+"<IMG SRC=/wins/image/100.gif Height=16 Width="+per*5+" Align=bottom>"+"</TD>");
					   out.println("</TR>");
				  }//End of while
			}//End of for
			  
			
			
				//out.println("<TR>");
			     //for(int k=0; k<=30; k++)
				 //{
				    //per=100/COUNTnu;
			     //out.println("<TD align=center>"+"<IMG SRC=/wins/image/100.gif Height=50 Width=10 Align=bottom>"+"</TD>");
			     //}
				 //out.println("</TR>"); 
				 
			
			//out.println("<TR>");
			     //for(int m=0; m<=30; m++)
				 //{
			     //out.println("<TD align=center bgcolor=#FFFFB3>"+montherarray[m]+"</TD>");
			     //}
				 //out.println("</TR>"); 
			out.println("</BODY>");	 
			out.println("</TABLE>");
			stmentMES.close();
			rsRPEDTP.close();
			//以上為取得每月之總數數量
	}//end of else		
	     } //End of try  
         catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());   
         }
      %>
	  </font>
	</td>
    <td width="56%"> <div align="center">
        <%
		    if (MPROJ==null || MPROJ.equals("--")){}
           //{out.println("<img src='ACMESModelChart.jsp?YEARFR="+YEARFR+"&&MONTHFR="+MONTHFR+"&&MPROJ="+MPROJ+"'>");}
	        else
	       {out.println("<img src='ACMESModelChart.jsp?YEARFR="+YEARFR+"&&MONTHFR="+MONTHFR+"&&MPROJ="+MPROJ+"'>");}
      %>
      </div></td>
  </tr>
</table>
<p><table width="26%">
  <tr>
    <td>黃色為日期</td>
    <td bgcolor="#FFFFB3">&nbsp;</td>
  </tr>
  <tr>
    <td width="50%">綠色為機種</td>
    <td bgcolor="#84FF84" width="29%">&nbsp;</td>
  </tr>
  <tr>
    <td width="50%">藍色為每日數量</td>
    <td bgcolor="#6AE1FF" width="29%">&nbsp;</td>
  </tr>
  <tr>
    <td nowrap>紅色為每日數量橫條圖</td>
    <td bgcolor="#FF0000">&nbsp;</td>
  </tr>   
</table>
</p>
</body>
 <!--=============以下區段為釋放連結池==========-->
  <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
  <!--=================================--></p>
</html>