<!--20151122 Peggy,add TSC_PROD_FAMILY column-->
<!--20160113 Peggy,新增ITEM DESC欄位-->
<!--20160513 Peggy,調整packing code資料來源-->
<!--20160727 Peggy,add catalog_cust_moq欄位-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayIQCDocumentInputBean" scope="session" class="Array2DimensionInputBean"/> 
<jsp:useBean id="arrayIQCSearchBean" scope="session" class="Array2DimensionInputBean"/> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
function subWindowItemFind()
{   
	if (document.MYFORM.ITEM_DESC.value ==null || document.MYFORM.ITEM_DESC.value=="")
	{
    	alert("請輸入型號!!");
     	document.MYFORM.INTTYPE.focus();
   		return false;		
	}
	subWin=window.open("../jsp/subwindow/TSDRQItemPackageCategoryFind.jsp?ITEM_DESC="+document.MYFORM.ITEM_DESC.value,"subwin","width=840,height=480,scrollbars=yes,menubar=no");
}
function setLink(URL)
{  
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
function setSubmit(URL)
{ 
	if (document.MYFORM.INTTYPE.value == "--")
	{
    	alert("請選擇Internal或External!!");
     	document.MYFORM.INTTYPE.focus();
   		return false;
	}
	if (document.MYFORM.TSCPRODGROUP.value == "--")
	{
    	alert("請選擇TSC PROD GROUP!!");
     	document.MYFORM.TSCPRODGROUP.focus();
   		return false;
	}	
	if (document.MYFORM.PACKCLASS.value == "--")
	{
		alert("請選擇PACK CLASSl!!");
		document.MYFORM.PACKCLASS.focus();
		return false;
	}
	if (document.MYFORM.TSCFAMILY.value == "--")
	{
		if (document.MYFORM.TSCPRODGROUP.value != "PMD") //add by Peggy 20240328  PMD產品太多元, TSC FAMILY & TSC PROD FAMILY能否不設定卡關 FROM TIN
		{
			alert("請選擇TSC FAMILY!!");
			document.MYFORM.TSCFAMILY.focus();
			return false;
		}
	}
	if (document.MYFORM.TSCPACKAGE.value == "--")
	{
		alert("請選擇TSC OUTLINE!!");
		document.MYFORM.TSCPACKAGE.focus();
		return false;
	}	
	if (document.MYFORM.PACKAGECODE.value == "--")
	{
		alert("請選擇PACKAGE CODE!!");
		document.MYFORM.PACKAGECODE.focus();
		return false;
	}
	//if (document.MYFORM.TSCPRODGROUP.value=="PMD" || document.MYFORM.TSCPRODGROUP.value=="SSP" || document.MYFORM.TSCPRODGROUP.value=="SSD")
	if (document.MYFORM.TSCPRODGROUP.value=="SSP" || document.MYFORM.TSCPRODGROUP.value=="SSD")
	{
		if (document.MYFORM.TSCPRODFAMILY.value=="")
		{
			alert("請選擇TSC Prod Family!!");
			document.MYFORM.TSCPRODFAMILY.focus();
			return false;
		}	
	}	
	if (document.MYFORM.ITEM_DESC.value != null && document.MYFORM.ITEM_DESC.value != "")
	{
		if (document.MYFORM.ITEM_DESC.value != document.MYFORM.ITEM_DESC1.value)
		{
			alert("請按下型號查詢鍵更新型號資料!!");
			document.MYFORM.ITEM_DESC.focus();
			return false;
		}
	}	
	if (isNaN(document.MYFORM.SPQ.value.valueOf()) || document.MYFORM.SPQ.value=="")
	{
    	alert("SPQ(For Normal)必須輸入,不可空白!!");
     	document.MYFORM.SPQ.focus();
   		return false;
    }
	else
	{
		var regex = /^-?\d+\.?\d*?$/;
		if (document.MYFORM.SPQ.value.match(regex)==null) 
		{ 
    		alert("SPQ(For Normal)必須是數值型態!"); 
			document.MYFORM.SPQ.focus();
			return false;
		} 
	}
	if (isNaN(document.MYFORM.SAMPLE_SPQ.value.valueOf()) || document.MYFORM.SAMPLE_SPQ.value=="")
	{
    	alert("SPQ(For Sample)必須輸入,不可空白!!");
     	document.MYFORM.SAMPLE_SPQ.focus();
   		return false;
    }
	else
	{
		var regex = /^-?\d+\.?\d*?$/;
		if (document.MYFORM.SAMPLE_SPQ.value.match(regex)==null) 
		{ 
    		alert("SPQ(For Sample)必須是數值型態!"); 
			document.MYFORM.SAMPLE_SPQ.focus();
			return false;
		} 
	}
	if (isNaN(document.MYFORM.MOQ.value.valueOf()) || document.MYFORM.MOQ.value=="")
	{
    	alert("MOQ必須輸入,不可空白!!");
     	document.MYFORM.MOQ.focus();
	 	return (false);
  	} 
	else
	{
		var regex = /^-?\d+\.?\d*?$/;
		if (document.MYFORM.MOQ.value.match(regex)==null) 
		{ 
    		alert("MOQ必須是數值型態!"); 
			document.MYFORM.MOQ.focus();
			return false;
		} 
	}
	if (document.MYFORM.CATALOG_CUST_MOQ.value!="")  //ADD BY PEGGY 20160727
	{
		var regex = /^-?\d+\.?\d*?$/;
		if (document.MYFORM.CATALOG_CUST_MOQ.value.match(regex)==null) 
		{ 
    		alert("CATALOG CUST MOQ必須是數值型態!"); 
			document.MYFORM.CATALOG_CUST_MOQ.focus();
			return false;
		} 
	}
	if (document.MYFORM.VENDOR_MOQ.value!="")  //ADD BY PEGGY 20211206
	{
		var regex = /^-?\d+\.?\d*?$/;
		if (document.MYFORM.VENDOR_MOQ.value.match(regex)==null) 
		{ 
    		alert("VENDOR MOQ必須是數值型態!"); 
			document.MYFORM.VENDOR_MOQ.focus();
			return false;
		} 
	}	
	
	var mon_num = document.MYFORM.MOQ.value.valueOf() % document.MYFORM.SPQ.value.valueOf();
	if (mon_num >0)
	{
    	alert("MOQ必須為SPQ(For Normal)的整數倍數值!!");
     	document.MYFORM.MOQ.focus();
	 	return (false);	
	}
	mon_num = document.MYFORM.MOQ.value.valueOf() % document.MYFORM.SAMPLE_SPQ.value.valueOf();
	if (mon_num >0)
	{
    	alert("MOQ必須為SPQ(For Sample)的整數倍數值!!");
     	document.MYFORM.MOQ.focus();
	 	return (false);	
	}
	mon_num = document.MYFORM.CATALOG_CUST_MOQ.value.valueOf() % document.MYFORM.SPQ.value.valueOf(); //ADD BY PEGGY 20160727
	if (mon_num >0)
	{
    	alert("CATALOG CUST MOQ必須為SPQ(For Normal)的整數倍數值!!");
     	document.MYFORM.CATALOG_CUST_MOQ.focus();
	 	return (false);	
	}
	mon_num = document.MYFORM.VENDOR_MOQ.value.valueOf() % document.MYFORM.SPQ.value.valueOf(); //ADD BY PEGGY 20211206
	if (mon_num >0)
	{
    	alert("VENDOR MOQ必須為SPQ(For Normal)的整數倍數值!!");
     	document.MYFORM.VENDOR_MOQ.focus();
	 	return (false);	
	}	
	
	document.MYFORM.btnSubmit.disabled=true;
	document.MYFORM.btnCancel.disabled=true;
	document.getElementById("alpha").style.width="100"+"%";
	document.getElementById("alpha").style.height=document.body.clientHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}             
.style17 {
	color: #000099;
	font-family: Georgia;
	font-weight: bold;
	font-size: large;
}
</STYLE>

<title>Item Package Category Packing AddNew Page</title>
</head>
<body>
<font size=4><strong>Item Package Category Packing AddNew Page</strong></font>
<br>
<FORM NAME="MYFORM" ACTION="../jsp/TSDRQItemPackageCategoryAdd.jsp?ActionName=A" METHOD="POST"> 
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600" bordercolor="#cccccc">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料新增中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<A HREF="TSDRQItemPackageCategorySetting.jsp"><font size="2">回上頁</font></A>
<%
	String btnName = "Save";
	String INTTYPE = request.getParameter("INTTYPE");
	if (INTTYPE == null) INTTYPE = "";
	String PACKCLASS = request.getParameter("PACKCLASS");
	if (PACKCLASS == null) PACKCLASS = "";
	String TSCFAMILY = request.getParameter("TSCFAMILY");
	if (TSCFAMILY == null || TSCFAMILY.equals("--")) TSCFAMILY = "";
	String TSCPRODFAMILY = request.getParameter("TSCPRODFAMILY");
	if (TSCPRODFAMILY == null || TSCPRODFAMILY.equals("--")) TSCPRODFAMILY = "";
	String TSCPACKAGE = request.getParameter("TSCPACKAGE");
	if (TSCPACKAGE == null) TSCPACKAGE = "";
	String PACKAGECODE = request.getParameter("PACKAGECODE");
	if (PACKAGECODE == null) PACKAGECODE = "";
	String TSCPRODGROUP = request.getParameter("TSCPRODGROUP");
	if (TSCPRODGROUP == null) TSCPRODGROUP = "";
	String ITEM_ID = request.getParameter("ITEM_ID"); //add by Peggy 20160113
	if (ITEM_ID == null) ITEM_ID = "";	
	String ITEM_NAME = request.getParameter("ITEM_NAME"); //add by Peggy 20160113
	if (ITEM_NAME == null) ITEM_NAME = "";			
	String ITEM_DESC = request.getParameter("ITEM_DESC"); //add by Peggy 20160113
	if (ITEM_DESC == null) ITEM_DESC = "";	
	String ITEM_DESC1 = request.getParameter("ITEM_DESC1"); //add by Peggy 20160113
	if (ITEM_DESC1 == null) ITEM_DESC1 = "";		
	String SPQ = request.getParameter("SPQ");
	if (SPQ == null) SPQ = "";
	String MOQ = request.getParameter("MOQ");
	if (MOQ == null) MOQ = "";
	String CATALOG_CUST_MOQ = request.getParameter("CATALOG_CUST_MOQ");
	if (CATALOG_CUST_MOQ == null) CATALOG_CUST_MOQ = "";  //Aadd by Peggy 20160727	
	String SAMPLE_SPQ = request.getParameter("SAMPLE_SPQ");
	if (SAMPLE_SPQ == null) SAMPLE_SPQ="";
	String VENDOR_MOQ=request.getParameter("VENDOR_MOQ"); //add by Peggy 20211206
	if (VENDOR_MOQ==null) VENDOR_MOQ="";
	//String CREATIONDATE = request.getParameter("CREATIONDATE");
	//if (CREATIONDATE == null) CREATIONDATE = dateBean.getDate();
	//String CREATEDBY = request.getParameter("CREATEDBY");
	//if (CREATEDBY == null) CREATEDBY = UserName;
	String strActName = request.getParameter("ActionName");
	String sql="";
	
	if (strActName.equals("Save"))
	{
    	try
    	{  
			if (ITEM_ID.equals(""))
			{
				sql = " SELECT * FROM  (SELECT TSC_FAMILY,SPQ,MOQ,TSC_PROD_GROUP,CREATION_DATE,CREATED_BY"+
		             ",ROW_NUMBER() over (order by CREATION_DATE desc) as row_num "+
					 " FROM ORADDMAN.TSITEM_PACKING_CATE "+
					 " WHERE INT_TYPE ='"+INTTYPE+"'"+
					 " AND TSC_PROD_GROUP = '" + TSCPRODGROUP +"'"+
					 " AND PACKING_CLASS='"+PACKCLASS+"'"+
					 " AND TSC_OUTLINE='"+TSCPACKAGE+"'"+
					 " AND PACKAGE_CODE='"+PACKAGECODE+"'"+
					 " AND TSC_FAMILY = '" + TSCFAMILY+ "'"+
					 " AND NVL(TSC_PROD_FAMILY,'XX') = NVL('" + TSCPRODFAMILY+ "','XX')"+
					 " AND INVENTORY_ITEM_ID IS NULL"+ //add by Peggy 20231108
					 " )"+
					 " WHERE row_num =1";
			}
			else
			{
				sql = " SELECT * FROM  (SELECT TSC_FAMILY,SPQ,MOQ,TSC_PROD_GROUP,CREATION_DATE,CREATED_BY"+
		             ",ROW_NUMBER() over (order by CREATION_DATE desc) as row_num "+
					 " FROM ORADDMAN.TSITEM_PACKING_CATE "+
					 " WHERE INT_TYPE ='"+INTTYPE+"'"+
					 " AND NVL(INVENTORY_ITEM_ID,-999) = NVL('" + ITEM_ID+ "',-999)"+
					 " )"+
					 " WHERE row_num =1";
			}
			//out.println(sql);
      		ResultSet rs=con.createStatement().executeQuery(sql);
      		if ( rs.next())
      		{		
				SPQ = "";
				MOQ = "";			
				out.println("<script language = 'JavaScript'>");
				out.println("alert('新增失敗,此筆資料已存在,請使用編輯功能進行調整,謝謝!')");
				out.println("</script>");
			}
			else
			{
				//20110328 modify by Peggy 
				sql = " insert into ORADDMAN.TSITEM_PACKING_CATE"+
						" (INT_TYPE,PACKING_CLASS,TSC_FAMILY,TSC_OUTLINE,PACKAGE_CODE,SPQ,MOQ,TSC_PROD_GROUP,CREATION_DATE,CREATED_BY,SAMPLE_SPQ"+ //add SAMPLE_SPQ field by Peggy on 20120516
	    				",TSC_PROD_FAMILY,INVENTORY_ITEM_ID,ITEM_NO,ITEM_DESCRIPTION,LAST_UPDATE_DATE,LAST_UPDATED_BY"+ //add by Peggy 20160113
						",CATALOG_CUST_MOQ,VENDOR_MOQ)"+//add by Peggy 20160727,add VENDOR_MOQ by Peggy 20211206
  						" values"+
						" (?,?,?,?,?,?,?,?,to_char(sysdate,'yyyymmddhh24miss'),?,?,?,?,?,?,to_char(sysdate,'yyyymmddhh24miss'),?,?,?)";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,INTTYPE);	
				st1.setString(2,PACKCLASS);
				st1.setString(3,TSCFAMILY); 
				st1.setString(4,TSCPACKAGE);
				st1.setString(5,PACKAGECODE);  
				st1.setString(6,SPQ); 
				st1.setString(7,MOQ);
				st1.setString(8,TSCPRODGROUP);
				st1.setString(9,UserName);
				st1.setString(10,SAMPLE_SPQ);
				st1.setString(11,TSCPRODFAMILY);
				st1.setString(12,ITEM_ID);
				st1.setString(13,ITEM_NAME);
				st1.setString(14,ITEM_DESC);
				st1.setString(15,UserName);
				st1.setString(16,CATALOG_CUST_MOQ); //add by Peggy 20160727
				st1.setString(17,VENDOR_MOQ); //add by Peggy 20211206
				st1.executeUpdate();
				st1.close();
				INTTYPE = "";
				PACKCLASS = "";
				TSCFAMILY = "";
				TSCPRODFAMILY = "";
				TSCPACKAGE = "";
				PACKAGECODE = "";
				ITEM_DESC=""; //Add by Peggy 20160113
				ITEM_NAME=""; //ADD BY Peggy 20160113
				ITEM_ID="";   //ADD BY Peggy 20160113
				//TSCPRODGROUP = "";
				SPQ = "";
				MOQ = "";
				SAMPLE_SPQ ="";		
				CATALOG_CUST_MOQ=""; //add by Peggy 20160727
				VENDOR_MOQ=""; //add by Peggy 20211206
				out.println("<script language = 'JavaScript'>");
				out.println("alert('資料新增成功!')");
				out.println("</script>");
			}
			rs.close();
			
     	} //end of try
     	catch (Exception e)
     	{
			out.println(e.getMessage());
			out.println("<script language = 'JavaScript'>");
			out.println("alert('資料新增失敗,請洽系統管理人員,謝謝!')");
			out.println("</script>");		
     	} 
	}
	else
	{
		sql = "select tsc_prod_group from oraddman.tsprod_manufactory a where MANUFACTORY_NO=?"; 
		PreparedStatement statementx = con.prepareStatement(sql);
		statementx.setString(1,userProdCenterNo);
		ResultSet rsx=statementx.executeQuery();
		if (rsx.next())
		{
			TSCPRODGROUP = rsx.getString(1);
		}
		rsx.close();
		statementx.close();
	}
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate(); 
	pstmt.close();	
%>
<table width="90%" border="0" cellpadding="0" cellspacing="1" bordercolor="#CCCCCC" bordercolorlight="#999999" bordercolordark="#FFFFFF">
	<!--第一行-->
	<tr bgcolor="#D8DEA9">
 		<td width="10%" nowrap>Internal/External：</td>
   		<td width="15%" nowrap>
		<%

	    	try
            {   
				sql = " select DISTINCT INT_TYPE  fieldvalue, INT_TYPE from ORADDMAN.TSITEM_PACKING_CATE "+	  		  
		                     " where INT_TYPE > '0' "+
							 " and upper(INT_TYPE) not in ('YEW','YE')"+
		                     " order by INT_TYPE DESC ";				   
		        Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery(sql);
                comboBoxBean.setRs(rs);
	            comboBoxBean.setSelection("--");
	            comboBoxBean.setFieldName("INTTYPE");	
				comboBoxBean.setFontName("Tahoma,Georgia");  
                out.println(comboBoxBean.getRsString());
		        rs.close();   
				statement.close();
			 } //end of try		 
             catch (Exception e)
			 { 
			 	out.println("Exception:"+e.getMessage()); 
			 }  
		%>		</td>
   		<td width="10%" nowrap>PACK CLASS：</td>
   		<td width="15%" nowrap>
     	<%
			 try
			 {   
				sql = " select DISTINCT PACKING_CLASS fieldvalue,PACKING_CLASS from ORADDMAN.TSITEM_PACKING_CATE " +	  		  
		                    // " where INT_TYPE ='"+intType+"' "+
							 " where upper(PACKING_CLASS) not in ('YEW','YE')"+
							 " order by PACKING_CLASS DESC ";
		        Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery(sql);
			  	comboBoxBean.setRs(rs);
		  		comboBoxBean.setSelection("--");
	      		comboBoxBean.setFieldName("PACKCLASS");	 
				comboBoxBean.setFontName("Tahoma,Georgia");   
          		out.println(comboBoxBean.getRsString());
		  	   	rs.close();   
			   	statement.close();
			 } //end of try		 
			 catch (Exception e)
			 { 
			 	out.println("Exception:"+e.getMessage()); 
			 }  
	 	%>   		</td>
  		<td width="10%" nowrap>TSC FAMILY：</td>
   		<td width="15%" nowrap>
     	<%
			 try
			 {   
				sql = " SELECT DISTINCT SEGMENT1 fieldvalue, SEGMENT1"+
                             " FROM MTL_CATEGORIES_V "+
                             " WHERE STRUCTURE_NAME='Family'"+
                             " AND DISABLE_DATE IS NULL order by SEGMENT1";
		        Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery(sql);
			  	comboBoxBean.setRs(rs);
		  		comboBoxBean.setSelection("--");
	      		comboBoxBean.setFieldName("TSCFAMILY");	
				comboBoxBean.setFontName("Tahoma,Georgia");    
          		out.println(comboBoxBean.getRsString());
		  	   	rs.close();   
			   	statement.close();
			 } //end of try		 
			 catch (Exception e)
			 { 
			 	out.println("Exception:"+e.getMessage()); 
			 }  
	 	%>		</td>
  		<td width="10%" nowrap>TSC PROD FAMILY：</td>
   		<td width="15%" nowrap>
     	<%
		if (TSCPRODGROUP.equals("PMD") || TSCPRODGROUP.equals("SSP")|| TSCPRODGROUP.equals("SSD") || UserRoles.indexOf("admin")>=0)
		{	
			try
			{   
				sql = " SELECT DISTINCT SEGMENT1 fieldvalue, SEGMENT1"+
                             " FROM MTL_CATEGORIES_V "+
                             " WHERE STRUCTURE_NAME='TSC_PROD_FAMILY'"+
                             " AND DISABLE_DATE IS NULL order by SEGMENT1";
		        Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery(sql);
			  	comboBoxBean.setRs(rs);
		  		comboBoxBean.setSelection("--");
	      		comboBoxBean.setFieldName("TSCPRODFAMILY");	
				comboBoxBean.setFontName("Tahoma,Georgia");    
          		out.println(comboBoxBean.getRsString());
		  	   	rs.close();   
			   	statement.close();
			} //end of try		 
			catch (Exception e)
			{ 
				out.println("Exception:"+e.getMessage()); 
			} 
		} 
		else
		{
			out.println("<input type='text' name='TSCPRODFAMILY' value='' disabled>");
		}
	 	%>		</td>
	</tr>    
	<!--第二行-->
	<tr bgcolor="#D8DEA9">
 		<td width="15%" nowrap>TSC PACKAGE：</td>
   		<td colspan="1" nowrap>
		<%
	    	try
            {   
				sql = " SELECT DISTINCT  SEGMENT1 fieldvalue,SEGMENT1"+
                             " FROM MTL_CATEGORIES_V "+
                             " WHERE STRUCTURE_NAME='Package'"+
                             " AND DISABLE_DATE IS NULL order by SEGMENT1 ";
		        Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery(sql);
                comboBoxBean.setRs(rs);
	            comboBoxBean.setSelection("--");
	            comboBoxBean.setFieldName("TSCPACKAGE");	
				comboBoxBean.setFontName("Tahoma,Georgia");  
                out.println(comboBoxBean.getRsString());
		        rs.close();   
				statement.close();
			 } //end of try		 
             catch (Exception e)
			 { 
			 	out.println("Exception:"+e.getMessage()); 
			 }  
		%>		</td>
   		<td width="15%" nowrap>PACKING CODE：</td>
   		<td colspan="1" nowrap>
     	<%
			 try
			 {   
				//String sql = " select DISTINCT PACKAGE_CODE fieldvalue,PACKAGE_CODE from ORADDMAN.TSITEM_PACKING_CATE WHERE length(trim(PACKAGE_CODE))>0 ORDER BY PACKAGE_CODE";	  		  
				//改寫package code資料抓法,modify by Peggy 20120120
				//String sql = " select tsc_package_code fieldvalue,tsc_package_code PACKAGE_CODE "+
				//             " from (select case when (tsc_om_category (x.inventory_item_id, x.organization_id, 'TSC_PROD_GROUP')='PMD' and substr(x.segment1,4,1)='G') then substr(x.segment1,9,2)||'G' when  ( tsc_om_category (x.inventory_item_id, x.organization_id, 'TSC_PROD_GROUP')<>'PMD' and substr(x.segment1,11,1)='1' ) then substr(x.segment1,9,2)||'G' else substr(x.segment1,9,2) end as tsc_package_code"+
                //             " from inv.mtl_system_items_b x where x.organization_id=43 and length(x.segment1)>20 and x.segment1 not like 'OSP-%' and x.segment1 not like 'PK%' and x.segment1 not like 'SOP-%' and x.segment1 not like 'Opening%' and x.INVENTORY_ITEM_STATUS_CODE <> 'Inactive' and upper(x.description) NOT LIKE '%FAIRCHILD%' ) a"+
                //             " group by tsc_package_code order by tsc_package_code";
				//CALL FUNCTION:TSC_GET_ITEM_PACKING_CODE
				//String sql = " select packing_code fieldvalue,packing_code from (select TSC_GET_ITEM_PACKING_CODE(organization_id,inventory_item_id) packing_code from inv.mtl_system_items_b a where organization_id=49 and length(a.segment1) in (21,22) and a.inventory_item_status_code<>'Inactive' and UPPER(a.description) not like '%DISABLE%' ) x group by packing_code order by 1";
				//String sql = " SELECT DISTINCT D_VALUE fieldvalue, D_VALUE packing_code  FROM oraddman.tsqra_product_setup a  WHERE D_TYPE='TSC_PACKING_CODE'  ORDER BY 1";
				sql = " SELECT DISTINCT D_VALUE fieldvalue, D_VALUE packing_code  FROM oraddman.tsqra_product_setup a  WHERE D_TYPE='PACKING_CODE'"+
                             " UNION All"+
							 " SELECT DISTINCT D_VALUE||'G' fieldvalue, D_VALUE||'G' packing_code  FROM oraddman.tsqra_product_setup a  WHERE D_TYPE='PACKING_CODE' "+
							 " union all"+
							 " SELECT 'QQ' fieldvalue, 'QQ' packing_code from dual"+
							 " union all"+
							 " SELECT 'QQG' fieldvalue, 'QQG' packing_code from dual"+
							 " union all"+
							 " SELECT '00' fieldvalue, '00' packing_code from dual"+
							 " union all"+
							 " SELECT '00G' fieldvalue, '00G' packing_code from dual"+							 
							 "  ORDER BY 1";
		        Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery(sql);
			  	comboBoxBean.setRs(rs);
		  		comboBoxBean.setSelection("--");
	      		comboBoxBean.setFieldName("PACKAGECODE");	
				comboBoxBean.setFontName("Tahoma,Georgia");    
          		out.println(comboBoxBean.getRsString());
		  	   	rs.close();   
			   	statement.close();
			 } //end of try		 
			 catch (Exception e)
			 { 
			 	out.println("Exception:"+e.getMessage()); 
			 }  
	 	%>
 		<td width="15%" nowrap>TSC PROD GROUP：</td>
   		<td colspan="1" nowrap>
		<%
	    	try
            {   
				sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1"+
                             " FROM MTL_CATEGORIES_V "+
                             " WHERE STRUCTURE_NAME='TSC_PROD_GROUP'"+
                             " AND DISABLE_DATE IS NULL order by SEGMENT1";
		        Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery(sql);
                comboBoxBean.setRs(rs);
	            comboBoxBean.setSelection(TSCPRODGROUP);
	            comboBoxBean.setFieldName("TSCPRODGROUP");	
				comboBoxBean.setFontName("Tahoma,Georgia");  
                out.println(comboBoxBean.getRsString());
		        rs.close();   
				statement.close();
			 } //end of try		 
             catch (Exception e)
			 { 
			 	out.println("Exception:"+e.getMessage()); 
			 }  
		String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
    	PreparedStatement pstmt2=con.prepareStatement(sql2);
		pstmt2.executeUpdate(); 
    	pstmt2.close();			 
		%>   		</td>
  		<td width="15%" nowrap>ITEM DESC：</td>
   		<td colspan="1" nowrap><input name="ITEM_DESC" type="text" id="ITEM_DESC" size="20" value= "<%=ITEM_DESC%>" style="font-family:Tahoma;">
   		  <input type="button" name="btn1" value=".." onClick="subWindowItemFind()">
   		  <input type="hidden" name="ITEM_ID" value="<%=ITEM_ID%>">
		<input type="hidden" name="ITEM_NAME" value="<%=ITEM_NAME%>">
		<input type="hidden" name="ITEM_DESC1" value="<%=ITEM_DESC1%>">		
		</td>
	 </tr>    
	<!--第三行-->
	<tr bgcolor="#D8DEA9">
  		<td width="15%" nowrap>SPQ(For Normal)：</td>
   		<td colspan="1" nowrap><input name="SPQ" type="text" id="SPQ" size="10" value= "<%=SPQ%>" style="font-family:Tahoma;">(PCE)</td>
  		<td width="15%" nowrap>SPQ(For Sample)：</td>
   		<td colspan="1" nowrap><input name="SAMPLE_SPQ" type="text" id="SAMPLE_SPQ" size="10" value= "<%=SAMPLE_SPQ%>" style="font-family:Tahoma;">(PCE)</td>
 		<td width="15%" nowrap>MOQ：</td>
   		<td nowrap><input name="MOQ" type="text" id="MOQ" size="10" value= "<%=MOQ%>" style="font-family:Tahoma;">(PCE)</td>
 		<td nowrap>Catalog Cust MOQ：</td>
   		<td nowrap><input name="CATALOG_CUST_MOQ" type="text" id="CATALOG_CUST_MOQ" size="10" style="font-family:Tahoma;" value= "<%=CATALOG_CUST_MOQ%>">(PCE)</td>
	 </tr>   
	<tr bgcolor="#D8DEA9">
  		<td nowrap>Vendor MOQ：</td>
   		<td nowrap><input name="VENDOR_MOQ" type="text" id="VENDOR_MOQ" size="20" style="font-family:Tahoma;" value= "<%=VENDOR_MOQ%>">(PCE)</td>
		<td colspan="6">&nbsp;</td>
	 </tr> 	 
	 <tr><td colspan="8">&nbsp;</td></tr> 
	 <tr>
    	<td colspan="8" align="center"> <input name="btnSubmit" type=button onClick='setSubmit("../jsp/TSDRQItemPackageCategoryAdd.jsp?ActionName=<%=btnName%>")' value="<%=btnName%>" style="font-family:Tahoma;">
	     <input name="btnCancel" type=button onClick='setLink("../jsp/TSDRQItemPackageCategorySetting.jsp")' value="Cancel" style="font-family:Tahoma;">		</td>    
	 </tr>
</table>
</FORM>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
