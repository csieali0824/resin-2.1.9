<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,RsCountBean,ComboBoxBean,MiscellaneousBean" %>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsCountBean" scope="page" class="RsCountBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDbtelPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>業務員地區銷售業績達成率報表</title>
</head>

<body>

<%
try {
	String sarea = request.getParameter("SAREA");
	String sales = request.getParameter("SALES");
	if (sarea==null) sarea="--";
	if (sales==null) sales="--";

	String ym []={"","","","","","","","","","","",""};
	float aQuote[] = {0,0,0,0,0,0,0,0,0,0,0,0}; //額度
	float aOrder[] = {0,0,0,0,0,0,0,0,0,0,0,0}; //訂單
	float aShip[] = {0,0,0,0,0,0,0,0,0,0,0,0}; //出貨
	float aRec[] = {0,0,0,0,0,0,0,0,0,0,0,0}; //收款
    String aSQuote[] = {"0","0","0","0","0","0","0","0","0","0","0","0"}; //額度
	String aSOrder[] = {"0","0","0","0","0","0","0","0","0","0","0","0"};  //訂單
	String aSShip[] = {"0","0","0","0","0","0","0","0","0","0","0","0"}; //出貨
	String aSRec[] = {"0","0","0","0","0","0","0","0","0","0","0","0"};; //收款
	//float a1[] = {0,0,0,0,0,0,0,0,0,0,0,0}; //訂單達成率
	//float a2[] = {0,0,0,0,0,0,0,0,0,0,0,0}; //出貨達成率
	//float a3[] = {0,0,0,0,0,0,0,0,0,0,0,0}; //收款達成率
	miscellaneousBean.setRoundDigit(2);
	int idx=0;
	
	//處理日期
	dateBean.setAdjMonth(-11);
	String dateFr = dateBean.getYearString()+dateBean.getMonthString()+"01"; //out.println("<br>"+"Date from:"+dateFr);
	ym[0] = dateBean.getYearString()+dateBean.getMonthString(); //out.println("<br>"+"ym0:"+ym[0]);
	for (int i=1;i<ym.length;i++) {
		dateBean.setAdjMonth(+1);
		ym[i] = dateBean.getYearString()+dateBean.getMonthString(); //out.println("<br>"+"ym"+i+":"+ym[i]);
	}
	String dateTo = dateBean.getYearString()+dateBean.getMonthString()+"31"; //out.println("<br>"+"Date to:"+dateTo);
%>
<%
	//處理幣別及匯率
	//先找有幾個幣別
	Statement stCurr=ifxDbtelcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
	ResultSet rsCurr=stCurr.executeQuery("SELECT CURCDE,CURDSC FROM GCM ORDER BY curcde ");
	rsCountBean.setRs(rsCurr); //out.println("<br>"+rsCountBean.getRsCount());
	String aCurr[][] = new String [rsCountBean.getRsCount()][2];	// 有幾個幣別
	float aRate[][]=new float[rsCountBean.getRsCount()][12]; // 每個幣別對美金有12個月的匯率
	int ntd = 0;
	for (int i=0;i<aCurr.length;i++) {
		aCurr[i][0]=rsCurr.getString("CURCDE"); //out.println("<br>"+rsCurr.getString("CURCDE"));
		aCurr[i][1]=rsCurr.getString("CURDSC");
		if (aCurr[i][0].equals("NTD")) { ntd = i; } //記住NTD的index
		for (int j=0;j<aRate[i].length;j++) { if (aCurr[i][0].equals("USD")) {aRate[i][j]=1;} else {aRate[i][j]=0;} } // 將arrary歸零
		rsCurr.next(); 
	}
	rsCurr.close();
	stCurr.close();
	//分幣別找匯率, 先找外幣對台幣匯率, 將匯率乘1/美金對台幣匯率即各外幣對美金匯率
	stCurr=ifxDbtelcon.createStatement();	
	rsCurr=stCurr.executeQuery("select c.CCNVFC,c.CCNVDT from gcc c "
	+" where c.GCCID='CC' and c.CCRTYP='SPOT' and c.CCFRCR='USD' and c.CCTOCR='"+aCurr[ntd][0]+"' "
	+" and c.CCNVDT between "+dateFr+" AND "+dateTo+" ORDER BY c.ccnvdt");
	while (rsCurr.next()) {
		idx=-1;
		for (int i=0;i <ym.length;i++)  {
		   if (rsCurr.getString("CCNVDT").substring(0,6).equals(ym [i]) ) {idx=i;break;}
		} // end for
		if (idx==-1) {
		} else {
			aRate[ntd][idx] = 1/rsCurr.getFloat("CCNVFC");
		} // end if
	} // end while
	rsCurr.close();
	stCurr.close();

	for (int k=0;k<aCurr.length;k++) {		
		if (aCurr[k][0].equals("NTD") || aCurr[k][0].equals("USD")) {//台幣及美金不處理
		} else {
			stCurr=ifxDbtelcon.createStatement();
			rsCurr=stCurr.executeQuery("select c.CCNVFC,c.CCNVDT from gcc c "
			+" where c.GCCID='CC' and c.CCRTYP='SPOT' and c.CCFRCR='"+aCurr[k][0]+"' and c.CCTOCR='NTD' "
			+" and c.CCNVDT between "+dateFr+" AND "+dateTo+" ORDER BY c.ccnvdt");
			while (rsCurr.next()) {
				if (Integer.parseInt(rsCurr.getString("CCNVDT").substring(6,8))<=10) { //取上旬匯率
					idx=-1;
					for (int i=0;i <ym.length;i++)  {
					   if (rsCurr.getString("CCNVDT").substring(0,6).equals(ym [i]) ) {idx=i;break;}
					} // end for
					if (idx==-1) {
					} else {
						aRate[k][idx] = rsCurr.getFloat("CCNVFC")*aRate[ntd][idx]; //乘台幣對美金匯率
					} // end if
				} // end if
			} // end while
			rsCurr.close();
			stCurr.close();
		} // end if-else
	} // end for
	

%>
<form action="../jsp/SASalesQuotaAnalysisRpt.jsp" method="post" name="MYFORM">
<font color="#54A7A7" size="+2" face="Arial Black"><strong><em>DBTEL</em></strong></font>
<strong><font color="#000000" size="+2">業務員地區銷售業績達成率報表</font></strong>
<A HREF="/wins/WinsMainMenu.jsp">回首頁</A>  
<table width="100%">
	<tr>
		
      <td><font color="#330099" face="Arial Black">Sales Area</font> 
        <% 
		 
		 // Statement statement=ifxDbtelcon.createStatement();  // 正式區
		 Statement statement=ifxTestCon.createStatement();    // 測試區
         ResultSet rs=null;
		  
		 String  SAREA="";		 		 
	     try
         {   
		      String sSql = "";
		      String sWhere = "";
		      sSql ="select distinct  trim(a.BUSI)||trim(a.DEPT) as DEPT,trim(a.BUSI)||trim(a.DEPT)||' ('||d.SVLDES||')'  from ac3 a,gsvbu b,gsvdept d ";
		      sWhere ="where a.BUSI !='' and a.DEPT !='' and a.BUSI=b.SVSGVL and a.DEPT=d.SVSGVL "+
		                     "and a.BUSI IN('0','1') and a.DEPT IN('09','13')";		 
		      sSql = sSql+sWhere;		  
		  		      
		      rs=statement.executeQuery(sSql);
		  
		      out.println("<select NAME='SAREA' onChange='setSubmit("+'"'+"../jsp/sasalesquotaanalysisrpt.jsp"+'"'+")'>");
		      out.println("<OPTION VALUE=-->ALL");     
		      while (rs.next())
		        {            
		          String s1=(String)rs.getString(1); 
		          String s2=(String)rs.getString(2); 
                        
		          if (s1.equals(sarea)) 
  		          {
                     out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
                  } else {
                     out.println("<OPTION VALUE='"+s1+"'>"+s2);
                  }        
		        } //end of while
		      out.println("</select>"); 	  		  		  
		      rs.close();   
			  statement.close();     	 
         } //end of try		 
         catch (Exception e) { out.println("Exception:"+e.getMessage()); }
       %>
      </td>
		
      <td><font color="#330099" face="Arial Black">Sales ID 
        <% 
		 String SALES="";		 		 
	     try
           {   
		     String sql = "";
		     String sWhere = "";		  
             
			 sql ="select SSAL as SALES,SSAL||' ('||SNAME||')'  from SSM ";
			 sWhere ="where SMFAXN !='' and SID = 'SM' and trim(SZIP)='"+sarea+"'  and SZIP !='' ";
		     sql = sql+sWhere;
		     //out.println(sSql);
			// PreparedStatement psState=ifxDbtelcon.prepareStatement(sql);  // 正式區
			PreparedStatement psState=ifxTestCon.prepareStatement(sql); // 測試區
			ResultSet rs1=psState.executeQuery();           
		  
		     out.println("<select NAME='SALES' >");
		     out.println("<OPTION VALUE=-->--");     
		     while (rs1.next())
		       {            
		          String s1=(String)rs1.getString(1); 
		          String s2=(String)rs1.getString(2); 
                        
		          if (s1.equals(sales)) 
		           {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
		           } else {
                      out.println("<OPTION VALUE='"+s1+"'>"+s2);
                  }        
		       } //end of while
		     out.println("</select>"); 	  		  		  
       
             rs1.close();      
			 psState.close();  	 
           } //end of try
	     catch (Exception e) {out.println("Exception:"+e.getMessage());	}
      %>
        </font> </td>
		<td><input type="submit" value="查詢"></td>
	</tr>
</table>
<table border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF" width="100%">
<tr><td colspan="14" align="right" bgcolor="#CCFFFF"><font size="-1" color="#FF0000">BASE CURRENCY :K/USD</font></td></tr>
<tr>
	<td width="11%" bgcolor="#CCCCFF"><font size="-1">SALES</font></td>
	<td width="9%" bgcolor="#CCCCFF" nowrap><font size="-1">項目</font></td>
	
	<% 
		for (int i=0;i<ym.length;i++) { %><td bgcolor="#FFFFCC" nowrap><font size="-1"><%out.println(ym[i].substring(0,4)+"/"+ym[i].substring(4,6)); %></font></td><%}
	%>
</tr>
<%
	for (int i=0;i<aCurr.length;i++) {
	//	out.println("<tr>");
	//	out.println("<td><font size='-2'>"+aCurr[i][0]+aCurr[i][1]+"</font></td>");
	//	out.println("<td><font size='-2'>USD</font></td>");
		for (int j=0;j<aRate[i].length;j++) {
   //		out.println("<td><font size='-2'>"+aRate[i][j]+"</font></td>");
		}
	//	out.println("</tr>");
	}
%>
<%

		   	// Statement state=ifxDbtelcon.createStatement(); // 正式區
			Statement state=ifxTestCon.createStatement();  // 測試區
			String sqlSales="select SSAL as SALESNO,SMFAXN[2,7] as SALESID,SNAME AS SNAME  from ssm ";
			String sWhereSales="where SID='SM' and SMFAXN !='' and SZIP != '' ";
				              
			if (sarea==null || sarea.equals("--")) {   sWhereSales = sWhereSales + "and SZIP !=  'ALL'  "; }
			else { sWhereSales =sWhereSales + "and SZIP=  '"+sarea+"'  ";}		 		  
			if ( sales==null || sales.equals("--")) { sWhereSales = sWhereSales + "and SSAL != 0  ";}
			else { sWhereSales= sWhereSales +  "and SSAL= '"+sales+"'  "; }
			String sOrder = "ORDER BY SSAL";
			sqlSales =sqlSales+ sWhereSales+sOrder;
										  		   		
			PreparedStatement psSales=ifxDbtelcon.prepareStatement(sqlSales);
			ResultSet rsSales=psSales.executeQuery();
			while (rsSales.next()) {

/*
	//取出有定額度的業務員
	String salesString = "";
	String sql = "select DISTINCT FSALES from PSALES_HIRECHY_SQUOTA q1"
	+" where q1.FPYEAR||q1.FPMONTH between "+ym[0]+" AND "+ym[11]
	+" and q1.FPMVER = "
	+"(select MAX(q2.FPMVER) from  PSALES_HIRECHY_SQUOTA q2 "
	+" where q1.FSALES=q2.FSALES "+" and  q1.FPYEAR||q1.FPMONTH =q2.FPYEAR||q2.FPMONTH "
	+" AND q2.FPYEAR||q2.FPMONTH between "+ym[0]+" AND "+ym[11]+")";
	PreparedStatement ps = con.prepareStatement(sql);
	ResultSet rs=ps.executeQuery();
	while (rs.next()) { 
		if (salesString=="") { 
			salesString = salesString +"'"+ rs.getString("FSALES")+"'"; 
		} else {
			salesString = salesString +",'"+ rs.getString("FSALES")+"'";
		} // end if-else
	} // end while
	//out.println("<br>"+salesString);
	rs.close();
	ps.close();

	String sqlSales = "select SSAL as SALESNO,SMFAXN[2,7] as SALESID,SNAME AS SNAME  from ssm "
	+" where SID='SM' AND SMFAXN[2,7] IN ("+salesString+") ORDER BY SSAL";
	//out.println("<br>"+sqlSales);
	PreparedStatement psSales=ifxDbtelcon.prepareStatement(sqlSales);
	ResultSet rsSales=psSales.executeQuery();
	while (rsSales.next()) {
	*/
%>
<tr>
	<td rowspan="7" align="center">
		<table width="100%" height="100%" align="center">
			<tr align="center"><td nowrap><font size="-1">代號</font></td><td nowrap><font size="-1"><%=rsSales.getString("SALESNO")%></font></td></tr>
			<tr align="center"><td nowrap><font size="-1">工號</font></td><td nowrap><font size="-1"><%=rsSales.getString("SALESID")%></font></td></tr>
			<tr align="center"><td nowrap><font size="-1">姓名</font></td><td nowrap><font size="-1"><%=rsSales.getString("SNAME")%></font></td></tr>
		</table>
	</td>
	<td nowrap><font size="-1">額度</font></td>
	<%
		//計算額度金額
		for (int i=0;i<aQuote.length;i++) aQuote[i] = 0;
		String sqlQuote = "select q1.FPYEAR||q1.FPMONTH as FDATE,q1.FSQUOTA as QUOTA from PSALES_HIRECHY_SQUOTA q1"
		+" where q1.FPYEAR||q1.FPMONTH between "+ym[0]+" AND "+ym[11]+" AND q1.FSALES='"+rsSales.getString("SALESID")+"'"
		+" and q1.FPMVER = "
		+"(select MAX(q2.FPMVER) from  PSALES_HIRECHY_SQUOTA q2 "
		+" where q1.FSALES=q2.FSALES "+" and  q1.FPYEAR||q1.FPMONTH =q2.FPYEAR||q2.FPMONTH "
		+" AND q2.FPYEAR||q2.FPMONTH between "+ym[0]+" AND "+ym[11]+" AND q2.FSALES='"+rsSales.getString("SALESID")+"')";
		PreparedStatement psQuote = con.prepareStatement(sqlQuote);
		ResultSet rsQuote = psQuote.executeQuery();
		while (rsQuote.next()) {
			idx=-1;
			for (int i=0;i <ym.length;i++)  {
			   if (rsQuote.getString("FDATE").equals(ym [i]) ) {
				  idx=i;
				  break;
			   }
			} // end for
			if (idx==-1) {
			} else {
				aQuote[idx] = aQuote[idx] + rsQuote.getFloat("QUOTA");
			} // end if
		
		} // end while
		rsQuote.close();
		psQuote.close();
		for (int i=0;i<aQuote.length;i++) {%><td><font size="-1"><%out.println((int) aQuote[i]); } %></font></td>
</tr>
<tr>
	<td nowrap><font size="-1">訂單金額</font></td>
	<%
		//計算訂單金額
		for (int i=0;i<aOrder.length;i++) aOrder[i] = 0; //歸零
		String sqlOrder="select h.HEDTE,h.HCURR,h.HDTOT as AMT from ech h,rcm r "+
		"where h.HEDTE between "+dateFr+" and "+dateTo+" and h.HCUST=r.CCUST and r.CSAL="+rsSales.getString("SALESNO");
		PreparedStatement psOrder=ifxDbtelcon.prepareStatement(sqlOrder);
		ResultSet rsOrder=psOrder.executeQuery();
		while (rsOrder.next()) { //out.println(rsOrder.getString("hedte")+" "+rsOrder.getFloat("amt"));
			idx=-1;
			for (int i=0;i <ym.length;i++)  {
			   if (rsOrder.getString("hedte").substring(0,6).equals(ym [i]) ) {
				  idx=i;
				  break;
			   }
			} // end for
			if (idx==-1) {
			} else {
				//換算對美金匯率
				float rate=0;
				for (int i=0;i<aCurr.length;i++) {
					if (rsOrder.getString("HCURR").equals(aCurr[i][0])) { rate = aRate[i][idx]; break;}
				} // end for
				aOrder[idx] = aOrder[idx] + Math.round(rsOrder.getFloat("amt")*rate/1000); //取千元
			} // end if
			//換算對美金匯率
		}// end while
		rsOrder.close();
		psOrder.close();

		for (int i=0;i<12;i++) {%><td><font size="-1"><%=(int) aOrder[i] %></font></td><%}
	%>
</tr>
<tr>
	<td bgcolor="#CC0066" nowrap><font size="-1" color="#FFFFFF"><strong>訂單達成率</strong></font></td>
	<%for (int i=0;i<aQuote.length;i++) {%>
	<td><font size="-1"><% if (aQuote[i]>0) {miscellaneousBean.setRoundDigit(2);out.println(miscellaneousBean.getFloatRoundStr(aOrder[i]/aQuote[i]*100));out.println("%");} else {out.println("0.00 %");} }%></font>
	</td>
</tr>
<tr>
	<td nowrap><font size="-1">出貨金額</font></td>
	<%
		//計算出貨金額
		for (int i=0;i<aShip.length;i++) aShip[i] = 0; //歸零
        String sqlShip="select h.SIINVD,h.SICURR,h.SITOT as AMT  from sih h,rcm r "+
		"where h.SIINVD between "+dateFr+" and "+dateTo+" and h.SICUST=r.CCUST and r.CSAL="+rsSales.getString("SALESNO");
		PreparedStatement psShip=ifxDbtelcon.prepareStatement(sqlShip);
		ResultSet rsShip=psShip.executeQuery();
		while (rsShip.next()) { //out.println(rsOrder.getString("hedte")+" "+rsOrder.getFloat("amt"));
			idx=-1;
			for (int i=0;i <ym.length;i++)  {
			   if (rsShip.getString("SIINVD").substring(0,6).equals(ym [i]) ) {
				  idx=i;
				  break;
			   }
			} // end for
			if (idx==-1) {
			} else {
				//換算對美金匯率
				float rate=0;
				for (int i=0;i<aCurr.length;i++) {
					if (rsShip.getString("SICURR").equals(aCurr[i][0])) { rate = aRate[i][idx]; break;}
				} // end for
				aShip[idx] = aShip[idx] + Math.round(rsShip.getFloat("AMT")*rate/1000); //取千元
			} // end if
			//換算對美金匯率
		}// end while
		rsShip.close();
		psShip.close();

		for (int i=0;i<12;i++) {%><td><font size="-1"><%=(int) aShip[i]%></font></td><%}
	%>
</tr>
<tr>
	<td  bgcolor="#CC0066" nowrap><font size="-1" color="#FFFFFF"><strong>出貨達成率</strong></font></td>
	<%for (int i=0;i<aQuote.length;i++) {%>
	<td><font size="-1"><% if (aQuote[i]>0) {miscellaneousBean.setRoundDigit(2);out.println(miscellaneousBean.getFloatRoundStr(aShip[i]/aQuote[i]*100));out.println("%");} else {out.println("0.00 %");} }%></font>
	</td>

</tr>
<tr>
	<td nowrap><font size="-1">收款金額</font></td>
	<%
		//計算收款金額
		for (int i=0;i<aRec.length;i++) aRec[i] = 0; //歸零
	    String sqlRec="select a.RIDTE,a.RCURR,a.RAMT * -1 as AMT from rar a,rcm r "+
		"where a.RIDTE between "+dateFr+" and "+dateTo+" and a.rrid in('RC','RP') and a.RCUST=r.CCUST  and r.CSAL="+rsSales.getString("SALESNO");
		PreparedStatement psRec=ifxDbtelcon.prepareStatement(sqlRec);
		ResultSet rsRec=psRec.executeQuery();
		while (rsRec.next()) { //out.println(rsRec.getString("RIDTE")+" "+rsRec.getFloat("amt"));
			idx=-1;
			for (int i=0;i <ym.length;i++)  {
			   if (rsRec.getString("RIDTE").substring(0,6).equals(ym [i]) ) {
				  idx=i;
				  break;
			   }
			} // end for
			if (idx==-1) {
			} else {
				//換算對美金匯率
				float rate=0;
				for (int i=0;i<aCurr.length;i++) {
					if (rsRec.getString("RCURR").equals(aCurr[i][0])) { rate = aRate[i][idx]; break;}
				} // end for
				aRec[idx] = aRec[idx] + Math.round(rsRec.getFloat("amt")*rate/1000); //取千元
			} // end if
			//換算對美金匯率
		}// end while
		rsRec.close();
		psRec.close();

		for (int i=0;i<12;i++) {%><td><font size="-1"><%=(int) aRec[i]%></font></td><%}
	%>
</tr>
<tr>	
	<td bgcolor="#CC0066" nowrap><font size="-1" color="#FFFFFF"><strong>收款達成率</strong></font></td>
	<%for (int i=0;i<aQuote.length;i++) {%> 
	<td><font size="-1"><% if (aQuote[i]>0) {miscellaneousBean.setRoundDigit(2); out.println(miscellaneousBean.getFloatRoundStr(aRec[i]/aQuote[i]*100));out.println("%");} else {out.println("0.00 %");} }%></font>
	</td>

</tr>
<%

	} // end while
	rsSales.close();
	psSales.close();
//*/
%>
</table>
</form>
<%
} catch (Exception ee) {
	out.println("Exception:"+ee.getMessage());
%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDbtelPage.jsp"%>
<%
} // end try-catch
%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDbtelPage.jsp"%>