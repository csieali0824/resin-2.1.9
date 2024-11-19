<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean"%>
<%@ page import="CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,ArrayComboBoxBean,DateBean,ArrayCheckInputBoxBean"%>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="arrayCheckInputBoxBean" scope="session" class="ArrayCheckInputBoxBean"/>

<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>

<script language="JavaScript" type="text/JavaScript">
/*
function btnCustomerInfo()
{ 
  subWin=window.open("subwindow/CustomerInfoSubWindow.jsp","subwin","width=480,height=400,scrollbars=yes,menubar=no");  
}
function btnItemInfo()
{ 
  subWin=window.open("subwindow/AddMaterialSubWindow.jsp?FIRST=Y","subwin","width=600,height=400,scrollbars=yes,menubar=no");  
}
function btnAddJam()
{ 
  subWin=window.open("subwindow/AddJamCodeSubWindow.jsp","subwin","width=480,height=400,scrollbars=yes,menubar=no");  
}
function setSubmit(URL)
{ 
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
  

*/
var chkflag="false";

function setSubmit(URL)
{ 
	chkflag = "true"; 
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function submitCheck()
{ 
	/*
	if (chkflag=="false")  
	{
		alert("請先存檔後再執行動作!!");   
		return(false);
	} 
	*/
	
	if (document.MYFORM.ACTIONID.value=="--" || document.MYFORM.ACTIONID.value==null)
	{ 
		alert("請先選擇您欲執行之動作後再執行!!");   
		return(false);
	
	} 
		
	flag=confirm("執行前存檔了嗎?");
	if (flag) {
		
		if (document.MYFORM.ACTIONID.value=="004")  //表示為CANCE動作
		{ 
			flag=confirm("確定要REJECT?");      
			if (flag==false)  return(false);
		}   
		
		document.MYFORM.submit();    
	}
	else return(false);
} 

</script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>INVBatchIssPage.jsp</title>
</head>
<body>
<FORM ACTION="/wins/jsp/INVProcessACT.jsp" METHOD="post" NAME="MYFORM" onSubmit='return submitCheck()'>
  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> &nbsp;&nbsp <BR>
  <font color="#0080FF" size="5"><strong>批次領料單確認</strong></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 

<%
	arrayCheckInputBoxBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
	
	String ISSCREATENO=request.getParameter("ISSCREATENO");
	String ISSCENTERNO="";
	String ISSCREATEDATE="";
	String ISSCREATEUSER="";
	String REMARK="";
	String ISSSTATID="";
	String ISSSTAT="";
	String USERNAME=""; 
	//String sFlag="0";	 
	String sFlag=request.getParameter("SAVE");
	if (sFlag==null) { sFlag = "0"; }
	//out.println(sFlag);
	String sRec=request.getParameter("RECCNT");	
	//out.println(sRec);
	int nRec = 0;
	if (sRec!=null) {nRec=Integer.parseInt(sRec);}
	//out.println(nRec);
	int i=0; 

try
    {		 
	   String sWhs = "";
	   if (sFlag.equals("1")) {
		   //Statement stateP=con.createStatement();
		   //ResultSet rsP=stateP.executeQuery("select * from INV_M_IDTL where ISSCREATENO='"+ISSCREATENO+"' order by ISNO");	   
		   //while (rsP.next())
		   while (i<nRec)
		   {	
			  //out.println(i);
			  String remloc=request.getParameter("REMLOC"+i);
			  String sItem=request.getParameter("ITEM"+i);			  
			  //String remloc=rsP.getString("ISSLOC");
			  i=i+1;
			  //out.println(remloc);
		
			  //if (remloc!=null && !remloc.equals("--") && !remloc.equals("")) 
			  if (remloc==null || remloc.equals("--"))  { sWhs=""; remloc=""; }	 // end if (remloc)
			  else { 
				  int index = remloc.indexOf("-");
				  sWhs=remloc.substring(0,index); 
				  remloc=remloc.substring(index+1,remloc.length());
			  }
				  //String loc1=remloc.substring(3,remloc.length());	   
				  
				  //String sqlV = "select VNDDESC from INV_VND where VNDNO='"+loc1+"' ";		
				   
				 // Statement stateV=con.createStatement();		 
				  //ResultSet rsV=stateV.executeQuery(sqlV);
				  //if (rsV.next()==false)
				  //{}
				  //else
				  //{
					  //String Vendor=rsV.getString("VNDDESC");
					  
					  //String sqlS = "select a.WHSWHS WHS,a.WHSLOC LOC from INV_WHS a,INV_VND b  where b.VNDNO=substr(a.WHSLOC,4,3) and b.VNDDESC='"+Vendor+"' ";		 
					  //String sqlS = "select WHSWHS WHS,WHSLOC LOC from INV_WHS where WHSLOC='"+remloc+"' ";		 
					  //Statement stateS=con.createStatement();
					  //ResultSet rsS=stateS.executeQuery(sqlS);
		
					  //if (rsS.next())
					  //{
						String sqlN="update INV_M_IDTL set ISSWHS=?,ISSLOC=? "+
						" where ISSCREATENO = '"+ISSCREATENO+ "'"+
						//"' and ISSITEMNO = '"+rsP.getString("ISSITEMNO")+"' ";
						" AND ISSITEMNO='"+sItem+"'";
						PreparedStatement pstmtN=con.prepareStatement(sqlN);  
						//pstmtN.setString(1,rsS.getString("WHS"));    
						//pstmtN.setString(2,rsS.getString("LOC"));
						pstmtN.setString(1,sWhs);
						pstmtN.setString(2,remloc);
						pstmtN.executeUpdate(); 
						pstmtN.close();	 
						//sFlag="Y";  
					  //} // end if (rsS.next())
					  
					  //rsS.close();
					  //stateS.close();	  	
				  //} // end else (rsV.next())
				  //rsV.close();
				  //stateV.close();			
				//  } // end if (remloc)  	     
		   } // end while
		   //rsP.close(); 
		   //stateP.close();  
	   } // end if (sSave.equals("1"))
   }//end of try
catch (Exception e) {out.println("Exception:"+e.getMessage()); }	   
%>

  
<%
  
try	{
  	Statement statement9=con.createStatement();
    ResultSet rs9=statement9.executeQuery("select ISSCREATENO from INV_M_ISS WHERE ISSCREATENO='"+ISSCREATENO+"'");
	//rsBean.setRs(rs9);
   
	if(rs9.next())
	{
		if (ISSCREATENO != null)
		{
		   
			Statement statement=con.createStatement();
			String sql="select ISSCREATENO,ISSCREATEDATE,ISSCREATEUSER,ISSSTATID,ISSSTAT "+
			" from INV_M_ISS"+
			" where ISSCREATENO='"+ISSCREATENO+"' ";
			ResultSet rs=statement.executeQuery(sql);
			rs.next();
			ISSCREATENO=rs.getString("ISSCREATENO");
			//ISSCENTERNO=rs.getString("ACTCENTERNO");
			ISSCREATEDATE=rs.getString("ISSCREATEDATE");
			ISSCREATEUSER=rs.getString("ISSCREATEUSER");
			ISSSTATID=rs.getString("ISSSTATID");
			ISSSTAT=rs.getString("ISSSTAT");
			USERNAME=UserName;

 	 //rs=statement.executeQuery("select * from INV_M_HISTORY WHERE RECCREATENO='"+ISSCREATENO+"' ");	
	 //while (rs.next())
	 //{ 
	   //REMARK=rs.getString("REMARK");
	 //}
			 rs.close();
			 statement.close();
		
		} //end of if
	}//end of if
}//end of try
catch (Exception e) { out.println("Exception:"+e.getMessage()); }
 
%>


<font color='#000099' size='4'><strong>單號 : </strong></font><font color='#FF0000' size='4'><strong><%=ISSCREATENO%></strong></font> 


<table width="96%" border="1">
	<tr> 
		<td colspan="1">申請日期:<%=ISSCREATEDATE.substring(0,4)%>/<%=ISSCREATEDATE.substring(4,6)%>/<%=ISSCREATEDATE.substring(6,8)%>  </td>
		<td colspan="1"> 申請人:<%=ISSCREATEUSER+"("+UserName+")" //修正SPAN 誤用 userName 之問題點 2004/05/24 // %><!--%=RECCREATEUSER+"("+USERNAME+")"%--></td>
	</tr>
	<tr> 
		<td colspan="2" >申請料件</td>
	</tr>
</table>

<table width='100%' border='0' cellspacing='1' cellpadding='1'>
	<tr bgcolor='#000099'>
		<td><font size="2" color="#FFFFFF">項次</font></td>
		<td><font size="2" color="#FFFFFF">料號</font></td>
		<td><font size="2" color="#FFFFFF">料號說明</font></td>
		<td><font size="2" color="#FFFFFF">數量</font></td>
		<td><font size="2" color="#FFFFFF">廠商</font></td>
	</tr>
	  
<%
try {       
	int j=0;
	String jamString="";
	String qty="";
	
	Statement statement1=con.createStatement();
	
	ResultSet rsy=statement1.executeQuery("select count (*) from INV_M_IDTL where ISSCREATENO='"+ISSCREATENO+"'");			 			 			                         	  
	rsy.next();
	int featureCount= rsy.getInt(1);
	rsy.close();
	
	String t[][]=new String[featureCount][4];
	
	ResultSet rs1=statement1.executeQuery("select * from INV_M_IDTL where ISSCREATENO='"+ISSCREATENO+"' order by ISSITEMNO");	   
	while (rs1.next() && j<featureCount) {
	
		t[j][0]=rs1.getString("ISSITEMNO");
		t[j][1]=rs1.getString("ISSQTY");
		t[j][2]=rs1.getString("ISSWHS");
		t[j][3]=rs1.getString("ISSLOC");				  
		
		jamString=rs1.getString("ISSITEMNO");
        String itemDesc = "";  
        Statement stateID=con.createStatement();
        ResultSet rsID=stateID.executeQuery("select ITEMDESC from INV_ITEM where trim(ITEMNO)='"+jamString+"' ");	 
        if (rsID.next()) { itemDesc = rsID.getString("ITEMDESC");  }  
        rsID.close();     
        stateID.close();
		   
		out.print("<tr bgcolor='#FFFFCC'>");
		out.print("<td><font size='2'>"); out.println(j+1); out.println("</font></td>");
		out.print("<td><font size='2'>"+jamString+"</font>");
        out.println("<input type='hidden' name='ITEM"+j+"' value='"+jamString+"'></td>");
		out.print("<td><font size='2'>"+itemDesc+"</font></td>");  
		qty=rs1.getString("ISSQTY");
		out.print("<td><font size='2'>"+qty+"</font></td>");
		String whs=rs1.getString("ISSWHS");
		String loc=rs1.getString("ISSLOC");
		loc = whs+"-"+loc;

        //if (loc==null || loc.equals("")) 
		//{  
			//取得倉庫中庫存大於需求的廠商名稱
			Statement stateM=con.createStatement();
			String sqlM = "select x1.REMWHS||'-'||x1.REMLOC,x1.REMWHS||'-'||x2.VNDDESC from INV_M_REM x1, INV_VND x2  "+
						  "where REMITEMNO='"+jamString+"' and substr(x1.REMLOC,4,3)=x2.VNDNO and x1.REMQTY>='"+qty+"' ";  
			ResultSet rsM=stateM.executeQuery(sqlM); 

			comboBoxBean.setRs(rsM);
			comboBoxBean.setSelection(loc);
			comboBoxBean.setFieldName("REMLOC"+j);	   
			out.println("<td><font size='2'>"+comboBoxBean.getRsString()+"</font></td></tr>");
			rsM.close(); 	
			stateM.close();	
			j=j+1;		
		//}   
		/*
		else
		{
		    Statement stateL=con.createStatement();
			String sqlL = "select a.VNDDESC from INV_VND a,INV_M_IDTL b where a.VNDNO=substr(b.ISSLOC,4,3) and b.ISSITEMNO ='"+jamString+"' and b.ISSCREATENO='"+ISSCREATENO+"' ";

        	ResultSet rsL=stateL.executeQuery(sqlL);			
			if (rsL.next()==false)
			{}
			else
			{
			  out.print("<td><font size='2'>"+rsL.getString("VNDDESC")+"</font></td>");
			}
			rsL.close();
			stateL.close();
			j=j+1;
		}	
		*/
	   }    	   	   	          
	   arrayCheckInputBoxBean.setArray2DString(t);
	   statement1.close();
       rs1.close();  
%>
  </table>
	   <input type="hidden" name="RECCNT" value="<%=j%>">
<%      
	   
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
%> 


<%
		  //this field means to get the all features to arrayCheckInputBoxBean  		     
		  /*
		  try
		  {
			 Statement statementy=con.createStatement();
             ResultSet rsy=statementy.executeQuery("select count (*) from INV_M_IDTL where ISSCREATENO='"+ISSCREATENO+"'");			 			 			                         	  
			 rsy.next();
			 int featureCount= rsy.getInt(1);
			 rsy.close();
			 if (featureCount>0) //if there are some features exists
			 {
			 String t[][]=new String[featureCount][4];
		     Statement statementp=con.createStatement();
             ResultSet rsp=statementp.executeQuery("select ISSITEMNO,ISSQTY,ISSWHS,ISSLOC from INV_M_IDTL where ISSCREATENO='"+ISSCREATENO+"'");			 			 			                         	  			 
			 
			  int k=0;
			 
			     while (rsp.next())
			     {
			      t[k][0]=rsp.getString("ISSITEMNO");
			      t[k][1]=rsp.getString("ISSQTY");
			      t[k][2]=rsp.getString("ISSWHS");
			      t[k][3]=rsp.getString("ISSLOC");				  
			      k++;
			     }    		
    		     arrayCheckInputBoxBean.setArray2DString(t);				 
			     statementp.close();
			     rsp.close();
				 } else {
			     arrayCheckInputBoxBean.setArray2DString(null);
			  }	
	 
		  } //end of try
		  catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }	  
		 */
%>
</table>  

  <BR>
    <strong><font color="#FF0000">可執行動作-&gt;</font></strong> 
    <%
	  try
      {       
       Statement statement=con.createStatement();
       String sql = "select x1.ACTIONID,x2.ACTIONNAME from WSWORKFLOW x1, WSWFACTION x2, INV_M_ISS x3  "+
                    "WHERE FORMID='RD' AND FROMSTATUSID='011' AND x1.ACTIONID=x2.ACTIONID "+
                    "and x1.FROMSTATUSID=x3.ISSSTATID and x3.ISSCREATENO='"+ISSCREATENO+"' ";  
       ResultSet rs=statement.executeQuery(sql); 
       comboBoxBean.setRs(rs);
	   comboBoxBean.setFieldName("ACTIONID");	   
       out.println(comboBoxBean.getRsString());
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
  </div>
 <p>
   <INPUT TYPE="button" value='存檔' onClick='setSubmit("../jsp/INVBatchIssPage.jsp?SAVE=1")'>
   <input type="button" name="button"  onClick='submitCheck()' value='執行'>
</p>
  <p>
<!-- 表單參數 -->    
<input name="ISSCREATENO" type="HIDDEN" value="<%= ISSCREATENO %>">	
    <input name="ISSSTATID" type="HIDDEN" value="<%= ISSSTATID %>">	
    <input name="FROMSTATUSID" type="HIDDEN" value="011">
  </p>
</FORM>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->

