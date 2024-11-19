<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>Sales Hierarchy Setting Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbtelPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function btnCustomerInfo()
{ 
  subWin=window.open("subwindow/CustomerInfoSubWindow.jsp","subwin","width=480,height=400,scrollbars=yes,menubar=no");  
}
function btnItemInfo()
{ 
  subWin=window.open("subwindow/ChooseMaterialSubWindow.jsp","subwin","width=600,height=400,scrollbars=yes,menubar=no");  
}
function btnAddRegion()
{ 
  subWin=window.open("subwindow/AddRegionSubWindow.jsp","subwin","width=480,height=400,scrollbars=yes,menubar=no");  
}
function btnAddCountry()
{ 
  subWin=window.open("subwindow/AddCountrySubWindow.jsp","subwin","width=480,height=400,scrollbars=yes,menubar=no");  
}
 function submitCheck(ms1,ms2,ms3,ms4,ms5,ms6,ms7,ms8,ms9,ms10,ms11,ms12) 
//function submitCheck(ms1,ms2,ms3,ms4,ms5,ms6,ms7,ms8,ms9,ms10)
{ 
  if (document.MYFORM.ACTIONID.value=="--" || document.MYFORM.ACTIONID.value==null)
  { 
   alert(ms1);   
   return(false);
  } 
 
  if (document.MYFORM.MODEL.value=="" || document.MYFORM.MODEL.value==null)
  { 
   alert(ms2);   
   return(false);
  } 
 
  if ( document.MYFORM.SVRDOCNO.value=="" || document.MYFORM.SVRDOCNO.value==null)
  { 
   alert(ms3);   
   return(false);
  }  
  
  if ( document.MYFORM.CMRNAME.value=="" || document.MYFORM.CMRNAME.value==null)
  { 
   alert(ms4);   
   return(false);
  }  

  if ( document.MYFORM.TYPENO.value=="--" || document.MYFORM.TYPENO.value==null)
  { 
   alert(ms5);   
   return(false);
  }       
  
  if ( document.MYFORM.ISJAMSELECTED.value=="N" )
  { 
   alert(ms6);   
   return(false);
  }         
  
  for (i=0;i<document.MYFORM.RECITEMNO.length;i++)
  {
   //如果為收件項目為handset的話,則一定要輸入IMEI
   if (document.MYFORM.RECITEMNO[i].value=="001" && document.MYFORM.RECITEMNO[i].checked==true && (document.MYFORM.IMEI.value=="" || document.MYFORM.IMEI.value==null) ||
      document.MYFORM.RECITEMNO[i].value=="008" && document.MYFORM.RECITEMNO[i].checked==true && (document.MYFORM.IMEI.value=="" || document.MYFORM.IMEI.value==null))   
   {
    alert(ms7);   	     
    return(false);   
   }
// 2004-10-11 for 1 order 1 pcs on Handset or PCB
   if ((document.MYFORM.RECITEMNO[i].value=="001" && document.MYFORM.RECITEMNO[i].checked==true && document.MYFORM.QTY.value > 1) || 
       (document.MYFORM.RECITEMNO[i].value=="008" && document.MYFORM.RECITEMNO[i].checked==true && document.MYFORM.QTY.value > 1))   
  {
    alert(ms11);   	     
    return(false);   
  }
//   if (document.MYFORM.RECITEMNO[i].value=="008" && document.MYFORM.RECITEMNO[i].checked==true && (document.MYFORM.PCBITEMNO.value=="--" || document.MYFORM.PCBITEMNO.value =="" || document.MYFORM.PCBITEMNO.value==null )) 
   if (document.MYFORM.RECITEMNO[i].value=="008" && document.MYFORM.RECITEMNO[i].checked==true && (( document.MYFORM.PCBITEMNO.value=="--" || document.MYFORM.PCBITEMNO.value==null )&& (document.MYFORM.PCB2.value ==null || document.MYFORM.PCB2.value =="" ) )) 
  {
    alert(ms12);   	     
    return(false);   
  }

  }   // end of for         
  
  if (document.MYFORM.RECTYPE==null || document.MYFORM.RECTYPE.value=="--") //未選收件型態
  { 
   alert(ms8);   
   return(false);
  } 
  
  if (document.MYFORM.QTY==null || document.MYFORM.QTY.value=="") //未填數量
  { 
   alert(ms9);   
   return(false);
  } 

  if (document.MYFORM.IMEI.value=="$" && (document.MYFORM.ITEMNO ==null || document.MYFORM.ITEMNO.value=="") ) //後送LCM未填入料號  -->
  { 
   alert(ms10);   
   return(false);
  } 
  
 // 2004 /10/05 加入檢核 IMEI Java Script --> By Kerwin
 warray=new Array(document.MYFORM.IMEI.value);   
 for (i=0;i<document.MYFORM.RECITEMNO.length;i++) // 先抓收件項目是否為 HandSet
 { 
  if (document.MYFORM.RECITEMNO[i].value=="001" && document.MYFORM.RECITEMNO[i].checked==true)   
  { 
   for (i=0;i<1;i++)
   {     
     txt=warray[i];
	 for (j=0;j<txt.length;j++)      
     { 
	  c=txt.charAt(j);
	     if ("0123456789".indexOf(c,0)<0) 
         //  if ("0123456789.".indexOf(c,0)<0 && c.match(/[^a-z|^A-Z]/g)) 
	     {
            //alert("IMEI data should be numerical !!"); 
            flag=confirm("IMEI should be numerical, Re-typing ? ");  
            if (flag) 
            {   
                return(false);
                //document.MYFORM.submit(); 
            } else {        
                     break;
                    }    
		 } 
      
      } 

       if (txt.length<=14)
       {
            flag=confirm("IMEI should be include 15 digit, Still Saving ?");  
            if (flag) 
            {   
                break;
                //document.MYFORM.submit(); 
            } else {        
                     return(false);
                    }    
       }        
    } //end of for  null check
  } // End of if 收件項目 = "001" 
 } // End of for 
  // 2004 /10/05 加入檢核 IMEI Java Script --> By Kerwin

  document.MYFORM.submit();   
}

function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
col = new Array("red","orange","yellow","green","blue","gray","purple","white");
num = 0;
function flashLink()
{
    myLINK.style.color = col[num++];
	num %= col.length;
}
</script>
<%@ page import="CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,ArrayComboBoxBean,DateBean,ArrayCheckBoxBean"%>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> <!--此bean作用在存入故障描述-->
<%
//  String jamCode[][]=arrayCheckBoxBean.getArray2DContent();//取得JamCode目前陣列內容
//  if (jamCode==null) { arrayCheckBoxBean.setArray2DString(null); }
  arrayCheckBoxBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%
   String dsn="";
   String model="";
   String itemno=request.getParameter("ITEMNO");
   String idesc="";
   String color="";
   String imei=request.getParameter("IMEI");
   String center=request.getParameter("REPCENTERNO");
   String docno=request.getParameter("SVRDOCNO");
   String agent=request.getParameter("AGENTNO");
   String rectype=request.getParameter("RECTYPE");
   String cname=request.getParameter("RECCENTERNAME");
   String cmname=request.getParameter("CMRNAME");
   String cmtel=request.getParameter("CMRTEL");
   String cmcell=request.getParameter("CMRCELL");
   String cmaddr=request.getParameter("CMRADDR");
   String zip=request.getParameter("ZIP");
   String jdesc=request.getParameter("OTHERJAMDESC");
   String jreq=request.getParameter("JAMFREQ");
   String warrno=request.getParameter("WARRNO");
   String remark=request.getParameter("REMARK");
   String buyplace=request.getParameter("BUYPLACE");
   String buyyear=request.getParameter("BUYYEAR");
   String buymonth=request.getParameter("BUYMONTH");
   String buydate=request.getParameter("BUYDATE");
   String typeno=request.getParameter("TYPENO");
//2004-10-08
   String [] ritem=request.getParameterValues("RECITEMNO");
   String pcbitemNo=request.getParameter("PCBITEMNO");
   String pcb2=request.getParameter("PCB2");
   String ritemS="";
   
   if (ritem!=null)
     {
      for (int i=0;i<ritem.length;i++)
       {      
        if (ritemS=="") 
          {  ritemS=ritem[i]; }
	    else 
	      {  ritemS=ritemS+","+ritem[i]; }
       } //end of for
     } //end of ritem	if
//   out.println("IMEI : "+imei);
  String preSeqNo=request.getParameter("PREREPNO");
  String preIMEI=request.getParameter("PREIMEI");
  String repTimes=request.getParameter("REPTIMES");
  //out.println("preSeqNo="+preSeqNo);
  String repeatInput=request.getParameter("REPEATINPUT");
  
  String ssal=request.getParameter("SSAL");
  String sName = "";
  String sAd1 = "",sAd2 = "",sAd3 = "";
  String smFaxN = "",smDatN = "";
 
%>
<FORM ACTION="/repair/jsp/RepairMInsert.jsp" METHOD="post" NAME="MYFORM" onSubmit='return submitCheck()'>
<A HREF="/repair/RepairMainMenu.jsp">回首頁</A> &nbsp;&nbsp;<A HREF="../jsp/SASalesHierarchySetup.jsp">業務員組織查詢</A> 
<BR><font color="#0080FF" size="5"><strong>業務員組織設定</strong></font>
  <table width="96%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFEEFF" bgcolor="#FFFFEE">
    <tr> 
      <td width="34%"><font size=2 color="#FF0000"><strong>業務員編號:<font  size="2" color="#000099">
    <%      
	  try
      {    	  	  
         out.println(ssal);   
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %></font></strong></font>  
      </td>
      <td width="32%">
	  <font size="2">業務員姓名: </font><font size=2 color="#000099">
	  <%      
	  try
      {    
	        String sqlSales = ""; 	  
            Statement stateSales;
            ResultSet rsSales;
           // 取得 序號 by IMEI
     	    sqlSales = "select SSAL,SNAME,SAD1,SAD2,SAD3,SMFAXN,SMDATN from SSM where SSAL= '"+ssal+"' ";
            stateSales=ifxDbtelcon.createStatement();
            rsSales=stateSales.executeQuery(sqlSales);
			if (rsSales.next())
			{
			   sName = rsSales.getString("SNAME");
			   sAd1 = rsSales.getString("SAD1");sAd2 = rsSales.getString("SAD2");sAd3 = rsSales.getString("SAD3");
			   smFaxN = rsSales.getString("SMFAXN");
			   smDatN = rsSales.getString("SMDATN");			
			   out.println(sName);  
			}
			rsSales.close();
			stateSales.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
	  </font></td>
      <td width="34%"><font size=2>員工工號:</font><font size="2" color="#000099">
     <%      
	  try
      {    	  	  
          out.println(smFaxN);  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>        
      </font></td>
    </tr> 
    <tr> 
      <td><font size=2>連絡地址1: 
        <% out.println(sAd1); %></font></td>
      <td nowrap><font size=2> 
        連絡地址2:
        </font> <font size=2> 
        <% out.println(sAd2); %>
        </font></td>
      <td><font size=2>連絡地址3 
        <% out.println(sAd3); %> </font> </td>
    </tr>
    <tr> 
      <td colspan="1"><font color="#FF0000">*</font><input name="button2" type=button onClick="btnAddRegion()" value='地區別選擇'> 
        &nbsp;
      <td colspan="2"><font size=2 color="#FF0000">
        *<input name="button2" type=button onClick="btnAddCountry()" value='國別選擇'>
         </font></td>
	</tr>
    <tr> 
		<td colspan="3"><font size=2>人員電子郵件: 
        <% out.println(smDatN); %>
        </font>    
	</tr>    
    <tr> 
      <td colspan="3"><font size=2>備註:
        <INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%if (remark==null || remark.equals("")) {out.println(""); } else {out.println(remark);}%>"></font></td>      
    </tr>
  </table>
  <p>    
	<INPUT TYPE="button" value='存檔' onClick='submitCheck("方式警訊","機種","服務單號","客戶","服務類型","地區別","國別","收件項目","數量","料項目","故障數","PCBA")' >  
  </p>
  <p>
  <!-- 表單參數 -->  
    <input name="FORMID" type="HIDDEN" value="RP">	
    <input name="FROMSTATUSID" type="HIDDEN" value="001">
	<input name="ISREGIONED" type="HIDDEN" value="N" size=2>  <!--做為判斷是否已選取故障描述-->
	<input name="ISCOUNTRYED" type="HIDDEN" value="N" size=2>  
	<input name="FROMPAGE" type="HIDDEN" value="RepairInputPage.jsp">  	
  </p>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbtelPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
</body>
</html>
