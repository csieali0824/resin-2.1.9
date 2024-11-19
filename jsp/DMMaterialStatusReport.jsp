<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,java.text.DecimalFormat" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function Wopen(sModel)
{   
	//subWin=window.open("DMStockStatusDetailReport.jsp?PRODNO="+prod,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
	subWin=window.open("DMStockStatusItemReport.jsp?MODELNO="+sModel,"subwin");  
}
</script>


<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Material Status Report</title>
</head>

<body>

<p>
  <%
  try
     {
       //取得傳入參數
	   String sModelno=request.getParameter("MODELNO");
	   if (sModelno==null || sModelno.equals("")) {sModelno="";}
%>
  <font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL </strong></font><font color="#000000" size="+2" face="Times New Roman"><strong><%=sModelno%> Stock Status Report</strong></font> 
  <%
   
      DecimalFormat df=new DecimalFormat(",000");
	  
      float nMaterialLoad,nSaleQty,nSamp,nPrQty,nBalanceLoad,nFinishGood,nWip,nExQty,nExQty1,nBalance;
      String sMdate="",sMCutDate="",sMaterialLoad="",sSaleQty="",sSamp="",sPrQty="",sBalanceLoad="",sFinishGood="",sWip="",sExQty="",sExQty1="",sBalance="";

	  if (sModelno !=null ||  !sModelno.equals(""))  {

         String sSql="SELECT mmdate,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS') AS MMDATE,mmcutdate AS CUTDATE,"+
		                    "mmloadqty as MMLOADQTY,mmsaleqty as MMSALEQTY,mmsampqty as MMSAMPQTY,"+
	                        "mmprqty as MMPRQTY,mmstockqty as MMSTOCKQTY,mmwipqty as MMWIPQTY,mmexqty as MMEXQTY,"+
					   	    "mmexqty1 as MMEXQTY1  FROM matestockmod WHERE mmmodelno='"+sModelno+"' ";
         //out.println("sSql"+sSql);
         PreparedStatement ptdmment=dmcon.prepareStatement(sSql);
         ResultSet rs = ptdmment.executeQuery();
         if (rs.next()) {
		     sMdate=rs.getString("MMDATE");
			 sMdate=sMdate.substring(0,4)+"/"+sMdate.substring(4,6)+"/"+sMdate.substring(6,8); 
			 sMCutDate=rs.getString("CUTDATE");
			 sMCutDate=sMCutDate.substring(0,4)+"/"+sMCutDate.substring(4,6)+"/"+sMCutDate.substring(6,8);
			 
	         sMaterialLoad=rs.getString("MMLOADQTY");if (sMaterialLoad==null || sMaterialLoad.equals("")) { sMaterialLoad = "0"; }
		     //out.println("sMaterialLoad"+sMaterialLoad);
	         nMaterialLoad=Math.round(Float.parseFloat(sMaterialLoad));
	         //out.println("nMaterialLoad"+nMaterialLoad); 
		     sSaleQty=rs.getString("MMSALEQTY");if (sSaleQty==null || sSaleQty.equals("")) { sSaleQty = "0"; }
		     //out.println("sSaleQty"+sSaleQty);
		     nSaleQty=Math.round(Float.parseFloat(sSaleQty));
		     //out.println("nSaleQty"+nSaleQty);
		     sSamp=rs.getString("MMSAMPQTY");if (sSamp==null || sSamp.equals("")) { sSamp = "0"; }
		     //out.println("sSamp"+sSamp);
		     nSamp=Math.round(Float.parseFloat(sSamp));
		     //out.println("nSamp"+nSamp);
		     sPrQty=rs.getString("MMPRQTY");if (sPrQty==null || sPrQty.equals("")) { sPrQty = "0"; }
		     //out.println("sPrQty"+sPrQty);
		     nPrQty=Math.round(Float.parseFloat(sPrQty));
		     //out.println("nPrQty"+nPrQty);
		     sFinishGood=rs.getString("MMSTOCKQTY");if (sFinishGood==null || sFinishGood.equals("")) { sFinishGood = "0"; }
		     //out.println("sFinishGood"+sFinishGood);
		     nFinishGood=Math.round(Float.parseFloat(sFinishGood));
		     sWip=rs.getString("MMWIPQTY");if (sWip==null || sWip.equals("")) { sWip = "0"; }
		     //out.println("sWip"+sWip);
		     nWip=Math.round(Float.parseFloat(sWip));
		     sExQty=rs.getString("MMEXQTY");if (sExQty==null || sExQty.equals("")) { sExQty = "0"; }
		     //out.println("sExQty"+sExQty);
		     nExQty=Math.round(Float.parseFloat(sExQty));
		     sExQty1=rs.getString("MMEXQTY1");if (sExQty1==null || sExQty1.equals("")) { sExQty1 = "0"; }
		     //out.println("sExQty1"+sExQty1);
		     nExQty1=Math.round(Float.parseFloat(sExQty1));
		     if ((Float.parseFloat(sMaterialLoad) > 1000) || (Float.parseFloat(sMaterialLoad) <= -1000)){
			      sMaterialLoad=df.format(Math.round(Float.parseFloat(sMaterialLoad)));
			      //out.println("sMaterialLoad"+sMaterialLoad);
			   }
		     else {
		         sMaterialLoad=String.valueOf(Math.round(Float.parseFloat(sMaterialLoad)));
			     //out.println("sMaterialLoad"+sMaterialLoad);
			  }
	         if ((Float.parseFloat(sSaleQty) > 1000) || (Float.parseFloat(sSaleQty) <= -1000)) { 
		         sSaleQty=df.format(Math.round(Float.parseFloat(sSaleQty))); 
			     //out.println("sSaleQty"+sSaleQty);
			 }
		    else {
		        sSaleQty=String.valueOf(Math.round(Float.parseFloat(sSaleQty)));
			    //out.println("sSaleQty"+sSaleQty);
			 }
		    if ((Float.parseFloat(sSamp) > 1000) || (Float.parseFloat(sSamp) <= -1000)) { 
		        sSamp=df.format(Math.round(Float.parseFloat(sSamp)));
			    //out.println("sSamp"+sSamp);
			 }
		    else {
		        sSamp =String.valueOf(Math.round(Float.parseFloat(sSamp)));
			    nSamp=Math.round(Float.parseFloat(sSamp));
			 }
		    if ((Float.parseFloat(sPrQty) > 1000)  || (Float.parseFloat(sPrQty) <= -1000)) { 
		        sPrQty=df.format(Math.round(Float.parseFloat(sPrQty)));
			    //out.println("sPrQty"+sPrQty);
			 }
		    else {
		       sPrQty =String.valueOf(Math.round(Float.parseFloat(sPrQty)));
			}
		    if ((Float.parseFloat(sFinishGood) > 1000) || (Float.parseFloat(sFinishGood) <= -1000)) { 
		       sFinishGood=df.format(Math.round(Float.parseFloat(sFinishGood)));
			 }
		    else {
		       sFinishGood=String.valueOf(Math.round(Float.parseFloat(sFinishGood)));
			 }
		    if ((Float.parseFloat(sWip) > 1000) || (Float.parseFloat(sWip) <= -1000)) { 
		       sWip=df.format(Math.round(Float.parseFloat(sWip)));
			 }
		    else {
		       sWip=String.valueOf(Math.round(Float.parseFloat(sWip)));
			 }
		    if ((Float.parseFloat(sExQty) > 1000)  || (Float.parseFloat(sExQty) <= -1000)) { 
		       sExQty=df.format(Math.round(Float.parseFloat(sExQty)));
			 }
		    else {
		       sExQty=String.valueOf(Math.round(Float.parseFloat(sExQty)));
			 }
		    if ((Float.parseFloat(sExQty1) > 1000)  || (Float.parseFloat(sExQty1) <= -1000)) { 
		       sExQty1=df.format(Math.round(Float.parseFloat(sExQty1)));
			 }
		    else {
		      sExQty1=String.valueOf(Math.round(Float.parseFloat(sExQty1)));
			 }
		    sBalanceLoad=String.valueOf(Math.round(nMaterialLoad-nSaleQty-nSamp+nPrQty));
		    nBalanceLoad=Math.round(Float.parseFloat(sBalanceLoad));
		    //out.println("nBalanceLoad"+nBalanceLoad);
		    if ((Float.parseFloat(sBalanceLoad) > 1000) || (Float.parseFloat(sBalanceLoad)  <= -1000)) {
		       sBalanceLoad=df.format(Math.round(nMaterialLoad-nSaleQty-nSamp+nPrQty));
			  }
  		    //out.println("sBalanceLoad"+sBalanceLoad);
		    sBalance=String.valueOf(Math.round(nBalanceLoad - nFinishGood - nWip - nExQty - nExQty1));
		    if ((Float.parseFloat(sBalance) > 1000) || (Float.parseFloat(sBalance) <= -1000)) {
		       sBalance=df.format(Math.round(nBalanceLoad - nFinishGood - nWip - nExQty - nExQty1));
			  }
		    //out.println("sBalance"+sBalance);

        }//end of if 
	  ptdmment.close();
	  rs.close();
	  
%>
<br><font color="#000000" size="2" face="Arial"><strong>Date : <%=sMdate%></strong></font></br>
<table width="250" border="1">
  <tr bgcolor="#0072A8"><td width="180"><font color="#FFFF00" size="2" face="Arial">Material Loading(<%=sMCutDate%>)</font></td><td width="70" align="right"><font color="#FFFF00" size="2" face="Arial"><%=sMaterialLoad%></font></td></tr>
  <tr><td><font color="#000000" size="2" face="Arial">Shipped Total</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sSaleQty%></font></td></tr>
  <tr><td><font color="#000000" size="2" face="Arial">Sample Request Total</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sSamp%></font></td></tr>
  <tr><td><font color="#000000" size="2" face="Arial">增購</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sPrQty%></font></td></tr>
  <tr><td><font color="#000000" size="2" face="Arial">Balance Loading</font></td><td align="right"\><font color="#000000" size="2" face="Arial"><%=sBalanceLoad%></font></td></tr>
  <tr><td><font color="#000000" size="2" face="Arial">F/G</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sFinishGood%></font></td></tr>
  <tr><td><font color="#000000" size="2" face="Arial">WIP</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sWip%></font></td></tr>
  <tr><td><font color="#000000" size="2" face="Arial">電子料齊套</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sExQty%></font></td></tr>
  <tr><td><font color="#000000" size="2" face="Arial">電子料80%齊套</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sExQty1%></font></td></tr>
  <tr><td><font color="#000000" size="2" face="Arial">Balance</font></td><td align="right"><font color="#000000" size="2" face="Arial "><%=sBalance%></font></td></tr>
</table>
<p><a href='javaScript:Wopen("<%=sModelno%>")'>查看明細資料</a></p>

<%
   }//end of if for modelno
     }//end of try
   catch (Exception e) {
      out.println("Exception:"+e.getMessage());
	 } 
%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>