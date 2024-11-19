<%@ page contentType="text/html;charset=utf-8" pageEncoding="GBK" language="java" import="java.sql.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
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
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		if (document.MYFORMD.STATUS.value=="NEW")
		{
			window.opener.MYFORM.action="../jsp/TSSalesOrderBaseDataSetupK3.jsp?TKIND="+document.MYFORMD.TKIND.value;
			window.opener.MYFORM.submit();
		}
		else if (document.MYFORMD.ACODE.value=="CHANGE")
		{
			return;
		}
		else
		{	
			window.opener.document.getElementById("alpha").style.width="0";
			window.opener.document.getElementById("alpha").style.height="0";
		}
		window.close();				
    }  
} 
function setCancel()
{
	if (document.MYFORMD.STATUS.value=="NEW")
	{
		window.opener.MYFORM.action="../jsp/TSSalesOrderBaseDataSetupK3.jsp?TKIND="+document.MYFORMD.TKIND.value;
		window.opener.MYFORM.submit();
	}
	else
	{
		window.opener.document.getElementById("alpha").style.width="0";
		window.opener.document.getElementById("alpha").style.height="0";
	}
	self.close();
}
function setSubmit(URL)
{ 
	var skind = document.MYFORMD.TKIND.value;
	
	if (skind=="DEPT")
	{
		if ( document.MYFORMD.DEPPCODE.value=="")
		{
			alert("Please input the department code!");
			document.MYFORMD.DEPPCODE.setFoucs();
			return false;
		}
		if ( document.MYFORMD.DEPPNAME.value=="")
		{
			alert("Please input the department name!");
			document.MYFORMD.DEPPNAME.setFoucs();
			return false;
		}
	}
	else if (skind=="SALES")
	{
		if (document.MYFORMD.SALESCODE.value=="")
		{
			alert("Please input the sales code!");
			document.MYFORMD.SALESCODE.setFoucs();
			return false;		
		}
		if (document.MYFORMD.SALESNAME.value=="")
		{
			alert("Please input the sales name!");
			document.MYFORMD.SALESNAME.setFoucs();
			return false;			
		}
	}
	else if (skind=="CUST")
	{
		if (document.MYFORMD.CUSTSALES.value=="")
		{
			alert("Please input the sales code!");
			document.MYFORMD.CUSTSALES.setFoucs();
			return false;		
		}
		if ( document.MYFORMD.CUSTDEPT.value=="")
		{
			alert("Please input the department code!");
			document.MYFORMD.CUSTDEPT.setFoucs();
			return false;		
		}
		if (document.MYFORMD.CUSTCODE.value=="")
		{
			alert("Please input the customer code!");
			document.MYFORMD.CUSTCODE.setFoucs();
			return false;		
		}
		if (document.MYFORMD.CUSTNAME.value=="")
		{
			alert("Please input the customer name!");
			document.MYFORMD.CUSTNAME.setFoucs();
			return false;		
		}
	}
	else if (skind=="SUPPLIER")
	{
		if (document.MYFORMD.SUPPLIERCODE.value=="")
		{
			alert("Please input the supplier code!");
			document.MYFORMD.SUPPLIERCODE.setFoucs();
			return false;			
		}
		if ( document.MYFORMD.SUPPLIERNAME.value=="")
		{
			alert("Please input the supplier name!");
			document.MYFORMD.SUPPLIERNAME.setFoucs();
			return false;			
		}
	}
	else if (skind=="CURR")
	{
		if ( document.MYFORMD.CURRCODE.value=="")
		{
			alert("Please input the currency code!");
			document.MYFORMD.CURRCODE.setFoucs();
			return false;			
		}
		if (document.MYFORMD.TAXRATE.value=="")
		{
			alert("Please input the tax rate!");
			document.MYFORMD.TAXRATE.setFoucs();
			return false;			
		}
	}
	else if (skind=="ADDR")
	{
		if ( document.MYFORMD.K3ADDRCODE.value=="")
		{
			alert("Please input the K3 Address code!");
			document.MYFORMD.K3ADDRCODE.setFoucs();
			return false;			
		}
		if (document.MYFORMD.ERPSHIPLOCATIONID.value=="")
		{
			alert("Please choose the erp ship to location!");
			document.MYFORMD.ERPSHIPLOCATIONID.setFoucs();
			return false;			
		}
		if (document.MYFORMD.ACTIVE_FLAG1.value=="--")
		{
			alert("Please choose a status!");
			document.MYFORMD.ACTIVE_FLAG1.setFoucs();
			return false;			
		}
	}	
	else
	{
		if (document.MYFORMD.ERPCUSTCODE.value=="")
		{
			alert("Please input the erp customer number!");
			document.MYFORMD.ERPCUSTCODE.setFoucs();
			return false;			
		}
		if (document.MYFORMD.K3CUSTCODE.value=="")
		{
			alert("Please input the K3 customer code!");
			document.MYFORMD.K3CUSTCODE.setFoucs();
			return false;			
		}
		if (document.MYFORMD.ACTIVE_FLAG.value=="A" && document.MYFORMD.CUSTSNAME.value=="")
		{
			alert("Please input the customer english short name!");
			document.MYFORMD.CUSTSNAME.setFoucs();
			return false;		
		}		
		if (document.MYFORMD.ACTIVE_FLAG.value=="" || document.MYFORMD.ACTIVE_FLAG.value=="--")
		{
			alert("Please input a status!");
			document.MYFORMD.ACTIVE_FLAG.setFoucs();
			return false;		
		}		
	}
	document.MYFORMD.btnSubmit.disabled =true;
	document.MYFORMD.btnCancel.disabled =true;
	document.MYFORMD.action=URL;
 	document.MYFORMD.submit();
}
function setClear()
{
	var skind = document.MYFORMD.TKIND.value;
	
	if (skind=="DEPT")
	{
		document.MYFORMD.DEPPCODE.value="";
		document.MYFORMD.DEPPNAME.value="";
	}
	else if (skind=="SALES")
	{
		document.MYFORMD.SALESCODE.value="";
		document.MYFORMD.SALESNAME.value="";
	}
	else if (skind=="CUST")
	{
		document.MYFORMD.CUSTSALES.value="";
		document.MYFORMD.CUSTDEPT.value="";
		document.MYFORMD.CUSTCODE.value="";
		document.MYFORMD.CUSTNAME.value="";
	}
	else if (skind=="SUPPLIER")
	{
		document.MYFORMD.SUPPLIERCODE.value="";
		document.MYFORMD.SUPPLIERNAME.value="";
		document.MYFORMD.SUPPLIERODRCODE.value="";
	}
	else if (skind=="CURR")
	{
		document.MYFORMD.CURRCODE.value="";
		document.MYFORMD.TAXRATE.value="";
		document.MYFORMD.CURRERODRCODE.value="";
	}
	else if (skind=="ADDR")
	{
		document.MYFORMD.K3ADDRCODE.value="";
		document.MYFORMD.ERPCUSTCODE1.value="";
		document.MYFORMD.ERPCUSTNAME1.value="";
		document.MYFORMD.ERPCUSTID.value="";
		document.MYFORMD.ERPSHIPLOCATIONID.value="";
	}	
	else
	{
		document.MYFORMD.ERPCUSTCODE.value="";
		document.MYFORMD.ERPCUSTNAME.value="";
		document.MYFORMD.K3CUSTCODE.value="";
		document.MYFORMD.K3DEPTCODE.value="";
		document.MYFORMD.K3SALESCODE.value="";
		document.MYFORMD.CUSTSNAME.value="";
	}
}
function setCust(strcust,sobj)
{
	if (sobj=="1")
	{
		document.MYFORMD.ERPCUSTNAME1.value="";
		document.MYFORMD.ERPSHIPLOCATIONID.value="";
		document.MYFORMD.action="../jsp/TSSalesOrderBaseDataModifyK3.jsp?ERPCUSTCODE1="+strcust+"&STATUS="+document.MYFORMD.STATUS.value;
	}
	else
	{
		document.MYFORMD.ERPCUSTNAME.value="";
		document.MYFORMD.action="../jsp/TSSalesOrderBaseDataModifyK3.jsp?ERPCUSTCODE="+strcust+"&STATUS="+document.MYFORMD.STATUS.value;
	}
 	document.MYFORMD.submit();	
}

function setK3Cust(strcust)
{
	document.MYFORMD.K3DEPTCODE.value="";
    document.MYFORMD.K3SALESCODE.value="";
	//document.MYFORMD.action="../jsp/TSSalesOrderBaseDataModifyK3.jsp?K3CUSTCODE="+strcust+"&STATUS="+document.MYFORMD.STATUS.value;
	document.MYFORMD.action="../jsp/TSSalesOrderBaseDataModifyK3.jsp?ACODE=CHANGE&K3CUSTCODE="+strcust+"&STATUS="+document.MYFORMD.STATUS.value;
 	document.MYFORMD.submit();	
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<title>TSCC K3 Info Maintain</title>
</head>
<body>
<FORM NAME="MYFORMD" ACTION="../jsp/TSSalesOrderBaseDataModifyK3.jsp" METHOD="POST"> 
<%
String strKind = request.getParameter("TKIND");
if (strKind ==null) strKind ="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String strCode = request.getParameter("CODE");
if (strCode==null) strCode=""; 
String strCode1 = request.getParameter("CODE1");
if (strCode1==null) strCode1=""; 
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String ORIG_ERPCUSTCODE = request.getParameter("ORIG_ERPCUSTCODE");
if (ORIG_ERPCUSTCODE==null) ORIG_ERPCUSTCODE="";
String ERPCUSTCODE = request.getParameter("ERPCUSTCODE");
if (ERPCUSTCODE==null) ERPCUSTCODE="";
String ERPCUSTNAME = request.getParameter("ERPCUSTNAME");
if (ERPCUSTNAME==null) ERPCUSTNAME="";
String ERPCUSTID = request.getParameter("ERPCUSTID");
if (ERPCUSTID==null) ERPCUSTID="";
String K3CUSTCODE = request.getParameter("K3CUSTCODE");
if (K3CUSTCODE==null) K3CUSTCODE="";
String K3DEPTCODE = request.getParameter("K3DEPTCODE");
if (K3DEPTCODE==null) K3DEPTCODE="";
String K3SALESCODE = request.getParameter("K3SALESCODE");
if (K3SALESCODE==null) K3SALESCODE="";
String CURRCODE = request.getParameter("CURRCODE");
if (CURRCODE==null) CURRCODE="";
String TAXRATE = request.getParameter("TAXRATE");
if (TAXRATE==null) TAXRATE="";
String CURRERODRCODE = request.getParameter("CURRERODRCODE");
if (CURRERODRCODE==null) CURRERODRCODE="";
String SUPPLIERCODE = request.getParameter("SUPPLIERCODE");
if (SUPPLIERCODE==null) SUPPLIERCODE="";
String SUPPLIERNAME = request.getParameter("SUPPLIERNAME");
if (SUPPLIERNAME==null) SUPPLIERNAME="";
String SUPPLIERODRCODE = request.getParameter("SUPPLIERODRCODE");
if (SUPPLIERODRCODE==null) SUPPLIERODRCODE="";
String ERPVENDORCODE = request.getParameter("ERPVENDORCODE");
if (ERPVENDORCODE==null) ERPVENDORCODE="";
String CUSTSALES = request.getParameter("CUSTSALES");
if (CUSTSALES==null) CUSTSALES="";
String CUSTDEPT = request.getParameter("CUSTDEPT");
if (CUSTDEPT==null) CUSTDEPT="";
String CUSTCODE = request.getParameter("CUSTCODE");
if (CUSTCODE==null) CUSTCODE="";
String CUSTNAME = request.getParameter("CUSTNAME");
if (CUSTNAME==null) CUSTNAME="";
String CUSTSNAME = request.getParameter("CUSTSNAME");
if (CUSTSNAME==null) CUSTSNAME="";
String SALESCODE = request.getParameter("SALESCODE");
if (SALESCODE==null) SALESCODE="";
String SALESNAME = request.getParameter("SALESNAME");
if (SALESNAME==null) SALESNAME="";
String DEPPCODE = request.getParameter("DEPPCODE");
if (DEPPCODE==null) DEPPCODE="";
String DEPPNAME= request.getParameter("DEPPNAME");
if (DEPPNAME==null) DEPPNAME="";
String ACTIVE_FLAG = request.getParameter("ACTIVE_FLAG");
if (ACTIVE_FLAG==null) ACTIVE_FLAG="";
String K3ADDRCODE = request.getParameter("K3ADDRCODE");
if (K3ADDRCODE==null) K3ADDRCODE="";
String ERPCUSTCODE1 = request.getParameter("ERPCUSTCODE1");
if (ERPCUSTCODE1==null) ERPCUSTCODE1="";
String ERPCUSTNAME1 = request.getParameter("ERPCUSTNAME1");
if(ERPCUSTNAME1==null) ERPCUSTNAME1="";
String ACTIVE_FLAG1 = request.getParameter("ACTIVE_FLAG1");
if (ACTIVE_FLAG1==null) ACTIVE_FLAG1="";
String ERPSHIPLOCATIONID=request.getParameter("ERPSHIPLOCATIONID");
if (ERPSHIPLOCATIONID==null) ERPSHIPLOCATIONID="";
String SGSHIPLOCATIONID=request.getParameter("SGSHIPLOCATIONID");
if (SGSHIPLOCATIONID==null) SGSHIPLOCATIONID="";
String ORIG_ERPVENDORCODE=request.getParameter("ORIG_ERPVENDORCODE");
if (ORIG_ERPVENDORCODE==null) ORIG_ERPVENDORCODE="";
String sql ="",strExist="",strNoFound="";

try
{  
	if (STATUS.equals("UPD"))
	{
		if (ACODE.equals(""))
		{
			if (strKind.toUpperCase().equals("DEPT"))
			{
				sql = "SELECT DEPT_CODE,DEPT_NAME FROM ORADDMAN.TSCC_K3_DEPT WHERE DEPT_CODE=? ORDER BY DEPT_CODE";	
			}
			else if (strKind.toUpperCase().equals("SALES"))
			{
				sql = "SELECT SALES_CODE,SALES_NAME FROM ORADDMAN.TSCC_K3_SALES WHERE SALES_CODE=? ORDER BY SALES_CODE";	
			}
			else if (strKind.toUpperCase().equals("CUST"))
			{
				sql = " SELECT A.CUST_CODE,A.CUST_NAME,A.DEPT_CODE,C.DEPT_NAME,B.SALES_CODE,B.SALES_NAME "+
					  " FROM ORADDMAN.TSCC_K3_CUST A,ORADDMAN.TSCC_K3_SALES B,ORADDMAN.TSCC_K3_DEPT C"+
					  " WHERE A.DEPT_CODE=C.DEPT_CODE(+)"+
					  " AND A.SALES_CODE=B.SALES_CODE(+)"+
					  " AND A.CUST_CODE=?"+
					  " ORDER BY A.CUST_CODE";	
			}
			else if (strKind.toUpperCase().equals("SUPPLIER"))
			{
				sql = "SELECT SUPPLIER_CODE,SUPPLIER_NAME,ERP_ORDER_CODE,ERP_VENDOR_CODE FROM ORADDMAN.TSCC_K3_SUPPLIER WHERE SUPPLIER_CODE=? ORDER BY SUPPLIER_CODE";	
			}
			else if (strKind.toUpperCase().equals("CURR"))
			{
				sql = "SELECT CURRENCY_CODE,TAX_RATE,ERP_ORDER_CODE FROM ORADDMAN.TSCC_K3_CURR WHERE CURRENCY_CODE=? ORDER BY CURRENCY_CODE";	
			}
			else if (strKind.toUpperCase().equals("ADDR"))
			{
				sql = "SELECT tkale.addr_code,ac.customer_number,ac.customer_name,tkale.erp_ship_to_location_id, loc.address1 ,tkale.ACTIVE_FLAG,ac.customer_id,tkale.sg_ship_to_location_id,tkale.cust_eng_short_name"+
					  " FROM hz_cust_acct_sites acct_site,"+
					  " hz_party_sites party_site,"+
					  " hz_locations loc,"+
					  " hz_cust_site_uses_all site,"+
					  " ar_customers ac,"+
					  " oraddman.tscc_k3_addr_link_erp tkale"+
					  " WHERE site.cust_acct_site_id = acct_site.cust_acct_site_id"+
					  " AND acct_site.party_site_id = party_site.party_site_id"+
					  " AND party_site.location_id = loc.location_id"+
					  //" AND acct_site.status = 'A'"+
					  " AND acct_site.cust_account_id =ac.customer_id"+
					  //" AND site.status = 'A'"+
					  " AND to_char(site.location)=to_char(tkale.erp_ship_to_location_id)"+
					  " AND tkale.addr_code=?";
			}
			else
			{
				sql = " SELECT B.CUST_CODE,B.CUST_NAME,A.ERP_CUST_NUMBER,E.CUSTOMER_NAME,D.DEPT_CODE,D.DEPT_CODE||' '||D.DEPT_NAME as DEPT_NAME,C.SALES_CODE,C.SALES_CODE||' '|| C.SALES_NAME asSALES_NAME,A.ACTIVE_FLAG ,A.CUST_ENG_SHORT_NAME "+
					  " FROM ORADDMAN.TSCC_K3_CUST_LINK_ERP A,ORADDMAN.TSCC_K3_CUST B,ORADDMAN.TSCC_K3_SALES C,ORADDMAN.TSCC_K3_DEPT D,AR_CUSTOMERS E"+
					  " WHERE A.CUST_CODE=B.CUST_CODE(+)"+
					  " AND B.DEPT_CODE=D.DEPT_CODE(+)"+
					  " AND B.SALES_CODE=C.SALES_CODE(+)"+
					  " AND A.ERP_CUST_NUMBER=E.CUSTOMER_NUMBER(+)"+
					  " AND A.ERP_CUST_NUMBER=?"+
					  " AND B.CUST_CODE=?"; //add by Peggy 20220406
			}
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,strCode);
			if (strKind.toUpperCase().equals("ERP"))			
			{
				statement.setString(2,strCode1);
			}
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				if (strKind.toUpperCase().equals("DEPT"))
				{
					DEPPCODE = rs.getString(1);
					DEPPNAME = rs.getString(2);
				}
				else if (strKind.toUpperCase().equals("SALES"))
				{
					SALESCODE = rs.getString(1);
                    SALESNAME = rs.getString(2);
				}
				else if (strKind.toUpperCase().equals("CUST"))
				{
					CUSTCODE  = rs.getString(1);
					CUSTNAME  = rs.getString(2);
                    CUSTDEPT  = rs.getString(3);
                    CUSTSALES = rs.getString(4);
				}
				else if (strKind.toUpperCase().equals("SUPPLIER"))
				{
					SUPPLIERCODE    = rs.getString(1);
					SUPPLIERNAME    = rs.getString(2);
					SUPPLIERODRCODE	= rs.getString(3);	
					ERPVENDORCODE   = rs.getString(4);		
				}
				else if (strKind.toUpperCase().equals("CURR"))
				{
					CURRCODE      = rs.getString(1);
                    TAXRATE       = rs.getString(2);
                    CURRERODRCODE = rs.getString(3);
				}
				else if (strKind.toUpperCase().equals("ADDR"))
				{
					K3ADDRCODE        = rs.getString(1);
					ACTIVE_FLAG1      = rs.getString(6);
					if (!ERPCUSTCODE1.equals("") && !rs.getString(2).equals(ERPCUSTCODE1))
					{
						ERPSHIPLOCATIONID="";
						sql = " SELECT CUSTOMER_NAME,CUSTOMER_ID FROM AR_CUSTOMERS A"+
							  " WHERE CUSTOMER_NUMBER=?";
						//out.println(sql);
						PreparedStatement statement1 = con.prepareStatement(sql);
						statement1.setString(1,ERPCUSTCODE1);
						ResultSet rs1=statement1.executeQuery();
						if (rs1.next())
						{
							ERPCUSTNAME1=rs1.getString(1);
							ERPCUSTID=rs1.getString(2);
						}
						else
						{
							ERPCUSTNAME1="";ERPCUSTID="";
						}
						rs1.close();
						statement1.close();
					}			
					else
					{
						ERPCUSTCODE1      = rs.getString(2);
						ERPCUSTNAME1      = rs.getString(3);
						ERPSHIPLOCATIONID = rs.getString(4);
						ERPCUSTID         = rs.getString(7);
						SGSHIPLOCATIONID  = rs.getString(8); //add by Peggy 20200121
					}
					CUSTSNAME    = rs.getString(9);  //add by Peggy 20240408
					if (CUSTSNAME==null) CUSTSNAME="";
				}
				else
				{
					ERPCUSTCODE  = rs.getString(3);
					ORIG_ERPCUSTCODE = rs.getString(3);
					ERPCUSTNAME  = rs.getString(4);
                    K3CUSTCODE   = rs.getString(1);
                    K3DEPTCODE   = rs.getString(6);
                    K3SALESCODE	 = rs.getString(8);
					ACTIVE_FLAG  = rs.getString(9);
                    CUSTSNAME    = rs.getString(10);  //add by Peggy 20211229
					if (CUSTSNAME==null) CUSTSNAME="";
				}
			}
			else
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("No Data Found!");
					setCancel();
				</script>
			<%				
			}
			rs.close();
			statement.close();
		}
		else
		{
			if (!K3CUSTCODE.equals("") && (K3DEPTCODE.equals("") || K3SALESCODE.equals("")))
			{
				sql = " SELECT A.DEPT_CODE || ' '||C.DEPT_NAME DEPT_NAME,B.SALES_CODE||' '|| B.SALES_NAME  SALES_NAME"+
					  " FROM ORADDMAN.TSCC_K3_CUST A"+
					  ",ORADDMAN.TSCC_K3_SALES B"+
					  ",ORADDMAN.TSCC_K3_DEPT C"+
					  " WHERE A.DEPT_CODE=C.DEPT_CODE(+)"+
					  " AND A.SALES_CODE=B.SALES_CODE(+)"+
					  " AND A.CUST_CODE=?"+
					  " ORDER BY A.CUST_CODE";				
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,K3CUSTCODE);
				ResultSet rs=statement.executeQuery();
				if (rs.next())
				{
					K3DEPTCODE   = rs.getString(1);
					K3SALESCODE	 = rs.getString(2);			
				}
				else
				{
					K3DEPTCODE=""; K3SALESCODE="";
				}
				rs.close();
				statement.close();		
			}
		}
	}
	else
	{
		if (!ERPCUSTCODE1.equals("") && ERPCUSTNAME1.equals(""))
		{
			sql = " SELECT CUSTOMER_NAME,CUSTOMER_ID FROM AR_CUSTOMERS A"+
				  " WHERE CUSTOMER_NUMBER=?";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,ERPCUSTCODE1);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				ERPCUSTNAME1=rs.getString(1);
				ERPCUSTID =rs.getString(2);
			}
			else
			{
				ERPCUSTNAME1="";ERPCUSTID="";
			}
			rs.close();
			statement.close();
		}	
		if (!ERPCUSTCODE.equals("") && ERPCUSTNAME.equals(""))
		{
			sql = " SELECT CUSTOMER_NAME FROM AR_CUSTOMERS A"+
				  " WHERE CUSTOMER_NUMBER=?";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,ERPCUSTCODE);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				ERPCUSTNAME=rs.getString(1);
			}
			else
			{
				ERPCUSTNAME="";
			}
			rs.close();
			statement.close();
		}
		if (!K3CUSTCODE.equals("") && (K3DEPTCODE.equals("") || K3SALESCODE.equals("")))
		{
			sql = " SELECT A.DEPT_CODE || ' '||C.DEPT_NAME DEPT_NAME,B.SALES_CODE||' '|| B.SALES_NAME  SALES_NAME"+
				  " FROM ORADDMAN.TSCC_K3_CUST A"+
				  ",ORADDMAN.TSCC_K3_SALES B"+
				  ",ORADDMAN.TSCC_K3_DEPT C"+
				  " WHERE A.DEPT_CODE=C.DEPT_CODE(+)"+
				  " AND A.SALES_CODE=B.SALES_CODE(+)"+
				  " AND A.CUST_CODE=?"+
				  " ORDER BY A.CUST_CODE";				
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,K3CUSTCODE);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				K3DEPTCODE   = rs.getString(1);
                K3SALESCODE	 = rs.getString(2);			
			}
			else
			{
				K3DEPTCODE=""; K3SALESCODE="";
			}
			rs.close();
			statement.close();		
		}
	}
	
%>
<input type="hidden" name="STATUS" value="<%=STATUS%>">
<input type="hidden" name="CODE" value="<%=strCode%>">
<input type="hidden" name="CODE1" value="<%=strCode1%>">
<input type="hidden" name="TKIND" value="<%=strKind%>">
<table align="center" width="100%">
	<tr>
		<td align="center"><font color="#003399" size="+2"><strong>TSCC K3 Info Modify </strong></font></td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<%
				if (strKind.toUpperCase().equals("DEPT"))
				{
				%>
					<tr><td bgcolor="#C9E2D0">Dept Code</td><td><input type="text" name="DEPPCODE" value="<%=DEPPCODE%>" style="font-family:Tahoma,Georgia" <%=(STATUS.equals("UPD")?" onKeypress="+'"'+"return (event.keyCode <>-1)"+'"'+" readonly":"")%>></td></tr>
					<tr><td bgcolor="#C9E2D0">Dept Name</td><td><input type="text" name="DEPPNAME" value="<%=DEPPNAME%>" style="font-family:Tahoma,Georgia" size="50"></td></tr>
				<%
				}
				else if (strKind.toUpperCase().equals("SALES"))
				{
				%>
					<tr><td bgcolor="#C9E2D0">Sales Code</td><td><input type="text" name="SALESCODE" value="<%=SALESCODE%>" style="font-family:Tahoma,Georgia" <%=(STATUS.equals("UPD")?" onKeypress="+'"'+"return (event.keyCode <>-1)"+'"'+" readonly":"")%>></td></tr>
					<tr><td bgcolor="#C9E2D0">Sales Name</td><td><input type="text" name="SALESNAME" value="<%=SALESNAME%>" style="font-family:Tahoma,Georgia" size="50"></td></tr>
				<%
				}
				else if (strKind.toUpperCase().equals("CUST"))
				{
				%>
					<tr><td bgcolor="#C9E2D0">Cust Code</td><td><input type="text" name="CUSTCODE" value="<%=CUSTCODE%>" style="font-family:Tahoma,Georgia" <%=(STATUS.equals("UPD")?" onKeypress="+'"'+"return (event.keyCode <>-1)"+'"'+" readonly":"")%>></td></tr>
					<tr><td bgcolor="#C9E2D0">Cust Name</td><td><input type="text" name="CUSTNAME" value="<%=CUSTNAME%>" style="font-family:Tahoma,Georgia" size="50"></td></tr>
					<tr><td bgcolor="#C9E2D0">Dept Name</td><td>
					<%
					try
					{
						sql = " SELECT a.dept_code, a.dept_code||' '|| a.dept_name as dept_name FROM oraddman.tscc_k3_dept a ORDER BY DEPT_CODE";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(CUSTDEPT);
						comboBoxBean.setFieldName("CUSTDEPT");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>						
					</td></tr>
					<tr><td bgcolor="#C9E2D0">Sales Name</td><td>
					<%
					try
					{
						sql = " SELECT a.sales_code, a.sales_code|| ' '|| a.sales_name as sales_name FROM oraddman.tscc_k3_sales a  order by sales_code";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(CUSTSALES);
						comboBoxBean.setFieldName("CUSTSALES");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>						
					</td></tr>
					
				<%
				}
				else if (strKind.toUpperCase().equals("SUPPLIER"))
				{
				%>
					<tr><td bgcolor="#C9E2D0">Supplier Code</td><td><input type="text" name="SUPPLIERCODE" value="<%=SUPPLIERCODE%>" style="font-family:Tahoma,Georgia" <%=(STATUS.equals("UPD")?" onKeypress="+'"'+"return (event.keyCode <>-1)"+'"'+" readonly":"")%>></td></tr>
					<tr><td bgcolor="#C9E2D0">Supplier Name</td><td><input type="text" name="SUPPLIERNAME" value="<%=SUPPLIERNAME%>" style="font-family:Tahoma,Georgia" size="50"></td></tr>
					<tr><td bgcolor="#C9E2D0">ERP Order Number</td><td><input type="text" name="SUPPLIERODRCODE" value="<%=(SUPPLIERODRCODE==null?"":SUPPLIERODRCODE)%>" style="font-family:Tahoma,Georgia"></td></tr>
					<tr><td bgcolor="#C9E2D0">ERP Vendor Number</td><td><input type="text" name="ERPVENDORCODE" value="<%=(ERPVENDORCODE==null?"":ERPVENDORCODE)%>" style="font-family:Tahoma,Georgia"><input type="hidden" name="ORIG_ERPVENDORCODE" value="<%=(ERPVENDORCODE==null?"":ERPVENDORCODE)%>"></td></tr>
				<%
				}
				else if (strKind.toUpperCase().equals("CURR"))
				{
				%>
					<tr><td bgcolor="#C9E2D0">Currency Code</td><td><input type="text" name="CURRCODE" value="<%=CURRCODE%>" style="font-family:Tahoma,Georgia" <%=(STATUS.equals("UPD")?" onKeypress="+'"'+"return (event.keyCode <>-1)"+'"'+" readonly":"")%>></td></tr>
					<tr><td bgcolor="#C9E2D0">Tax Rate</td><td><input type="text" name="TAXRATE" value="<%=TAXRATE%>" style="font-family:Tahoma,Georgia"></td></tr>
					<tr><td bgcolor="#C9E2D0">ERP Order Number</td><td><input type="text" name="CURRERODRCODE" value="<%=(CURRERODRCODE==null?"":CURRERODRCODE)%>" style="font-family:Tahoma,Georgia"></td></tr>
				<%
				}
				else if (strKind.toUpperCase().equals("ADDR"))
				{	
				%>
					<tr><td bgcolor="#C9E2D0">K3 Addr Code</td><td><input type="text" name="K3ADDRCODE" value="<%=K3ADDRCODE%>" style="font-family:Tahoma,Georgia" <%=(STATUS.equals("UPD")?" onKeypress="+'"'+"return (event.keyCode <>-1)"+'"'+" readonly":"")%>></td></tr>
					<tr><td bgcolor="#C9E2D0">ERP Cust Name</td><td><input type="text" name="ERPCUSTCODE1" value="<%=ERPCUSTCODE1%>" style="font-family:Tahoma,Georgia;font-size:12px" size="5" onChange="setCust(this.value,1)">
					<input type="text" name="ERPCUSTNAME1" value="<%=ERPCUSTNAME1%>" style="font-family:Tahoma,Georgia;font-size:12px" size="50" readonly><input type="hidden" name="ERPCUSTID" value="<%=ERPCUSTID%>">
					</td></tr>
					<tr><td bgcolor="#C9E2D0">ERP Ship To</td>
					<td>
					<%
					try
					{
						CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
						cs1.setString(1,"325");  // 取業務員隸屬ParOrgID
						cs1.execute();
						cs1.close();							
					
						sql = " SELECT site.location,site.location||' '|| loc.address1 address"+
                              " FROM hz_cust_acct_sites acct_site,"+
                              " hz_party_sites party_site,"+
                              " hz_locations loc,"+
                              " hz_cust_site_uses_all site,"+
                              " ar_customers ac"+
                              " WHERE site.cust_acct_site_id = acct_site.cust_acct_site_id"+
                              " AND acct_site.party_site_id = party_site.party_site_id"+
                              " AND party_site.location_id = loc.location_id"+
                              " AND acct_site.status = 'A'"+
                              " AND acct_site.cust_account_id =ac.customer_id"+
                              " AND site.status = 'A'"+
                              " AND site.site_use_code='SHIP_TO'"+
                              " AND ac.customer_number='"+ERPCUSTCODE1+"'"+
							  " order by site.location";
						//out.println(sql);
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(ERPSHIPLOCATIONID);
						comboBoxBean.setFieldName("ERPSHIPLOCATIONID");	
						comboBoxBean.setFontName("Tahoma,Georgia");  
						//comboBoxBean.setOnChangeJS("setK3Cust(this.value)");
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>					
					</td></tr>
					<tr><td bgcolor="#C9E2D0">SG Ship To</td>
					<td>
					<%
					try
					{
						CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
						cs1.setString(1,"906");  // 取業務員隸屬ParOrgID
						cs1.execute();
						cs1.close();							
					
						sql = " SELECT site.location,site.location||' '|| loc.address1 address"+
                              " FROM hz_cust_acct_sites acct_site,"+
                              " hz_party_sites party_site,"+
                              " hz_locations loc,"+
                              " hz_cust_site_uses_all site,"+
                              " ar_customers ac"+
                              " WHERE site.cust_acct_site_id = acct_site.cust_acct_site_id"+
                              " AND acct_site.party_site_id = party_site.party_site_id"+
                              " AND party_site.location_id = loc.location_id"+
                              " AND acct_site.status = 'A'"+
                              " AND acct_site.cust_account_id =ac.customer_id"+
                              " AND site.status = 'A'"+
                              " AND site.site_use_code='SHIP_TO'"+
                              " AND ac.customer_number='"+ERPCUSTCODE1+"'"+
							  " order by site.location";
						//out.println(sql);
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(SGSHIPLOCATIONID);
						comboBoxBean.setFieldName("SGSHIPLOCATIONID");	
						comboBoxBean.setFontName("Tahoma,Georgia");  
						//comboBoxBean.setOnChangeJS("setK3Cust(this.value)");
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     
						
						cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
						cs1.setString(1,"325");  // 取業務員隸屬ParOrgID
						cs1.execute();
						cs1.close();							 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>					
					</td></tr>
					<tr><td bgcolor="#C9E2D0">Cust Eng Short Name</td><td><input type="text" name="CUSTSNAME" value="<%=CUSTSNAME%>" style="font-family:Tahoma,Georgia" size="50"></td></tr>
					<tr><td bgcolor="#C9E2D0">Active Flag</td>
					<td>
					<select NAME="ACTIVE_FLAG1" style="Tahoma,Georgia; font-size: 12px ">
					<OPTION VALUE=-- <%if (ACTIVE_FLAG1.equals("")) out.println("selected");%>>--</OPTION>
					<OPTION VALUE="A" <%if (ACTIVE_FLAG1.equals("A")) out.println("selected");%>>Active</OPTION>
					<OPTION VALUE="I" <%if (ACTIVE_FLAG1.equals("I")) out.println("selected");%>>Inactive</OPTION>
					</select>					
					</td></tr>
					
				<%
				}
				else
				{
				%>
					<tr><td bgcolor="#C9E2D0">ERP Cust Name</td><td><input type="text" name="ERPCUSTCODE" value="<%=ERPCUSTCODE%>" style="font-family:Tahoma,Georgia;font-size:12px" size="5" onChange="setCust(this.value,0)"><input type="hidden" name="ORIG_ERPCUSTCODE" value="<%=ORIG_ERPCUSTCODE%>">
					<input type="text" name="ERPCUSTNAME" value="<%=ERPCUSTNAME%>" style="font-family:Tahoma,Georgia;font-size:12px" size="50" readonly>
					</td></tr>
					<tr><td bgcolor="#C9E2D0">Cust Name</td>
					<td>
					<%
					try
					{
						sql = " SELECT a.cust_code, a.cust_code||' '||a.cust_name cust_name"+
                              " FROM oraddman.tscc_k3_cust a where a.cust_code is not null";
						if (!STATUS.equals("UPD"))							  
						{
                        	sql += " and not exists (select 1 from oraddman.tscc_k3_cust_link_erp b where b.cust_code=a.cust_code and b.active_flag='A')";
						}
						sql += " order by a.cust_code";
						//out.println(sql);
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(K3CUSTCODE);
						comboBoxBean.setFieldName("K3CUSTCODE");	
						comboBoxBean.setFontName("Tahoma,Georgia");  
						comboBoxBean.setOnChangeJS("setK3Cust(this.value)");
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>					
					</td></tr>
					<tr><td bgcolor="#C9E2D0">Cust Eng Short Name</td><td><input type="text" name="CUSTSNAME" value="<%=CUSTSNAME%>" style="font-family:Tahoma,Georgia" size="50"></td></tr>
					<tr><td bgcolor="#C9E2D0">Dept Name</td><td><input type="text" name="K3DEPTCODE" value="<%=K3DEPTCODE%>" style="font-family:Tahoma,Georgia"  onKeypress="return (event.keyCode <>-1)" readonly></td></tr>
					<tr><td bgcolor="#C9E2D0">Sales Name</td><td><input type="text" name="K3SALESCODE" value="<%=K3SALESCODE%>" style="font-family:Tahoma,Georgia" onKeypress="return (event.keyCode <>-1)" readonly )></td></tr>
					<tr><td bgcolor="#C9E2D0">Active Flag</td>
					<td>
					<select NAME="ACTIVE_FLAG" style="Tahoma,Georgia; font-size: 12px ">
					<OPTION VALUE=-- <%if (ACTIVE_FLAG.equals("")) out.println("selected");%>>--</OPTION>
					<OPTION VALUE="A" <%if (ACTIVE_FLAG.equals("A")) out.println("selected");%>>Active</OPTION>
					<OPTION VALUE="I" <%if (ACTIVE_FLAG.equals("I")) out.println("selected");%>>Inactive</OPTION>
					</select>					
					</td></tr>
				<%
				}
				%>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
  				<tr align=center>
    				<td width="16%"> <input type="button"  name="btnSubmit" onClick="setSubmit('../jsp/TSSalesOrderBaseDataModifyK3.jsp?ACODE=SAVE&TKIND=<%=strKind%>&CODE=<%=strCode%>&STATUS=<%=STATUS%>')" value="Save" style="font-family:Tahoma,Georgia;font-size:12px">&nbsp;&nbsp;&nbsp;
     								<input type="button" name="btnCancel" onClick="setCancel()" value="Close Window" style="font-family:Tahoma,Georgia;font-size:12px">
					</td>    
  				</tr>
			</table>
		</td>
	</tr>
</table>
<%
	if (ACODE.equals("SAVE"))
	{
		try
		{
			if (STATUS.equals("UPD"))
			{
				if (strKind.toUpperCase().equals("DEPT"))
				{
					sql= " update oraddman.TSCC_K3_DEPT "+
						 " set DEPT_NAME=?"+
						 " where DEPT_CODE = ?";
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,DEPPNAME);
					st1.setString(2,DEPPCODE); 
					st1.executeUpdate();
					st1.close();				
				}
				else if (strKind.toUpperCase().equals("SALES"))
				{
					sql= " update oraddman.TSCC_K3_SALES "+
						 " set SALES_NAME=?"+
						 " where SALES_CODE = ?";
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,SALESNAME);
					st1.setString(2,SALESCODE); 
					st1.executeUpdate();
					st1.close();				
				}
				else if (strKind.toUpperCase().equals("CUST"))
				{
					sql= " update oraddman.TSCC_K3_CUST "+
						 " set CUST_NAME=?"+
						 ",DEPT_CODE=?"+
						 ",SALES_CODE=?"+
						 " where CUST_CODE=?";
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,CUSTNAME);
					st1.setString(2,CUSTDEPT); 
					st1.setString(3,CUSTSALES);
					st1.setString(4,CUSTCODE);
					st1.executeUpdate();
					st1.close();				
				}
				else if (strKind.toUpperCase().equals("SUPPLIER"))
				{
					sql= " update oraddman.TSCC_K3_SUPPLIER"+
						 " set SUPPLIER_NAME=?"+
						 ",ERP_ORDER_CODE=?"+
						 ",ERP_VENDOR_CODE=?"+
						 " where SUPPLIER_CODE = ?"+
						 " AND ERP_VENDOR_CODE = ?";
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,SUPPLIERNAME);
					st1.setString(2,SUPPLIERODRCODE); 
					st1.setString(3,ERPVENDORCODE);
					st1.setString(4,SUPPLIERCODE);
					st1.setString(5,ORIG_ERPVENDORCODE);
					st1.executeUpdate();
					st1.close();				
				}
				else if (strKind.toUpperCase().equals("CURR"))
				{
					sql= " update oraddman.TSCC_K3_CURR "+
						 " set TAX_RATE=?"+
						 ",ERP_ORDER_CODE=?"+
						 " where CURRENCY_CODE = ?";
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,TAXRATE);
					st1.setString(2,CURRERODRCODE); 
					st1.setString(3,CURRCODE);
					st1.executeUpdate();
					st1.close();				
				}
				else if (strKind.toUpperCase().equals("ADDR"))
				{
					sql= " update oraddman.TSCC_K3_ADDR_LINK_ERP "+
						 " set ERP_SHIP_TO_LOCATION_ID=?"+
						 ",ACTIVE_FLAG=?"+
						 ",ERP_CUSTOMER_ID=?"+
						 ",SG_SHIP_TO_LOCATION_ID=?"+
						 ",CUST_ENG_SHORT_NAME=?"+ //add by Peggy 20240408
						 " where ADDR_CODE = ?";
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,(ERPSHIPLOCATIONID.equals("")||ERPSHIPLOCATIONID.equals("--")?null:ERPSHIPLOCATIONID));
					st1.setString(2,ACTIVE_FLAG1); 
					st1.setString(3,ERPCUSTID); 
					st1.setString(4,SGSHIPLOCATIONID);
					st1.setString(5,CUSTSNAME); 
					st1.setString(6,K3ADDRCODE); 
					st1.executeUpdate();
					st1.close();				
				}
				else
				{
					sql = " select count(1) from oraddman.TSCC_K3_CUST_LINK_ERP a"+
					      " where ERP_CUST_NUMBER=?"+
						  " and ERP_CUST_NUMBER<>?";
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,ERPCUSTCODE);
					statement.setString(2,ORIG_ERPCUSTCODE);
					ResultSet rs=statement.executeQuery();
					if (rs.next())
					{
						if (rs.getInt(1)>0)
						{
							rs.close();
							statement.close();	
							throw new Exception("ERP Customer exists in system!");
						}
					}
					rs.close();
					statement.close();		
										  
					sql= " update oraddman.TSCC_K3_CUST_LINK_ERP "+
						 " set CUST_CODE=?"+
						 ",ACTIVE_FLAG=?"+
						 ",ERP_CUST_NUMBER=?"+
						 ",CUST_ENG_SHORT_NAME=?"+
						 " where ERP_CUST_NUMBER = ?"+
						 " and CUST_CODE=?";
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,K3CUSTCODE);
					st1.setString(2,ACTIVE_FLAG); 
					st1.setString(3,ERPCUSTCODE); 
					st1.setString(4,CUSTSNAME); 
					st1.setString(5,ORIG_ERPCUSTCODE);
					st1.setString(6,K3CUSTCODE);
					st1.executeUpdate();
					st1.close();				
				}

			%>
				<script language = "JavaScript">
					alert("Save successfully!!");
					window.opener.MYFORM.action="../jsp/TSSalesOrderBaseDataSetupK3.jsp?TKIND="+document.MYFORMD.TKIND.value;					
					window.opener.MYFORM.submit();
					setCancel();
				</script>
			<%				
			}
			else
			{
				if (strKind.toUpperCase().equals("DEPT"))
				{
					sql = " insert into ORADDMAN.TSCC_K3_DEPT "+
						  " (DEPT_CODE"+
						  ",DEPT_NAME"+
						  " )"+
						  " values"+
						  "("+
						  " ?"+
						  ",?)";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,DEPPCODE);	
					st1.setString(2,DEPPNAME);
					st1.executeUpdate();
					st1.close();
				}
				else if (strKind.toUpperCase().equals("SALES"))
				{
					sql = " insert into ORADDMAN.TSCC_K3_SALES "+
						  " (SALES_CODE"+
						  ",SALES_NAME"+
						  " )"+
						  " values"+
						  "("+
						  " ?"+
						  ",?)";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,SALESCODE);	
					st1.setString(2,SALESNAME);
					st1.executeUpdate();
					st1.close();				
				}
				else if (strKind.toUpperCase().equals("CUST"))
				{
					sql = " insert into ORADDMAN.TSCC_K3_CUST"+
						  " (CUST_CODE	"+
						  ",CUST_NAME"+
						  ",DEPT_CODE"+
						  ",SALES_CODE"+
						  " )"+
						  " values"+
						  " ("+
						  " ?"+
						  ",?"+
						  ",?"+
						  ",?)";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,CUSTCODE);	
					st1.setString(2,CUSTNAME);
					st1.setString(3,CUSTDEPT);
					st1.setString(4,CUSTSALES);
					st1.executeUpdate();
					st1.close();
				}
				else if (strKind.toUpperCase().equals("SUPPLIER"))
				{
					sql = " insert into ORADDMAN.TSCC_K3_SUPPLIER"+
						  " (SUPPLIER_CODE	"+
						  ",SUPPLIER_NAME"+
						  ",ERP_ORDER_CODE"+
						  ",ERP_VENDOR_CODE"+
						  " )"+
						  " values"+
						  " ("+
						  " ?"+
						  ",?"+
						  ",?"+
						  ",?)";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,SUPPLIERCODE);	
					st1.setString(2,SUPPLIERNAME);
					st1.setString(3,SUPPLIERODRCODE);
					st1.setString(4,ERPVENDORCODE);
					st1.executeUpdate();
					st1.close();				
				}
				else if (strKind.toUpperCase().equals("CURR"))
				{
					sql = " insert into ORADDMAN.TSCC_K3_CURR"+
						  " (CURRENCY_CODE"+
						  ",TAX_RATE"+
						  ",ERP_ORDER_CODE"+
						  " )"+
						  " values"+
						  " ("+
						  " ?"+
						  ",?"+
						  ",?)";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,CURRCODE);	
					st1.setString(2,TAXRATE);
					st1.setString(3,CURRERODRCODE);
					st1.executeUpdate();
					st1.close();				
				}
				else if (strKind.toUpperCase().equals("ADDR"))
				{
					sql = " insert into ORADDMAN.TSCC_K3_ADDR_LINK_ERP"+
						  " (ADDR_CODE"+
						  ",ERP_SHIP_TO_LOCATION_ID"+
						  ",ACTIVE_FLAG"+
						  ",ERP_CUSTOMER_ID"+
						  ",SG_SHIP_TO_LOCATION_ID"+
						  ",CUST_ENG_SHORT_NAME"+
						  " )"+
						  " values"+
						  " ("+
						  " ?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?)";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,K3ADDRCODE);	
					st1.setString(2,ERPSHIPLOCATIONID);
					st1.setString(3,ACTIVE_FLAG1);
					st1.setString(4,ERPCUSTID);
					st1.setString(5,SGSHIPLOCATIONID);
					st1.setString(6,CUSTSNAME);
					st1.executeUpdate();
					st1.close();				
				
				}
				else
				{
					sql = " select count(1) from oraddman.TSCC_K3_CUST_LINK_ERP a"+
							  " where ERP_CUST_NUMBER=?";
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,ERPCUSTCODE);
					ResultSet rs=statement.executeQuery();
					if (rs.next())
					{
						if (rs.getInt(1)>0)
						{
							rs.close();
							statement.close();	
							throw new Exception("ERP Customer exists in system!");
						}
					}
					rs.close();
					statement.close();					
						
					sql = " insert into ORADDMAN.TSCC_K3_CUST_LINK_ERP"+
						  " ("+
						  " CUST_CODE"+
						  ",ERP_CUST_NUMBER"+
						  ",CUST_ENG_SHORT_NAME"+
						  ",ACTIVE_FLAG"+
						  " )"+
						  " values"+
						  " ("+
						  " ?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  " )";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,K3CUSTCODE);	
					st1.setString(2,ERPCUSTCODE);
					st1.setString(3,CUSTSNAME);
					st1.setString(4,ACTIVE_FLAG);
					st1.executeUpdate();
					st1.close();				
				}
			
				out.println("<div align='center' style='color:#0000ff'>Save successfully!!</div>");
		%>
				<script language="javascript">
					setClear();
				</script>
		<%
			}
		}
		catch(Exception e)
		{
			out.println("<div align='center' style='color:#ff0000'>Error:"+e.getMessage()+"</div>");
		}
	}
}
catch(Exception e)
{
	out.println("<div align='center' style='color:#ff0000'>Exception1:"+e.getMessage()+"</DIV>");
}
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
