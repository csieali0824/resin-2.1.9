<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="DateBean,java.text.DecimalFormat" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function Wopen(sModelno)
{   
  out.println("sModelno=",sModelno);
  subWin=window.open("DMShipmentStatistic.jsp?MODELNO="+sModelno,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
</script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TPE MATERIAL LOAD AND FG STATUS</title>
</head>

<body>
<font color="#000000" size="+1" face="Arial"><strong>TPE MATERIAL LOAD AND FG STATUS</strong></font> 
  <%
      String sDate="",sMCutDate="";
      String sSqlDate="SELECT mmdate as MMDATE,mmcutdate as CUTDATE FROM matestockmod";
	  PreparedStatement ptdmment=dmcon.prepareStatement(sSqlDate);
	  ResultSet rsDate=ptdmment.executeQuery();
	  if (rsDate.next()) {
	     sDate =rsDate.getString("MMDATE");
	     sDate = sDate.substring(0,4)+"/"+sDate.substring(4,6)+"/"+sDate.substring(6,8); 
		 out.println("<br><font color='#000000' size='2' face='Arial'><strong>Date : "+sDate+"</font></strong></br>");
		 sMCutDate=rsDate.getString("CUTDATE");
		 sMCutDate=sMCutDate.substring(0,4)+"/"+sMCutDate.substring(4,6)+"/"+sMCutDate.substring(6,8); 
	   }  
	  else if (sDate==null || sDate.equals("")) {
	     sDate = "沒有最後一次更新紀錄";
		 out.println("<font color='#000000' size='2' face='Arial'><strong>"+sDate+"</font></strong>");
	   }
	  ptdmment.close();
	  rsDate.close();
  %>
  
<table border='1'><tr bgcolor='#0072A8'><td width='80' height='52' valign='top'><font size='2' face='Arial' color='#FFFF00'>系列</font></td>
<td width='60' valign='top'><font size='2' face='Arial' color='#FFFF00'>MODEL</font></td>
<td width='60' valign='top'><font size='2' face='Arial' color='#FFFF00'>Material Loading(<%=sMCutDate%>)</font></td>
<td width='60' valign='top'><font size='2' face='Arial' color='#FFFF00'>Shipped Total(<%=sDate%>)</font></td>
<td width='50' valign='top'><font size='2' face='Arial' color='#FFFF00'>Sample Request Total</font></td>
<td width='57' valign='top'><font size='2' face='Arial' color='#FFFF00'>增購</font></td>
<td width='69' valign='top'><font size='2' face='Arial' color='#FFFF00'>Balance Loading</font></td>
<td width='54' valign='top'><font size='2' face='Arial' color='#FFFF00'>F/G</font></td>
<td width='50' valign='top'><font size='2' face='Arial' color='#FFFF00'>WIP</font></td>
<td width='59' valign='top'><font size='2' face='Arial' color='#FFFF00'>電子料齊套</font></td>
<td width='52' valign='top'><font size='2' face='Arial' color='#FFFF00'>電子料80%齊套</font></td>
<td width='60' valign='top'><font size='2' face='Arial' color='#FFFF00'>Balance</font></td></tr>

<%
    
	DecimalFormat df= new DecimalFormat(",000");
	
	float nMaterialLoad,nSaleQty,nSamp,nPrQty,nBalanceLoad,nFinishGood,nWip,nExQty,nTotal,nExQty1,nBalance;
	String sSql="";
	ResultSet rs;
	String sModelno="",sDesign="",sMaterialLoad="",sSaleQty="",sSamp="",sPrQty="",sBalanceLoad="",sFinishGood="",sWip="",sExQty="",sTotal="",sExQty1="",sBalance="";
	int nFirst=0;
	try
	  {
	    
		String sSqlDesign="SELECT projectcode as PROJECTCODE,designhouse as DESIGNHOUSE FROM pimaster  WHERE DESIGNHOUSE IN('DBTEL TPE','DBTEL SHH','ARES') ORDER BY designhouse DESC,projectcode";
		//out.println("sSqlDesign'"+sSqlDesign);
	    PreparedStatement ptwsment=con.prepareStatement(sSqlDesign);
		ResultSet rsDesign=ptwsment.executeQuery();
		while  (rsDesign.next()) {
		    sModelno="";sDesign="";
			sModelno=rsDesign.getString("PROJECTCODE");
			//out.println("sModelno"+sModelno);
		    sDesign=rsDesign.getString("DESIGNHOUSE");
            sDesign=sDesign.substring(0,4).trim();
			if (sDesign.equals("DBTE") ) {
			    sDesign="大霸系列";
			  }
			if (sDesign.equals("ARES")) {
			    sDesign="泓越系列";
			  }

            //out.println("sDesign"+sDesign);
		    sSql="SELECT  mmloadqty as MMLOADQTY,mmsaleqty as MMSALEQTY,mmsampqty as MMSAMPQTY,"+
	                "mmprqty as MMPRQTY,mmstockqty as MMSTOCKQTY,mmwipqty as MMWIPQTY,"+
	                "mmexqty as MMEXQTY,mmexqty1 as MMEXQTY1 FROM matestockmod WHERE mmmodelno='"+sModelno+"' ORDER BY mmmodelno ";
	        //out.println("sSql"+sSql);
		    ptdmment=dmcon.prepareStatement(sSql);
		    //out.print(sSql);
		    rs=ptdmment.executeQuery();
		    while (rs.next()) {
		          sMaterialLoad=rs.getString("MMLOADQTY");if (sMaterialLoad==null || sMaterialLoad.equals("")) {sMaterialLoad="0";}
		          nMaterialLoad=Math.round(Float.parseFloat(sMaterialLoad));
		          sSaleQty=rs.getString("MMSALEQTY");if (sSaleQty==null || sSaleQty.equals("")) {sSaleQty="0";}
		          nSaleQty=Math.round(Float.parseFloat(sSaleQty));
		          sSamp=rs.getString("MMSAMPQTY");if (sSamp==null || sSamp.equals("")) {sSamp="0";}
		          nSamp=Math.round(Float.parseFloat(sSamp));
		          sPrQty=rs.getString("MMPRQTY");if (sPrQty==null || sPrQty.equals("")) {sPrQty="0";}
		          nPrQty=Math.round(Float.parseFloat(sPrQty));
		          sFinishGood=rs.getString("MMSTOCKQTY");if (sFinishGood==null || sFinishGood.equals("")) {sFinishGood="0";}
		          nFinishGood=Math.round(Float.parseFloat(sFinishGood));
		          sWip=rs.getString("MMWIPQTY");if (sWip==null || sWip.equals("")) {sWip="0";}
		          nWip=Math.round(Float.parseFloat(sWip));
		          sExQty=rs.getString("MMEXQTY");if (sExQty==null || sExQty.equals("")) {sExQty="0";}
		          nExQty=Math.round(Float.parseFloat(sExQty));
		          sExQty1=rs.getString("MMEXQTY1");if (sExQty1==null || sExQty1.equals("")) {sExQty1="0";}
		          nExQty1=Math.round(Float.parseFloat(sExQty1));
		          if ((Float.parseFloat(sMaterialLoad) > 1000) || (Float.parseFloat(sMaterialLoad) <= -1000)) {
		             sMaterialLoad=df.format(Math.round(Float.parseFloat(sMaterialLoad)));
		             //out.println("sMaterialLoad"+sMaterialLoad);
		           }
		          else {
		             sMaterialLoad=String.valueOf(Math.round(Float.parseFloat(sMaterialLoad)));
				  }
				  //out.println("sMaterialLoad"+sMaterialLoad);
		          if (Float.parseFloat(sSaleQty) > 1000 || Float.parseFloat(sSaleQty) <= -1000) { 
		             sSaleQty=df.format(Math.round(Float.parseFloat(sSaleQty))); 
			         //out.println("sSaleQty"+sSaleQty);
			       }
		          else {
		             sSaleQty=String.valueOf(Math.round(Float.parseFloat(sSaleQty)));
			         //out.println("sSaleQty"+sSaleQty);
			       }
		          if (Float.parseFloat(sSamp) > 1000 || Float.parseFloat(sSamp) <= -1000){
		             sSamp=df.format(Math.round(Float.parseFloat(sSamp)));
			         //out.println("sSamp"+sSamp);
		           }
		          else {
		             sSamp =String.valueOf(Math.round(Float.parseFloat(sSamp)));
		             nSamp=Math.round(Float.parseFloat(sSamp));
		           }
		          if (Float.parseFloat(sPrQty) > 1000 || Float.parseFloat(sPrQty) <= -1000){
		             sPrQty=df.format(Math.round(Float.parseFloat(sPrQty)));
		           }
		          else {
		             sPrQty =String.valueOf(Math.round(Float.parseFloat(sPrQty)));
		           }
		          if (Float.parseFloat(sFinishGood) > 1000 || Float.parseFloat(sFinishGood) <=-1000) {
		             sFinishGood=df.format(Math.round(Float.parseFloat(sFinishGood)));
		           }
		          else {
		             sFinishGood=String.valueOf(Math.round(Float.parseFloat(sFinishGood)));
		           }
		          if (Float.parseFloat(sWip) > 1000 || Float.parseFloat(sWip) <= -1000) {
		            sWip=df.format(Math.round(Float.parseFloat(sWip)));
		           }
		          else {
		             sWip=String.valueOf(Math.round(Float.parseFloat(sWip)));
		           }
		          if (Float.parseFloat(sExQty) > 1000 || Float.parseFloat(sExQty) <= -1000) {
		             sExQty=df.format(Math.round(Float.parseFloat(sExQty)));
		           }
		          else {
		             sExQty=String.valueOf(Math.round(Float.parseFloat(sExQty)));
		           }
		          if (Float.parseFloat(sExQty1) > 1000 || Float.parseFloat(sExQty1) <= -1000) {
		            sExQty1=df.format(Math.round(Float.parseFloat(sExQty1)));
		           }
		          else {
		             sExQty1=String.valueOf(Math.round(Float.parseFloat(sExQty1)));
		           }
		          sBalanceLoad=String.valueOf(Math.round(nMaterialLoad-nSaleQty-nSamp+nPrQty));
		          //out.println("nBalanceLoad"+nBalanceLoad);
		          if (Float.parseFloat(sBalanceLoad) > 1000 || Float.parseFloat(sBalanceLoad) <= -1000) {
		             sBalanceLoad=df.format(Math.round(nMaterialLoad-nSaleQty-nSamp+nPrQty));
		           }
		          else {
		             sBalanceLoad=String.valueOf(Math.round(nMaterialLoad-nSaleQty-nSamp+nPrQty));
		           } 
		          //out.println("sBalanceLoad"+sBalanceLoad);
		          nBalanceLoad=Math.round(nMaterialLoad-nSaleQty-nSamp+nPrQty);
		          sBalance=String.valueOf(Math.round(nBalanceLoad-nFinishGood-nWip-nExQty-nExQty1));
		          if (Float.parseFloat(sBalance) > 1000 || Float.parseFloat(sBalance) <= -1000) {
		            sBalance=df.format(Math.round(nBalanceLoad-nFinishGood-nWip-nExQty-nExQty1));
		           }
		          //out.println("sBalance"+sBalance);

		          out.println("<tr><td width='80' height='11' align='left'><font size='2' color='#000000'>"+sDesign+"</font></td>" );
		          out.println("<td width='60' align='left'><font size='2' color='#000000'>"+sModelno+"</font></td>");
		          out.println("<td width='60' align='right'><font size='2' color='#000000'>"+sMaterialLoad+"</font></td>");
		          out.println("<td width='60' align='right'><font size='2' color='#000000'><A HREF='../jsp/DMShipmentStatistic.jsp?MODELNO="+sModelno+" '>"+sSaleQty+"</A></font></td>");
		          out.println("<td width='50' align='right'><font size='2' color='#000000'>"+sSamp+"</font></td>");
		          out.println("<td width='57' align='right'><font size='2' color='#000000'>"+sPrQty+"</font></td>");
		          out.println("<td width='69' align='right'><font size='2' color='#000000'>"+sBalanceLoad+"</font></td>");
		          out.println("<td width='54' align='right'><font size='2' color='#000000'><A HREF='../jsp/DMMaterialStatusReport.jsp?MODELNO="+sModelno+" '>"+sFinishGood+"</font></td>");
		          out.println("<td width='50' align='right'><font size='2' color='#000000'><A HREF='../jsp/DMMaterialStatusReport.jsp?MODELNO="+sModelno+" '>"+sWip+"</font></td>");
		          out.println("<td width='59' align='right'><font size='2' color='#000000'><A HREF='../jsp/DMMaterialStatusReport.jsp?MODELNO="+sModelno+" '>"+sExQty+"</font></td>");
		          out.println("<td width='52' align='right'><font size='2' color='#000000'><A HREF='../jsp/DMMaterialStatusReport.jsp?MODELNO="+sModelno+" '>"+sExQty1+"</font></td>");
		          out.println("<td width='60' align='right'><font size='2' color='#000000'>"+sBalance+"</font></td>");
		      }//end of while

		    ptdmment.close();
		    rs.close();
		  }
		ptwsment.close();
		rsDesign.close();
		
	   
	  }//end of try
	
    catch (Exception e) {
	     out.println("Exception :"+e.getMessage());
	   }
%>
</table>
  
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>