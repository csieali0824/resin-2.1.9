<!-- 20141215 modify by Peggy,MYSQL資料庫異動調整   -->
<!-- 20151201 by Peggy,TSC_PROD_ROUP更名,Rect=>PRD,SSP=>SSD-->
<!-- 20160429 by Peggy,for官網部份型號加packing code進行資料判斷-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.lang.*,java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title></title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   {background-color:#E1CDC8;font-size:12px;}
  .style2   {font-family:Tahoma,Georgia;border:none;font-size:12px;}
  .style3   {font-family:Tahoma,Georgia;color:#000000;font-size:12px;border:none;font-weight:bold}
  .style4   {font-family:Tahoma,Georgia;font-size:12px;border-left:none;border-right:none;border-top:none;color:#000000;border-color:#CCCCCC}
  .style5   {font-family:Tahoma,Georgia;font-size:12px;}
</STYLE>
</head>
<%
int ErrCnt=0;
String ERRMSG="";
String SCHEDULING = request.getParameter("SCHEDULING");
if (SCHEDULING==null) SCHEDULING="";
String sql = "";

//try
//{
	//Class.forName("com.mysql.jdbc.Driver");
	try
	{
		int icnt=0;
		String s_package_code ="",s_family="",s_item="",s_item1="";

		//truncate table tsqra_product_list
		sql = " truncate table oraddman.tsqra_product_list";
		PreparedStatement pstmtDt1=con.prepareStatement(sql);  
		pstmtDt1.executeUpdate();
		pstmtDt1.close();
		
		/*sql =  " SELECT a.name,"+ 
               "        a.description, "+
               "        a.is_active, "+
               //"        i18n.content PRODUCT_CATEGORY_NAME,"+
			   //"        CASE WHEN  LOCATE('(',i18n.content)>0 THEN TRIM(SUBSTR(i18n.content ,1,LOCATE('(',i18n.content)-1)) ELSE i18n.content END PRODUCT_CATEGORY_NAME,"+ //modify by Peggy 20150318
			   "        i18n.content as PRODUCT_CATEGORY_NAME,"+
               //"        case when B.name IN ('DFN 2x2','DFN 22') then 'DFN22' else  replace(B.name,'2','2') end AS PACKAGE_NAME,"+
			   "        case when B.name IN ('DFN 2x2','DFN 22') then 'DFN22' when B.name IN ('TO-262S (I2PAK SL)') then 'TO-262S (I2PAK SL)' when B.name IN ('TO-262 (I2PAK)') then 'TO-262 (I2PAK)' when B.name IN ('TO-263 (D2-PAK)') then 'TO-263 (D2-PAK)' when B.name IN ('TO-263-5L (D2-PAK)') then 'TO-263-5L (D2-PAK)' when B.name IN ('TO-263AB (D2-PAK)') then 'TO-263AB (D2-PAK)' when B.name IN ('I2PAK') then 'I2PAK' else  B.name END AS PACKAGE_NAME,"+
               "        c.name FAMILY_NAME,"+
               "        IFNULL(d.numeric_value,0) AMP,"+
			   "        REVERSE(IFNULL(d.catename,'')) catename,"+
               "        IFNULL(e.numeric_value,0) VOLT,"+
               "        REVERSE(IFNULL(e.vcatename,'')) VOLT_unit,"+
               "        IFNULL(f.numeric_value,0)  AECQ,"+
			   "        F.aecq_name,"+
			   "        k.id parent_id,"+
               "        h.content parent_category_name,"+
               "        k.parent_id grantparent_id,"+
               "        i.content grantparent_category_name"+
               " FROM tsc.products a "+
               " LEFT JOIN tsc.product_packages b ON a.product_package_id = b.id "+
               " LEFT JOIN tsc.product_families c ON a.product_family_id = c.id "+
               " LEFT JOIN tsc.i18n ON i18n.locale = 'en' "+
               " AND i18n.model = 'ProductCategory' "+
               " AND i18n.foreign_key = a.product_category_id "+
               " AND i18n.field = 'name'"+
               " LEFT JOIN (SELECT sppv.product_id, sppv.numeric_value,"+
			   //"sppf.name catename"+
			   //" ,substr(sppf.name,LOCATE('(', REVERSE(sppf.name))+1, LOCATE('(',REVERSE(sppf.name))-LOCATE(')', REVERSE(sppf.name))-1) catename"+
              "            substr(REVERSE(sppf.name),LOCATE(')', REVERSE(sppf.name))+1, LOCATE('(',REVERSE(sppf.name))-LOCATE(')', REVERSE(sppf.name))-1) catename"+
               "           FROM tsc.product_parameter_values sppv"+
               "           INNER JOIN tsc.product_parameter_fields sppf ON sppf.id = sppv.product_parameter_field_id"+
               "           WHERE sppf.slug in ('ifav-a','id-max-a','ic-a','pd-mw','switch-output-current-isw-typ-a','output-current-iout-typ-a')) d ON a.id = d.product_id "+
               "           LEFT JOIN (SELECT sppv.product_id, sppv.numeric_value,"+
			   //"          sppf.name vcatename"+
               "           substr(REVERSE(sppf.name),LOCATE(')', REVERSE(sppf.name))+1, LOCATE('(',REVERSE(sppf.name))-LOCATE(')', REVERSE(sppf.name))-1) vcatename"+
               "           FROM tsc.product_parameter_values sppv"+
               "           INNER JOIN tsc.product_parameter_fields sppf ON sppf.id = sppv.product_parameter_field_id"+
               "           WHERE sppf.slug in ('vrrm-v','vds-v','vcbo-v','vbo-v','output-voltage-vout-v','vbr-nom-v')) e"+
			   "           ON a.id = e.product_id"+
               "           LEFT JOIN (SELECT sppv.product_id, sppv.numeric_value ,"+
               "           sppf.name aecq_name"+
               "           FROM tsc.product_parameter_values sppv"+
               "           INNER JOIN tsc.product_parameter_fields sppf "+
               "           ON sppf.id = sppv.product_parameter_field_id"+
			   " 	       WHERE sppf.slug in ('aec-q')) f "+
               "           ON a.id = f.product_id"+
			   "           LEFT JOIN tsc.product_categories g on a.product_category_id=g.id "+
               "           LEFT JOIN tsc.product_categories k on g.parent_id=k.id "+
               "           LEFT JOIN tsc.i18n h ON h.locale = 'en'"+ 
               "           AND h.model = 'ProductCategory' "+
               "           AND h.foreign_key = k.id"+
               "           AND h.field = 'name'"+
               "           LEFT JOIN tsc.i18n i ON i.locale = 'en' "+
               "           AND i.model = 'ProductCategory' "+
               "           AND i.foreign_key = k.parent_id"+
               "           AND i.field = 'name'"+
			   " where B.name is not null";
			   //" where a.name  LIKE 'US1MH%'";
		Connection conn = DriverManager.getConnection("jdbc:mysql://10.0.1.60:3306?user=remote&password=6huA=MUvs$T>>MAT");
		Statement st = conn.createStatement();
		*/
		sql = " SELECT a.part_name name, a.part_desc description, a.is_active, a.product_category_name,"+
              " a.package_name, nvl(a.family_name,a.product_category_name) family_name, a.amp, a.catename, replace(a.volt,'-','') volt,"+
              " a.volt_unit, a.aecq, a.aecq_name, a.parent_id,"+
              " a.parent_category_name, a.grantparent_id,"+
              " a.grantparent_category_name, a.last_update_date"+
              " FROM oraddman.tsqra_product_list_v a "+
			  //" where part_name='UGS5J'"+
			  " order by 1";
		Statement st=con.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while (rs.next()) 
		{	
			icnt++;
			//out.println(rs.getString("NAME"));
			s_package_code = rs.getString("PACKAGE_NAME").trim();
			s_family =(rs.getString("PRODUCT_CATEGORY_NAME")==null?rs.getString("FAMILY_NAME"):rs.getString("PRODUCT_CATEGORY_NAME"));

			if (rs.getString("NAME").length() >=4)
			{
				s_item=(rs.getString("NAME").substring(rs.getString("NAME").length()-4)).substring(0,1);
				s_item1=(rs.getString("NAME").substring(rs.getString("NAME").length()-3)).substring(0,1);
			}
			else
			{
				s_item="";s_item1="";
			}
			//out.println("item="+s_item+ " "+s_item1);
			//out.println(rs.getString("NAME").substring(rs.getString("NAME").length()-1));
			//out.println("xx");
			if ((rs.getString("NAME").substring(rs.getString("NAME").length()-1).equals("G") && (s_item.equals("H") || s_item.equals(" "))) || (!rs.getString("NAME").substring(rs.getString("NAME").length()-1).equals("G") && (s_item1.equals("H") || s_item1.equals(" "))))
			{
				//out.println(rs.getString("NAME"));
				sql = " insert into oraddman.tsqra_product_list (TSC_ITEM_DESC,TSC_PACKAGE,TSC_AMP1,TSC_FAMILY,CREATION_DATE,ITEM_STATUS,TSC_VOLT,AECQ,TSC_PACKING_CODE,TSC_FAMILY1,TSC_FAMILY2)"+
					  " select ?,?,?,?,sysdate,?,?,?,?,?,?"+
					  " from DUAL ";
				//out.println(sql);
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,rs.getString("NAME")); 
				pstmtDt.setString(2,s_package_code);
				pstmtDt.setString(3,(rs.getString("amp")==null?"0":(new DecimalFormat("#######.#####")).format(rs.getFloat("amp"))+rs.getString("catename").replace("(","")));
				pstmtDt.setString(4,s_family);
				pstmtDt.setString(5,(rs.getString("is_active").equals("1")?"Active":"Inactive"));
				pstmtDt.setString(6,(rs.getString("VOLT")==null?"0":(new DecimalFormat("#######.#####")).format(rs.getFloat("VOLT"))+rs.getString("VOLT_unit").replace("(","")));
				pstmtDt.setString(7,(rs.getString("AECQ")==null?"0":(new DecimalFormat("#######.#####")).format(rs.getFloat("AECQ"))));  //add by Peggy 20150817
				pstmtDt.setString(8,(rs.getString("NAME").substring(rs.getString("NAME").length()-1).equals("G") && (s_item.equals("H") || s_item.equals(" "))?rs.getString("NAME").substring(rs.getString("NAME").length()-3):rs.getString("NAME").substring(rs.getString("NAME").length()-2))); 
				pstmtDt.setString(9,rs.getString("parent_category_name")); 
				pstmtDt.setString(10,rs.getString("grantparent_category_name")); 
				pstmtDt.executeQuery();
				pstmtDt.close();	
						
			}
			else
			{
				//out.println(rs.getString("NAME"));
				sql = " insert into oraddman.tsqra_product_list (TSC_ITEM_DESC,TSC_PACKAGE,TSC_AMP1,TSC_FAMILY,CREATION_DATE,ITEM_STATUS,TSC_VOLT,AECQ,TSC_PACKING_CODE,TSC_FAMILY1,TSC_FAMILY2)"+
					  " select ?||' '|| a.d_value,?,?,?,sysdate,?,?,?,a.D_VALUE,?,?"+
					  " from DUAL B left join  (select * from oraddman.tsqra_product_setup where D_TYPE='PACKING_CODE') a"+
					  " on upper(?)=upper(a.D_ATTRIBUTE2)";
				//out.println(sql);
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,rs.getString("NAME")); 
				pstmtDt.setString(2,s_package_code);
				pstmtDt.setString(3,(rs.getString("amp")==null?"0":(new DecimalFormat("#######.#####")).format(rs.getFloat("amp"))+rs.getString("catename").replace("(","")));
				pstmtDt.setString(4,s_family);
				pstmtDt.setString(5,(rs.getString("is_active").equals("1")?"Active":"Inactive"));
				pstmtDt.setString(6,(rs.getString("VOLT")==null?"0":(new DecimalFormat("#######.#####")).format(rs.getFloat("VOLT"))+rs.getString("VOLT_unit").replace("(","")));
				pstmtDt.setString(7,(rs.getString("AECQ")==null?"0":(new DecimalFormat("#######.#####")).format(rs.getFloat("AECQ"))));  //add by Peggy 20150817
				pstmtDt.setString(8,rs.getString("parent_category_name")); 
				pstmtDt.setString(9,rs.getString("grantparent_category_name")); 
				pstmtDt.setString(10,s_package_code); 
				pstmtDt.executeQuery();
				pstmtDt.close();	
				
			}			  
		}
		rs.close();
		st.close();
		//conn.close();
		//out.println("icnt="+icnt);
		con.commit();
		
		if (icnt>0)
		{	
			//add by Peggy 20151116,同一型號有amp及watt,以amp為主
			sql = " DELETE oraddman.tsqra_product_list b"+
				  " WHERE EXISTS (SELECT 1 FROM (SELECT ROWID,a.tsc_item_desc, a.tsc_package, a.tsc_amp1, a.tsc_amp2,"+
				  "               a.tsc_prod_group, a.tsc_family, a.creation_date,"+
				  "               a.tsc_packing_code, a.item_status, a.tsc_volt, a.aecq,row_number() over (partition by TSC_ITEM_DESC,TSC_PACKAGE,TSC_FAMILY,TSC_PROD_GROUP,TSC_PACKING_CODE order by CASE WHEN instr(TSC_AMP1,'A')>0 THEN 1 ELSE 2 END) row_seq"+
				  " FROM oraddman.tsqra_product_list a) X WHERE ROW_SEQ>1 AND x.rowid=b.rowid)";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.executeQuery();
			pstmtDt.close();			  
	
				
			//update tsc_prod_group
			sql = " update oraddman.tsqra_product_list a"+
				  " set TSC_PROD_GROUP=(select d_value from oraddman.tsqra_product_setup b  where D_TYPE='TSC_PROD_GROUP' and a.tsc_family =b.D_ATTRIBUTE1)";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.executeQuery();
			pstmtDt.close();
			
			sql = " update oraddman.tsqra_product_list a"+
				  " set tsc_prod_group='PMD'"+
				  " where tsc_family in ('NPN Bipolar Transistor','PNP Bipolar Transistor')"+
				  " and TSC_ITEM_DESC like 'TS%'"; // add by Peggy 20160803,CY說TS開頭都是PMD
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.executeQuery();
			pstmtDt.close();
			
			sql = " update oraddman.tsqra_product_list a"+
				  " set tsc_prod_group='SSD'"+
				  " where (tsc_family in ('Schottky')"+
				  "     and (substr(TSC_ITEM_DESC,1,1) in ('B','L') or instr(TSC_ITEM_DESC,'RB495D') >0 or tsc_package in ('SOD-123','SOD-523F','SOD-323','SOD-323F','SOD-723F','0603','SOT-323')))"+  //add 0603 by Peggy 20161026
				  " OR  (tsc_family in ('Fast Recovery Rectifier')"+
				  "     and tsc_package in ('SOD-123'))"+
				  " OR  (tsc_family in ('Standard Bridge Rectifier')"+
				  "     and (substr(TSC_ITEM_DESC,1,3) in ('TMB') or tsc_package in ('SOD-123')))"+
				  " OR  (tsc_family in ('Standard Recovery Rectifier')"+
				  "     and (substr(TSC_ITEM_DESC,1,2) in ('LL') or tsc_package in ('SOD-123')))"+
				  " OR  (substr(TSC_ITEM_DESC,1,4) IN ('TSOD') AND tsc_package in ('SOD-123FL'))"+
				  "";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.executeQuery();
			pstmtDt.close();		
			
			sql = " update oraddman.tsqra_product_list a"+
				  " set tsc_prod_group='PRD'"+
				  " where tsc_family in ('Zener Diode & Array')"+
				  " and (substr(TSC_ITEM_DESC,1,2) in ('1M','1S','2M') OR  substr(TSC_ITEM_DESC,1,3) in ('BZD') OR TSC_ITEM_DESC LIKE '1N%A%' OR substr(TSC_ITEM_DESC,1,6) in ('1PGSMC','1PGSMB','1PGSMA'))";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.executeQuery();
			pstmtDt.close();
								
			//add by Peggy 20150817,add H code
			sql = " INSERT INTO oraddman.tsqra_product_list"+
				  " SELECT replace(a.tsc_item_desc,' ','H') tsc_item_desc, a.tsc_package, a.tsc_amp1, a.tsc_amp2,"+
				  " a.tsc_prod_group, a.tsc_family, a.creation_date,"+
				  " a.tsc_packing_code, a.item_status, a.tsc_volt, 'Y',a.tsc_family1,a.tsc_family2"+
				  " FROM oraddman.tsqra_product_list a"+
				  " where AECQ=?"+
				  " and ((substr(substr(a.tsc_item_desc,-4),1,1) in (' ') and substr(a.tsc_item_desc,-1) ='G')"+
				  " or (substr(substr(a.tsc_item_desc,-3),1,1) in (' ') and substr(a.tsc_item_desc,-1) <>'G'))";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,"1"); 
			pstmtDt.executeQuery();
			pstmtDt.close();
			
			//add Green packing code
			sql = " INSERT INTO oraddman.tsqra_product_list"+
				  " SELECT a.tsc_item_desc||'G', a.tsc_package, a.tsc_amp1, a.tsc_amp2,"+
				  " a.tsc_prod_group, a.tsc_family, a.creation_date,"+
				  " a.tsc_packing_code||'G', a.item_status, a.tsc_volt, a.AECQ,a.tsc_family1,a.tsc_family2"+
				  " FROM oraddman.tsqra_product_list a "+
				  " WHERE TSC_PACKING_CODE IS NOT NULL"+
				  //" and substr(a.tsc_item_desc,-1)<>'G'"+ //add by Peggy 20160429
				  " and (substr(a.TSC_PACKING_CODE,-1)<>'G' or trim(a.TSC_PACKAGE)  in ('0503','0603','0603-B','ABS-L','ABS','MSOP-10EP','PDFN33'))"+  //modif by Peggy 20181128
				  //" and substr(substr(a.tsc_item_desc,-4),1,1) not in ('H',' ')";  //add by Peggy 20160429
				  " and LENGTH(A.TSC_PACKING_CODE)<3";
				  
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.executeQuery();
			pstmtDt.close();
	
			con.commit();		
		}
		else
		{
			throw new Exception();
		}
	}
	//catch(SQLException sExec)
	catch(Exception e)
	{
		ErrCnt ++;
		con.rollback();
		//ERRMSG=sExec.getMessage();
		ERRMSG=e.getMessage();
		out.println("INSERT錯誤"+ERRMSG+sql);
	}
//}
//catch(ClassNotFoundException err)
//{
//	ErrCnt ++;
//	con.rollback();
//	ERRMSG=err.getMessage();
//	out.println("Class錯誤");
//}
if (ErrCnt >0)
{	
	if (SCHEDULING.equals("Y"))
	{
		
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
		message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject("TSC QRA Product Import Fail- "+dateBean.getYearMonthDay());
		message.setText(ERRMSG);
		Transport.send(message);	
	}
	else
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("資料匯入失敗,請速洽系統管理人員!");
			//location.href="../jsp/TSCQRAProductChangeModify.jsp";
		</script>
	<%
	}
}
else
{
	if (SCHEDULING.equals("Y"))
	{
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
		message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject("TSC QRA Product Import Success- "+dateBean.getYearMonthDay());
		message.setText("OK");
		Transport.send(message);		
	}
	else
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("資料匯入成功!");
			location.href="../jsp/TSCQRAProductChangeModify.jsp";
		</script>
	<%
	}
}
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>