<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.sql.*,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnREPAIRPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>BCpageByModelDb.jsp</title>
</head>
<body topmargin="0">
<jsp:useBean id='dateBean' scope='page' class='DateBean' />
<%
  String Day1="01";
  String Day31="31";
  String jok;
  int AAA=0;
  String YOK="";
  String flag="";
  int Month=dateBean.getMonth();
  int Day=dateBean.getDay();

  String MODEL=request.getParameter("MODEL");
  String YEARFR=request.getParameter("YEARFR");
  String MONTHFR=request.getParameter("MONTHFR");
  int Y=Integer.parseInt(YEARFR);//得到上一頁傳來的值轉數字
  int j=Integer.parseInt(MONTHFR);//得到上一頁傳來的值轉數字
    if(j<10){	//轉數字後-1在轉字串
			jok="0"+(j-1);
			  if(jok.equals("00")){//out.print("ffffffffffffffffffffffffffffffffffffffffffffff");
			     jok="12";
				 AAA=Y-1;
				 YOK=Integer.toString(AAA);
				 flag="OK";
			   }
		  }else{
			jok=String.valueOf(j-1);
		  }

  float wtotal=0;
  float rtotal=0;
  float ttotal=0;
  float total3=0;
  float ttotal3=0;
  float total12=0;
  float ttotal12=0;
  float totalAP=0;
  float ttotalAP=0;
  /*out.print("Month:"+Month+"<br>");
  out.print("Day:"+Day+"<br>");
  out.print("j:"+j+"<br>");
  out.print("分子rtotal:"+rtotal+"<br>");
  out.print("分母jok:"+jok+"<br>");
  out.print("Day1:"+Day1+"<br>");
  out.print("Day31:"+Day31+"<br>");
  out.print("AAA:"+AAA+"<br>");
  out.print("YOK:"+YOK+"<br>");*/

%>
<table width="100%" border="0">
  <tr><td><strong><font size="+2"><%=MODEL%>:退貨比率(<%=YEARFR%>年<%=MONTHFR%>月)</font></strong><BR></td>
      <td><div align="right"><strong></strong></div></td>
  </tr>
</table>  	  
<table width="100%" border="0">
  <tr>
    <td width="44%" height="24"> <font size="-1" >	
      <%  
	    try
       {     
			if(MODEL==null || MODEL.equals("--")){
             
            if(flag.equals("OK")){//out.print("33333333333333333333333333333333333333");
			String sSqlTP = "select count(imei)wtotal from wsship_imei_t a,WSMODEL_ITEM_T b where substr(shippno,6,8)>='"+YOK+jok+Day1+"' and substr(shippno,6,8)<='"+YOK+jok+Day31+"' and  shp_notes is null  ";
			//out.print(sSqlTP+"<br>");
            Statement stment=con.createStatement();
            ResultSet rsRCTP = stment.executeQuery(sSqlTP);
			//String total = "";
			if(rsRCTP.next())
			{
			   wtotal =rsRCTP.getInt("wtotal");
			   //out.print("分母wtotal:"+wtotal+"<br>");
			}

			rsRCTP.close();
			stment.close();
			
			/////////////////////////////////////////////////////////////////////////
			String sSql = "select count(repno)rtotal from RPREPAIR  where substr(recdate,1,6)='"+YEARFR+MONTHFR+"' ";
			//out.print(sSql+"<br>");
            Statement stment2=conREPAIR.createStatement();
            ResultSet rs = stment2.executeQuery(sSql);
			//String total = "";
			if(rs.next())
			{
			   rtotal =rs.getInt("rtotal");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}

			rs.close();
			stment2.close();
			
			ttotal=rtotal/wtotal;
			ttotal=ttotal*100;;
			//out.print("ttotal:"+ttotal+"%");
			
			}else{//out.print("4444444444444444444444444444444"); 
			
			String sSqlTP = "select count(imei)wtotal from wsship_imei_t a,WSMODEL_ITEM_T b where substr(shippno,6,8)>='"+YEARFR+jok+Day1+"' and substr(shippno,6,8)<='"+YEARFR+jok+Day31+"' and  shp_notes is null ";
			//out.print(sSqlTP+"<br>");
            Statement stment=con.createStatement();
            ResultSet rsRCTP = stment.executeQuery(sSqlTP);
			//String total = "";
			if(rsRCTP.next())
			{
			   wtotal =rsRCTP.getInt("wtotal");
			   out.print("分母wtotal444:"+wtotal+"<br>");
			}

			rsRCTP.close();
			stment.close();
			
			/////////////////////////////////////////////////////////////////////////
			String sSql = "select count(repno)rtotal from RPREPAIR where substr(recdate,1,6)='"+YEARFR+MONTHFR+"' ";
			//out.print(sSql+"<br>");
            Statement stment2=conREPAIR.createStatement();
            ResultSet rs = stment2.executeQuery(sSql);
			//String total = "";
			if(rs.next())
			{
			   rtotal =rs.getInt("rtotal");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			
			
			//3級
			String sSql3 = "select count(repno)total3 from RPREPAIR a,RPMODEL_ITEM_T b where substr(recdate,1,6)='"+YEARFR+MONTHFR+"'  and a.svrtypeno='001' and a.replvlno='3'";
			//out.print(sSql+"<br>");
            Statement stment3=conREPAIR.createStatement();
            ResultSet rs3 = stment3.executeQuery(sSql3);
			//String total = "";
			if(rs3.next())
			{
			   total3 =rs3.getInt("total3");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			
			
			//1,2級
			String sSql12 = "select count(repno)total12 from RPREPAIR a,RPMODEL_ITEM_T b where substr(recdate,1,6)='"+YEARFR+MONTHFR+"'  and a.svrtypeno='001' and a.replvlno in('1','2','')";
			//out.print(sSql+"<br>");
            Statement stment12=conREPAIR.createStatement();
            ResultSet rs12 = stment12.executeQuery(sSql12);
			//String total = "";
			if(rs12.next())
			{
			   total12 =rs12.getInt("total12");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			
			
			//DOA,DAP級
			String sSqlAP = "select count(repno)totalAP from RPREPAIR a,RPMODEL_ITEM_T b where substr(recdate,1,6)='"+YEARFR+MONTHFR+"'  and a.svrtypeno in('002','003')";
			//out.print(sSql+"<br>");
            Statement stmentAP=conREPAIR.createStatement();
            ResultSet rsAP = stmentAP.executeQuery(sSqlAP);
			//String total = "";
			if(rsAP.next())
			{
			   totalAP =rsAP.getInt("totalAP");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			
			

			rs.close();
			stment2.close();
			rs3.close();
			stment3.close();
			rs12.close();
			stment12.close();
			rsAP.close();
			stmentAP.close();
			
			ttotal=rtotal/wtotal;
			ttotal=ttotal*100;
			//out.print("ttotal:"+ttotal+"%");
			
			//3級
			ttotal3=total3/wtotal;
			ttotal3=ttotal3*100;
			
			//1.2級
			ttotal12=total12/wtotal;
			ttotal12=ttotal12*100;
			
			//DOA,DAP級
			ttotalAP=totalAP/wtotal;
			ttotalAP=ttotalAP*100;
			
			}//end of else
			
			
	
	 }//end of if
	else{
	
	        if(flag.equals("OK")){//out.print("1111111111111111111111111111111111111111");
			String sSqlTP = "select count(imei)wtotal from wsship_imei_t a,WSMODEL_ITEM_T b where substr(shippno,6,8)>='"+YOK+jok+Day1+"' and substr(shippno,6,8)<='"+YOK+jok+Day31+"' and  shp_notes is null and a.erp_itemno=b.ITEMNO  and  b.MODEL='"+MODEL+"' ";
			//out.print(sSqlTP+"<br>");
            Statement stment=con.createStatement();
            ResultSet rsRCTP = stment.executeQuery(sSqlTP);
			//String total = "";
			if(rsRCTP.next())
			{
			   wtotal =rsRCTP.getInt("wtotal");
			   //out.print("分母wtotal:"+wtotal+"<br>");
			}

			rsRCTP.close();
			stment.close();
			
			/////////////////////////////////////////////////////////////////////////
			String sSql = "select count(repno)rtotal from RPREPAIR a,RPMODEL_ITEM_T b where substr(recdate,1,6)='"+YEARFR+MONTHFR+"' and a.itemno=b.ITEMNO and b.MODEL='"+MODEL+"' ";
			//out.print(sSql+"<br>");
            Statement stment2=conREPAIR.createStatement();
            ResultSet rs = stment2.executeQuery(sSql);
			//String total = "";
			if(rs.next())
			{
			   rtotal =rs.getInt("rtotal");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			
			
			//3級
			String sSql3 = "select count(repno)total3 from RPREPAIR a,RPMODEL_ITEM_T b where substr(recdate,1,6)='"+YEARFR+MONTHFR+"' and a.itemno=b.ITEMNO and b.MODEL='"+MODEL+"' and a.svrtypeno='001' and a.replvlno='3'";
			//out.print(sSql+"<br>");
            Statement stment3=conREPAIR.createStatement();
            ResultSet rs3 = stment3.executeQuery(sSql3);
			//String total = "";
			if(rs3.next())
			{
			   total3 =rs3.getInt("total3");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			
			
			//1,2級
			String sSql12 = "select count(repno)total12 from RPREPAIR a,RPMODEL_ITEM_T b where substr(recdate,1,6)='"+YEARFR+MONTHFR+"' and a.itemno=b.ITEMNO and b.MODEL='"+MODEL+"' and a.svrtypeno='001' and a.replvlno in('1','2','')";
			//out.print(sSql+"<br>");
            Statement stment12=conREPAIR.createStatement();
            ResultSet rs12 = stment12.executeQuery(sSql12);
			//String total = "";
			if(rs12.next())
			{
			   total12 =rs12.getInt("total12");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			
			
			//DOA,DAP級
			String sSqlAP = "select count(repno)totalAP from RPREPAIR a,RPMODEL_ITEM_T b where substr(recdate,1,6)='"+YEARFR+MONTHFR+"' and a.itemno=b.ITEMNO and b.MODEL='"+MODEL+"' and a.svrtypeno in('002','003')";
			//out.print(sSql+"<br>");
            Statement stmentAP=conREPAIR.createStatement();
            ResultSet rsAP = stmentAP.executeQuery(sSqlAP);
			//String total = "";
			if(rsAP.next())
			{
			   totalAP =rsAP.getInt("totalAP");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			
			

			rs.close();
			stment2.close();
			rs3.close();
			stment3.close();
			rs12.close();
			stment12.close();
			rsAP.close();
			stmentAP.close();
			
			ttotal=rtotal/wtotal;
			ttotal=ttotal*100;
			//out.print("ttotal:"+ttotal+"%");
			
			//3級
			ttotal3=total3/wtotal;
			ttotal3=ttotal3*100;
			
			//1.2級
			ttotal12=total12/wtotal;
			ttotal12=ttotal12*100;
			
			//DOA,DAP級
			ttotalAP=totalAP/wtotal;
			ttotalAP=ttotalAP*100;
			
			
			}else{//out.print("2222222222222222222222222222222222");
			
			
			
			String sSqlTP = "select count(imei)wtotal from wsship_imei_t a,WSMODEL_ITEM_T b where substr(shippno,6,8)>='"+YEARFR+jok+Day1+"' and substr(shippno,6,8)<='"+YEARFR+jok+Day31+"' and  shp_notes is null and a.erp_itemno=b.ITEMNO  and  b.MODEL='"+MODEL+"' ";
			//out.print(sSqlTP+"<br>");
            Statement stment=con.createStatement();
            ResultSet rsRCTP = stment.executeQuery(sSqlTP);
			//String total = "";
			if(rsRCTP.next())
			{
			   wtotal =rsRCTP.getInt("wtotal");
			   //out.print("分母wtotal:"+wtotal+"<br>");
			}

			rsRCTP.close();
			stment.close();
			
			/////////////////////////////////////////////////////////////////////////先select上月出貨ㄉIMEI等於下面ㄉ條件(回維修系統ㄉ出跟回ㄉimei相等)
		 /*Statement statement=con.createStatement();
		 ResultSet rsimei=statement.executeQuery("select IMEI from wsship_imei_t a,WSMODEL_ITEM_T b where substr(shippno,6,8)>='"+YEARFR+jok+Day1+"' and substr(shippno,6,8)<='"+YEARFR+jok+Day31+"' and  shp_notes is null and a.erp_itemno=b.ITEMNO  and  b.MODEL='"+MODEL+"'");  
		 String imeiString = "";
		 String role = "";
		 while(rsimei.next())		 
		 {
		  if (imeiString=="")
		  {
		   imeiString=rsimei.getString("IMEI");
		  } else 
		  {		     
		    imeiString = imeiString +","+ rsimei.getString("IMEI") ;
		  }
		  //session.setAttribute("USERROLES",rolenameString);
		  out.print(imeiString);	
		 } //end of while */
			
			
			
			String sSql = "select count(repno)rtotal from RPREPAIR a,RPMODEL_ITEM_T b where substr(recdate,1,6)='"+YEARFR+MONTHFR+"' and a.itemno=b.ITEMNO and b.MODEL='"+MODEL+"'  ";
			//out.print(sSql+"<br>");
            Statement stment2=conREPAIR.createStatement();
            ResultSet rs = stment2.executeQuery(sSql);
			//String total = "";
			if(rs.next())
			{
			   rtotal =rs.getInt("rtotal");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			
			//3級
			String sSql3 = "select count(repno)total3 from RPREPAIR a,RPMODEL_ITEM_T b where substr(recdate,1,6)='"+YEARFR+MONTHFR+"' and a.itemno=b.ITEMNO and b.MODEL='"+MODEL+"' and a.svrtypeno='001' and a.replvlno='3'";
			//out.print(sSql+"<br>");
            Statement stment3=conREPAIR.createStatement();
            ResultSet rs3 = stment3.executeQuery(sSql3);
			//String total = "";
			if(rs3.next())
			{
			   total3 =rs3.getInt("total3");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			
			
			//1,2級
			String sSql12 = "select count(repno)total12 from RPREPAIR a,RPMODEL_ITEM_T b where substr(recdate,1,6)='"+YEARFR+MONTHFR+"' and a.itemno=b.ITEMNO and b.MODEL='"+MODEL+"' and a.svrtypeno='001' and a.replvlno in('1','2','')";
			//out.print(sSql+"<br>");
            Statement stment12=conREPAIR.createStatement();
            ResultSet rs12 = stment12.executeQuery(sSql12);
			//String total = "";
			if(rs12.next())
			{
			   total12 =rs12.getInt("total12");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			
			
			//DOA,DAP級
			String sSqlAP = "select count(repno)totalAP from RPREPAIR a,RPMODEL_ITEM_T b where substr(recdate,1,6)='"+YEARFR+MONTHFR+"' and a.itemno=b.ITEMNO and b.MODEL='"+MODEL+"' and a.svrtypeno in('002','003')";
			//out.print(sSql+"<br>");
            Statement stmentAP=conREPAIR.createStatement();
            ResultSet rsAP = stmentAP.executeQuery(sSqlAP);
			//String total = "";
			if(rsAP.next())
			{
			   totalAP =rsAP.getInt("totalAP");
			   //out.print("分子rtotal:"+rtotal+"<br>");
			}
			

			rs.close();
			stment2.close();
			rs3.close();
			stment3.close();
			rs12.close();
			stment12.close();
			rsAP.close();
			stmentAP.close();
			
            ttotal=rtotal/wtotal;
			//out.print("ttotal:"+ttotal+"%");
			ttotal=ttotal*100;
			
			//3級
			ttotal3=total3/wtotal;
			ttotal3=ttotal3*100;
			
			//1.2級
			ttotal12=total12/wtotal;
			ttotal12=ttotal12*100;
			
			//DOA,DAP級
			ttotalAP=totalAP/wtotal;
			ttotalAP=ttotalAP*100;
			
			//out.print("ttotal100:"+ttotal+"%");
			  }//end of else
			
			
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
      </div></td>
  </tr>
</table>
<p><table  border="0">
  <tr>
    <td bgcolor="#FFFFB3"> 計算本月退貨/上月出貨比率</td>
    <td bgcolor="#FFFFB3"><%= ttotal+"%" %></td>
  </tr>
    <tr>
    <td bgcolor="#FFFFB3">本月退貨</td>
    <td bgcolor="#FFFFB3"><%= rtotal+"件" %></td>
  </tr>
  <tr>
    <td bgcolor="#FFFFB3">上月出貨</td>
    <td bgcolor="#FFFFB3"><%= wtotal+"件" %></td>
  </tr>
    <tr>
    <td bgcolor="#FFFFB3">3級</td>
    <td bgcolor="#FFFFB3"><%= ttotal3+"%" %></td>
  </tr>
      <tr>
    <td bgcolor="#FFFFB3">1,2級</td>
    <td bgcolor="#FFFFB3"><%= ttotal12+"%" %></td>
  </tr>
        <tr>
    <td bgcolor="#FFFFB3">DOA,DOP</td>
    <td bgcolor="#FFFFB3"><%= ttotalAP+"%" %></td>
  </tr>
</table>
<A HREF="/wins/WinsMainMenu.jsp">回首頁</A> 
</p>
</body>
 <!--=============以下區段為釋放連結池==========-->
  <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
  <%@ include file="/jsp/include/ReleaseConnREPAIRPage.jsp"%>
  <!--=================================--></p>
</html>