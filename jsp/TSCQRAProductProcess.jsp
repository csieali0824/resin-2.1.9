<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSC QRA Product Notice Process</title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.QRAFORM.action=URL;
	document.QRAFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSCQRAProductProcess.jsp" METHOD="post" NAME="QRAFORM">
<%
String sql ="";
try
{
	String chk[] = request.getParameterValues("CHKBOX");	
	String chk1[]= request.getParameterValues("chk");	 //add by Peggy 20160909
	String exclude_type_list ="";    //add by Peggy 20160909
	if (chk1!=null)
	{
		for(int z=0; z< chk1.length ;z++)
		{
			exclude_type_list += ((!exclude_type_list.equals("")?",":"")+chk1[z]);
		}
	}
	String v_line="";
	int line_no =0;
	String upd_version=""; //add by Peggy 20140430
	if (chk.length >0)
	{
		String QSEQNO = request.getParameter("QSEQNO");
		if (QSEQNO==null) QSEQNO="";
		String QNO = request.getParameter("QNO");
		//if (QNO==null) QNO="";
		if (QNO==null) QNO=QSEQNO; //modify by Peggy 20140515
		String CREATIONDATE = request.getParameter("CREATIONDATE");
		if (CREATIONDATE==null) CREATIONDATE="";
		String ENDDATE = request.getParameter("ENDDATE");
		if (ENDDATE==null) ENDDATE="";
		String QTYPE = request.getParameter("QTYPE");
		if (QTYPE==null) QTYPE="";
		String SHIPFROMDATE = request.getParameter("SHIPFROMDATE");
		if (SHIPFROMDATE.equals("")) SHIPFROMDATE="";
		String SHIPTODATE = request.getParameter("SHIPTODATE");
		if (SHIPTODATE.equals("")) SHIPTODATE="";
		//String CYEARFR = request.getParameter("CYEARFR");
		//if (CYEARFR==null || CYEARFR.equals("--")) CYEARFR="2010";
		//String CMONTHFR = request.getParameter("CMONTHFR");
		//if (CMONTHFR==null || CMONTHFR.equals("--")) CMONTHFR="01";
		//String CDAYFR = request.getParameter("CDAYFR");
		//if (CDAYFR==null || CDAYFR.equals("--")) CDAYFR="01";
		//String CYEARTO = request.getParameter("CYEARTO");
		//if (CYEARTO==null || CYEARTO.equals("--")) CYEARTO=dateBean.getYearString();;
		//String CMONTHTO = request.getParameter("CMONTHTO");
		//if (CMONTHTO==null || CMONTHTO.equals("--")) CMONTHTO=dateBean.getMonthString();
		//String CDAYTO = request.getParameter("CDAYTO");
		//if (CDAYTO==null || CDAYTO.equals("--")) CDAYTO=dateBean.getDayString();
		String APPLYORGID = request.getParameter("ORGID");
		if (APPLYORGID==null) APPLYORGID="";
		String TERRITORY = request.getParameter("TERRITORY");
		if (TERRITORY==null) TERRITORY="";
		String CUSTOMER = request.getParameter("CUSTOMER");
		if (CUSTOMER==null) CUSTOMER="";
		String MARKETGROUP = request.getParameter("MARKETGROUP");
		if (MARKETGROUP==null) MARKETGROUP="";
		String MANUFACTORY = request.getParameter("MANUFACTORY");
		if (MANUFACTORY==null) MANUFACTORY="";		
		
		//String keyID="";
		
		//sql = " select to_char(trunc(sysdate),'yymmdd')||'-'||lpad((NVL(MAX(substr(keyid,7,3)),0)+1),2,'0') KEYID from oraddman.tsqra_pcn_item_header a where substr(keyid,1,6) = to_char(trunc(sysdate),'yymmdd') ";
		//Statement statement1=con.createStatement();
		//ResultSet rs1=statement1.executeQuery(sql);
		//if (rs1.next())
		//{
		//	keyID = rs1.getString(1);
		//}
		//rs1.close();
		//statement1.close();
		
		sql = "select upd_version_id from oraddman.tsqra_pcn_item_header where PCN_NUMBER=?";
		//out.println(sql);
		PreparedStatement statement1 = con.prepareStatement(sql);
		statement1.setString(1,QNO);
		ResultSet rs1=statement1.executeQuery();
		if (!rs1.next())
		{
			upd_version ="1";  //add by Peggy 20140430
			sql = " insert into oraddman.tsqra_pcn_item_header"+
				  "(PCN_NUMBER"+
				  ",sequence_id"+
				  ",pcn_type"+
				  ",pcn_creation_date"+
				  ",creation_date"+
				  ",created_by"+
				  ",last_update_date"+
				  ",last_updated_by"+
				  ",S_ACT_SHIP_DATE"+
				  ",E_ACT_SHIP_DATE"+
				  ",PCN_END_DATE"+
				  ",APPLY_ORG_ID"+
				  ",UPD_VERSION_ID"+   //add by Peggy 20140430
				  ",SALES_REGION"+   //add by Peggy 20140430
				  ",MARKET_GROUP"+   //add by Peggy 20140430
				  ",CUSTOMER_LIST"+   //add by Peggy 20140430
				  ",TSC_MANUFACTORY"+ //add by Peggy 20140430
				  ",EXCLUDE_CUSTOM_TYPE"+   //add by Peggy 20160909
				  ")"+
				  " values"+
				  "(?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?)";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,QNO.trim()); 
			pstmtDt.setString(2,QSEQNO.trim());
			pstmtDt.setString(3,QTYPE); 
			pstmtDt.setString(4,CREATIONDATE);
			pstmtDt.setString(5,UserName);
			pstmtDt.setString(6,UserName); 
			pstmtDt.setString(7,SHIPFROMDATE);
			pstmtDt.setString(8,SHIPTODATE); 
			pstmtDt.setString(9,ENDDATE);
			pstmtDt.setString(10,APPLYORGID);
			pstmtDt.setString(11,upd_version);    //add by Peggy 20140430
			pstmtDt.setString(12,TERRITORY);    //add by Peggy 20140430
			pstmtDt.setString(13,MARKETGROUP);    //add by Peggy 20140430
			pstmtDt.setString(14,CUSTOMER);    //add by Peggy 20140430
			pstmtDt.setString(15,MANUFACTORY);  //add by Peggy 20140430
			pstmtDt.setString(16,exclude_type_list);  //add by Peggy 20160909
			pstmtDt.executeQuery();
			pstmtDt.close();
		}
		else
		{
			upd_version =""+(Integer.parseInt(rs1.getString(1))+1);  //add by Peggy 20140430
			
			sql = " update oraddman.tsqra_pcn_item_header"+
				  " set last_update_date=sysdate"+
				  ",last_updated_by=?"+
				  ",UPD_VERSION_ID=?"+   //add by Peggy 20140430
				  ",SALES_REGION=?"+   //add by Peggy 20140430
				  ",MARKET_GROUP=?"+   //add by Peggy 20140430
				  ",CUSTOMER_LIST=?"+   //add by Peggy 20140430
				  ",TSC_MANUFACTORY=?"+ //add by Peggy 20140430
				  ",EXCLUDE_CUSTOM_TYPE=?"+  //add by Peggy 20160909
				  ",S_ACT_SHIP_DATE=?"+     //add by Peggy 20190315
				  ",E_ACT_SHIP_DATE=?"+     //add by Peggy 20190315
				  " where PCN_NUMBER=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,UserName);
			pstmtDt.setString(2,upd_version);  //add by Peggy 20140430
			pstmtDt.setString(3,TERRITORY);    //add by Peggy 20140430
			pstmtDt.setString(4,MARKETGROUP);    //add by Peggy 20140430
			pstmtDt.setString(5,CUSTOMER);    //add by Peggy 20140430
			pstmtDt.setString(6,MANUFACTORY);  //add by Peggy 20140430
			pstmtDt.setString(7,exclude_type_list);  //add by Peggy 20160909
			pstmtDt.setString(8,SHIPFROMDATE); //add by Peggy 20190315
			pstmtDt.setString(9,SHIPTODATE); //add by Peggy 20190315
			pstmtDt.setString(10,QNO.trim()); 
			pstmtDt.executeQuery();
			pstmtDt.close();
		}
		rs1.close();  
		statement1.close();
			
		sql = " DELETE oraddman.tsqra_pcn_item_detail a"+
              " WHERE PCN_NUMBER=? ";
		PreparedStatement pstmtDt2=con.prepareStatement(sql);
		pstmtDt2.setString(1,QNO.trim());
		pstmtDt2.executeQuery();				
		pstmtDt2.close();
			
		for(int i=0; i< chk.length ;i++)
		{
			line_no ++;
			v_line = chk[i];
			String s1 = request.getParameter("td_tscpn_"+v_line);
			if (s1==null || s1.equals("null")) s1="";
			//String s2 = request.getParameter("td_tscitemid_"+v_line);
			//if (s2==null || s2.equals("null")) s2="";
			String s3 = request.getParameter("td_territory_"+v_line);
			if (s3==null || s3.equals("null")) s3="";
			//String s4 = request.getParameter("td_custnumber_"+v_line);
			//if (s4==null || s4.equals("null")) s4="";
			String s5 = request.getParameter("td_customer_"+v_line);
			if (s5==null || s5.equals("null")) s5="";
			String s6 = request.getParameter("td_custpn_"+v_line);
			if (s6==null || s6.equals("null")) s6="";
			String s7 = request.getParameter("td_sourcetype_"+v_line);
			if (s7==null || s7.equals("null")) s7="";
			String s8 = request.getParameter("td_datecode_"+v_line);
			if (s8==null || s8.equals("null")) s8="";
			String s9 = request.getParameter("td_market_"+v_line);
			if (s9==null || s9.equals("null")) s9="";
			String s10 = request.getParameter("td_prodgroup_"+v_line);
			if (s10==null || s10.equals("null")) s10="";
			String s11 = request.getParameter("td_family_"+v_line);
			if (s11==null || s11.equals("null")) s11="";
			String s12 = request.getParameter("td_package_"+v_line);
			if (s12==null || s12.equals("null")) s12="";
			String s13 = request.getParameter("td_packingcode_"+v_line);
			if (s13==null || s13.equals("null")) s13="";
			String s14 = request.getParameter("td_amp_"+v_line);
			if (s14==null || s14.equals("null")) s14="";
			
			sql =" insert into oraddman.tsqra_pcn_item_detail"+
				 "(pcn_number"+                       //1
				 ",seqid"+                       //2
				 ",territory"+                   //3
				 //",customer_number"+             //4
				 ",cust_short_name"+             //5
				 ",cust_part_no"+                //6
				 //",inventory_item_id"+           //7
				 ",tsc_part_no"+                 //8
				 ",source_type"+                 //9
				 ",date_code"+                   //10
				 ",market_group"+                //11
				 ",tsc_prod_group"+              //12
				 ",tsc_family"+                  //13
				 ",tsc_package"+                 //14
				 ",tsc_packing_code"+            //15
				 ",tsc_amp"+                     //16
				 ",upd_version_id"+              //17
				 ",sequence_id"+                 //18,add by Peggy 20150825
				 ")"+ 
				 " select "+
				 " ?"+                            //1
				 ",nvl(max(SEQID),0)+1"+          //2
				 ",?"+                            //3
				 //",?"+                            //4
				 ",?"+                            //5
				 ",?"+                            //6
				 //",?"+                            //7
				 ",?"+                            //8
				 ",?"+                            //9
				 ",?"+                            //10
				 ",?"+                            //11
				 ",?"+                            //12
				 ",?"+                            //13
				 ",?"+                            //14
				 ",?"+                            //15
				 ",?"+                            //16
				 ",?"+                            //17
				 ",?"+                            //18
				 " from oraddman.tsqra_pcn_item_detail"+
				 " where PCN_NUMBER=?";
			PreparedStatement pstmtDtl=con.prepareStatement(sql);  
			pstmtDtl.setString(1,QNO.trim()); 
			//pstmtDtl.setString(2,""+(i+1));
			pstmtDtl.setString(2,s3.replace("N/A",""));
			//pstmtDtl.setString(3,(s4.equals("N/A")?"0":s4)); 
			pstmtDtl.setString(3,s5.replace("N/A","")); 
			pstmtDtl.setString(4,s6.replace("N/A",""));
			//pstmtDtl.setString(7,s2); 
			pstmtDtl.setString(5,s1.replace("N/A","")); 
			pstmtDtl.setString(6,(s7.equals("ERP")?"1":"2")); 
			pstmtDtl.setString(7,s8.replace("N/A","")); 
			pstmtDtl.setString(8,s9.replace("N/A","")); 
			pstmtDtl.setString(9,s10.replace("N/A","")); 
			pstmtDtl.setString(10,s11.replace("N/A","")); 
			pstmtDtl.setString(11,s12.replace("N/A","")); 
			pstmtDtl.setString(12,s13.replace("N/A","")); 
			pstmtDtl.setString(13,s14.replace("N/A","")); 
			pstmtDtl.setString(14,upd_version);  //add by Peggy 20140430
			pstmtDtl.setString(15,QSEQNO.trim());       //add by Peggy 20150825
			pstmtDtl.setString(16,QNO.trim()); 
			pstmtDtl.executeQuery();
			pstmtDtl.close();
		}
		
		con.commit();
		
		String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
		PreparedStatement pstmt1=con.prepareStatement(sql1);
		pstmt1.executeUpdate(); 
		pstmt1.close();
			
		CallableStatement cs3 = con.prepareCall("{call TSC_QRA_PCN_JOB.PCN_CREATE_JOB(?,?)}");
		cs3.setString(1,QNO); 
		cs3.setString(2,upd_version);
		cs3.execute();
		cs3.close();		
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("動作成功!!");
			setSubmit("../jsp/TSCQRAProductChangeModify.jsp");
		</script>
	<%		
	}
	else
	{
		throw new Exception("無Insert資料!!");
	}
}
catch(Exception e)
{	
	con.rollback();
	out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TSCQRAProductChangeModify.jsp'>回維護畫面</a></font>");
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

