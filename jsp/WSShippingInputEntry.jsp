<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean" %>
<%@ page import="DateBean,ArrayListCheckBoxBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<%@ include file="/jsp/include/ConnMESPoolPage.jsp/"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function NeedConfirm()
{ 
 flag=confirm("是否確定刪除?"); 
 return flag;
}
function setSubmit(URL)
{
   //warray=new Array(document.MYFORM.IMEI.value,document.MYFORM.MCARTONNO.value,document.MYFORM.INSTATIONTIME.value);   
   warray=new Array(document.MYFORM.CARIMEI.value);  
   for (i=0;i<1;i++)
   {     
      if (warray[i]=="" || warray[i]==null)
     { 
      alert("Before you want to add , please do not let the data be Null !!");   
      return(false);
      } 
   } //end of for  null check
/*   
   for (i=0;i<1;i++)
   {     
      txt=warray[i];
	  for (j=0;j<txt.length;j++)      
     { 
	  c=txt.charAt(j);
	    //if ("0123456789.".indexOf(c,0)<0 || c.match(/[^a-z|^A-Z]/g)) 
	    if ("0123456789.".indexOf(c,0)<0 && c.match(/[^a-z|^A-Z]/g)) 
	    { 
            alert("Weekly forecast data should be numerical or character !");   
            return(false);
		 }
      } 
   } //end of for  null check
*/
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setSubmit2(URL)
{  
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<%     
	 String [] addItems=request.getParameterValues("ADDITEMS");
	 String wareHouse = request.getParameter("WAREHOUSE");
     String custOrder = request.getParameter("CORDER");
     String model = request.getParameter("MODEL");
     String custNo = request.getParameter("CUSTNO"); 
     String custName = request.getParameter("CUSTNAME");
     String custAddress = request.getParameter("CUSTADDRESS");
     String ordQty = request.getParameter("ORDERQTY");
     String shipQty = request.getParameter("SHIPQTY");
	 String carIMEI = request.getParameter("CARIMEI");
	 //String UserID=request.getParameter("USERID");	 
	 String CenterNo=request.getParameter("CENTERNO");
	 String locale=request.getParameter("LOCALE");
	 String dupIMEI="";
	 String chkMODEL=request.getParameter("CHKMODEL");	 
	 String chkIMEI=request.getParameter("CHKIMEI");	 	 
	 
		int mCNoLength = 0; 
		int carIMEILength = 0; 	

        int COQty = 0; //記錄CO數
        int ShQty = 0; //記錄已出貨數
        int Qty = 0; //記錄目前出貨數
		
	 String chkQty="";//檢查出貨數是否大於可出貨數
	 String sQty = request.getParameter("QTY"); //記錄目前出貨數
	 String stable=""; //檢查R Table or H Table
	  
	 String imei = request.getParameter("IMEI");
	 String mCartonNo = request.getParameter("MCARTONNO");
	 String inStationTime = request.getParameter("INSTATIONTIME");
	 
	 if (ordQty==null){ordQty = "";}	 
	 if (shipQty==null){shipQty = "";}
     if (mCartonNo==null) { mCartonNo = "";}
     if (inStationTime==null) { inStationTime = "";}
	 if (sQty==null) {sQty = "0";}
	
%>	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Customer Activity IMEI Authorization Entry</title>
</head>
<body onLoad="this.document.MYFORM.CARIMEI.focus()">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> Shipping Input </strong></font>
<FORM ACTION="WSShippingInputEntry.jsp" METHOD="post" NAME="MYFORM">
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>
<% 
	try  {           
		if (addItems!=null) { //若有選取則表示要刪除
			String a[][]=arrayListCheckBoxBean.getArray2DContent();//重新取得陣列內容        
			if (a!=null && addItems.length>0) { 		 
				if (a.length>addItems.length) {			      	    
					String t[][]=new String[a.length-addItems.length][a[0].length];     
					int cc=0;
					for (int m=0;m<a.length;m++) {
						String inArray="N";		
						for (int n=0;n<addItems.length;n++)   {
							if (addItems[n].equals(a[m][0])) inArray="Y";
						} //end of for addItems.length  		 
						if (inArray.equals("N")) {
							for (int gg=0;gg<a[0].length;gg++) { //置入陣列中元素數
								t[cc][gg]=a[m][gg];
							}
							t[cc][4] = String.valueOf(cc+1);
							cc++;
						}  
					} //end of for a.length	   
					arrayListCheckBoxBean.setArray2DString(t);		 
				} else { 	   			 
					arrayListCheckBoxBean.setArray2DString(null); //將陣列內容清空
				}	     
			}//end of if a!=null	   
		} //end of addItem if
 
	} //end of try
     catch (Exception e)
    {
      out.println("Exception:"+e.getMessage());
    }  
 %>
<!--form method="post" action="../jsp/WSShippingInsert.jsp" -->
<table width="100%" border="0">
  <tr bgcolor="#D0FFFF">
      <td width="20%" bordercolor="#FFFFFF" colspan="1" nowrap><font color="#333399" font size="2" face="Arial Black"><strong>Warehouse :</strong></font> 
        <font color="#990066" font size="2" face="Arial Black">
		<input name="WAREHOUSE" type="hidden" value="<%=wareHouse%>">
		<% 
		 out.println(wareHouse);
        %> </font></td>
  <td colspan="1" width="18%"><font color="#333399" font size="2" face="Arial Black"><strong> CO :</strong></font> 
    <font color="#990066" font size="2" face="Arial Black">
	<input name="CORDER" type="hidden" value="<%=custOrder%>">
    <% 
		 out.println(custOrder); 
    %>  
	</font></td>
<td colspan="1" width="18%"><font color="#333399" font size="2" face="Arial Black"><strong> ITEM
      NO :</strong></font> 
  <font color="#990066" font size="2" face="Arial Black">
    <% 				 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  if (custOrder==null || custOrder.equals("--"))
		  { }
		  else
		  { 		  
		    //sSql = "select distinct trim(x.LPROD), trim(x.LPROD)||'('|| trim(IDESC)||trim(IDSCE)||')' as DESCRIPTION from ECL x, IIM y";			  
			sSql = "select distinct trim(x.LPROD) as MODEL, trim(x.LPROD)  from ECL x, IIM y";			  
		    sWhere = " where x.LORD IN("+custOrder+") and x.LPROD=y.IPROD and x.LPROD IS NOT NULL "+
		             " order by 1 ";		              
		    sSql = sSql+sWhere;
			
			Statement statement=bpcscon.createStatement();
            ResultSet rs=statement.executeQuery(sSql);

			
		    out.println("<select NAME='MODEL' onChange='setSubmit2("+'"'+"../jsp/WSShippingInputEntry.jsp"+'"'+")'>");
            out.println("<OPTION VALUE=-->--");     
            while (rs.next())
            {            
             String s1=(String)rs.getString(1); 
             String s2=(String)rs.getString(2); 
                        
            if (s1.equals(model)) 
             {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
             } 
			 else 
			 {
              out.println("<OPTION VALUE='"+s1+"'>"+s2);
             }        
            } //end of while
            out.println("</select>"); 	  		  		  
        
            rs.close();    
		    statement.close();  		 
		    }  // end of else 
           } //end of try		  
		  
/*		  
            comboBoxBean.setRs(rs);		  		 
		    if (model!=null) comboBoxBean.setSelection(model);
	        comboBoxBean.setFieldName("MODEL");	   
            out.println(comboBoxBean.getRsString());		

            rs.close();    
		    statement.close();  
	      }  // end of else 
         } //end of try
*/
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
		 
       %>
</font></td>		
	<tr bgcolor="#D0FFFF">
	  <td colspan="2"><font color="#333399" font size="2" face="Arial Black"><strong> Customer Name :</strong></font>		<font color="#990066" font size="2" face="Arial Black">
		 <input name="CUSTNAME" type="hidden" value="<%=custName%>">
		 <%out.println(custName);%>
		</font>
		<input name="CUSTNO" type="hidden" value="<%=custNo%>"></td>
    <td colspan="1"><font color="#333399" font size="2" face="Arial Black"><strong> CO Qty :</strong></font>	    <font color="#990066" font size="2" face="Arial Black"> 
		 <input name="ORDERQTY" type="hidden" value="<%=ordQty%>">
         <%  
			if (model==null || model.equals(""))
			{}
			else
			{
			   try
			   {  
			     //String sql = "select sum(LQORD) LQORD from ECL where LID='CL' and LORD = '"+custOrder+"' ";
				 //String sWhere = "and LPROD = '" +model+ "' and (LQORD-LQSHP)>0";
			     String sql = "select sum(LQORD) LQORD from ECL where LORD = '"+custOrder+"' ";
				 String sWhere = "and LPROD = '" +model+ "' ";				 
				 sql = sql + sWhere;
				 Statement state=bpcscon.createStatement();
	             ResultSet rs=state.executeQuery(sql);
	             if (rs.next())
				 {
				   ordQty =  rs.getString("LQORD");
				   out.println(rs.getString("LQORD"));
				   if (ordQty != null || ordQty != "")
				   {
					COQty = rs.getInt("LQORD");
				   }
				 }
				 else
				 { out.println(""); }		
				 rs.close();		
				 state.close();  
			 } //end of try
             catch (Exception e)
             {
              out.println("Exception:"+e.getMessage());		  
             }
		   }//end of else  
	    %>
</font></td>
	<tr bgcolor="#D0FFFF">
		<td colspan="2"><font color="#333399" font size="2" face="Arial Black"><strong> Customer Address :</strong></font> 
		 <font color="#990066" font size="2" face="Arial Black">
		 <input name="CUSTADDRESS" type="hidden" value="<%=custAddress%>">	
		  <%out.println(custAddress);%> 
		 </font></td>	
		<td colspan="1"><font color="#333399" font size="2" face="Arial Black"><strong> BPCS Ship :</strong></font> 
		 <font color="#990066" font size="2" face="Arial Black">
		 <input name="SHIPQTY" type="hidden" value="<%=shipQty%>">
		  <%
		  	if (model==null || model.equals(""))
			{}
			else
			{
		      try
			  {  
		         //String sql = "select sum(LQSHP) LQSHP from ECL where LID='CL' and LORD = '"+custOrder+"' ";
				 //String sWhere = "and LPROD = '" +model+ "' and (LQORD-LQSHP)>0";
		         String sql = "select sum(LQSHP) LQSHP from ECL where LORD = '"+custOrder+"' ";
				 String sWhere = "and LPROD = '" +model+ "' ";				 
				 sql = sql + sWhere;
				 Statement state=bpcscon.createStatement();
	             ResultSet rs=state.executeQuery(sql);
	             if (rs.next())
				 {
				  shipQty =  rs.getString("LQSHP");
				  out.println(rs.getString("LQSHP"));
				  if (shipQty != null || ordQty != "")
				   {
					ShQty = rs.getInt("LQSHP");
				   }
				 }
				 else
				 { out.println(""); }			
				 rs.close();
				 state.close();
		     } //end of try
             catch (Exception e)
             {
              out.println("Exception:"+e.getMessage());		  
             }
		   }//end of else
	    %>
		  </font></td>		
	</tr>
		<tr>
		  <td colspan="3">	        <div align="center"><font color='#FF0000'><strong>	
<%
    try 
    {  
	  if (model==null || model.equals("--"))
	  {out.println("請先選擇Item No!!!");
	   dupIMEI="N";
	  }
	  else	    
	  {
	    if (carIMEI==null || carIMEI.equals(""))
	    {}
	    else //else1
	    {
	     
         // Check IMEI or Carton No 是否存在SFISM4.R_WIP_TRACKING_T   
		 carIMEI=carIMEI.toUpperCase(); //小寫轉大寫
         Statement stateM=conMES.createStatement();
         ResultSet rs1=stateM.executeQuery("select distinct IMEI from SFISM4.R_WIP_TRACKING_T "
		 +" where (IMEI = '"+carIMEI+"' or MCARTON_NO='"+carIMEI+"') ");
		 //+" and GROUP_NAME='AC_PACKING' and PALLET_FULL_FLAG='Y'");
         //若不存在R Table
         if (rs1.next()==false)
           {  
 		     stateM.close();
             rs1.close(); 
		     Statement stateM2=conMES.createStatement();
             ResultSet rs2=stateM2.executeQuery("select distinct IMEI from SFISM4.H_WIP_TRACKING_T "
			 +" where (IMEI = '"+carIMEI+"' or MCARTON_NO='"+carIMEI+"') ");
			 //+" and GROUP_NAME='AC_PACKING' and PALLET_FULL_FLAG='Y'");
			 //若不存在H Table
			 if (rs2.next()==false)
			 {
               out.println("查無此IMEI號碼或CARTON NO，請重新確認!!!");
			   dupIMEI="N";
			 }
			 stateM2.close();
             rs2.close(); 
           }
		 //若存在
	     else //else2
           {  
	         stateM.close();
             rs1.close(); 
	    
		     // Check Model是否正確
             Statement state1=conMES.createStatement();
             ResultSet rs3=state1.executeQuery("select distinct MODEL_NAME from SFISM4.R_WIP_TRACKING_T "
			 +" where (IMEI = '"+carIMEI+"' or MCARTON_NO='"+carIMEI+"') and MODEL_NAME ='"+model+"'");
			 //+" and GROUP_NAME='AC_PACKING' and PALLET_FULL_FLAG='Y'");
             //若不存在R Table
             if (rs3.next()==false)
               {  
			     state1.close();
                 rs3.close(); 
                 Statement state2=conMES.createStatement();
                 ResultSet rs5=state2.executeQuery("select distinct MODEL_NAME from SFISM4.H_WIP_TRACKING_T "
				 +" where (IMEI = '"+carIMEI+"' or MCARTON_NO='"+carIMEI+"') and MODEL_NAME ='"+model+"'");
				 //+" and GROUP_NAME='AC_PACKING' and PALLET_FULL_FLAG='Y'");            			   
         	     //若不存在H Table
				 if (rs5.next()==false)
				 {
				   out.println("輸入的CARTON NO 或IMEI號碼不屬於此MODEL，請重新確認!!!");
				   dupIMEI="N";
				 }
				 state2.close();
                 rs5.close(); 
               }   
    		 //若存在
	         else //else3
               {
			     state1.close();
                 rs3.close(); 
				 
                 // Check Duplication
       			 Statement statement=con.createStatement();
      			 ResultSet rs4=statement.executeQuery("select * from WSSHIP_IMEI_T where (IMEI = '"+carIMEI+"' or MES_CARTON_NO='"+carIMEI+"') AND (SHP_NOTES IS NULL OR SHP_NOTES = 'X')");
     			 //若不存在,則新增
      			 if (rs4.next()==false)
      			   {}
		 	     else //else4
			       {
	  				 if (carIMEI.length()==15)
					   {out.println("輸入的IMEI號碼已存在系統中,請重新確認!!!");}
					 else if (carIMEI.length()==21)
   					   {out.println("輸入的CARTON NO 已有部分IMEI號碼存在系統中,請重新確認!!!");}
					 dupIMEI="N";
 			       }//end of else4	 
			     statement.close();
			     rs4.close();
			  } //end of else3
			} //end of else2			  
        }//end of if  carIMEI
	  }//end of model	         
	}//end of try
   catch (Exception e)
   {
    out.println("Exception:"+e.getMessage());		  
   }				 
%>
<%
  if (dupIMEI=="N")
  {}
  else
  {
	   if (carIMEI==null || carIMEI.equals(""))
	   { carIMEI = ""; }
	   else
	   {
	   
		 String sql = "select IMEI,MCARTON_NO,TO_CHAR(IN_STATION_TIME,'YYYY-MM-DD HH24-MI-SS') IN_STATION_TIME from SFISM4.R_WIP_TRACKING_T ";
		 String sWhere = "where (IMEI = '"+carIMEI+"' or MCARTON_NO='"+carIMEI+"') and MODEL_NAME ='"+model+"' "; //" and GROUP_NAME='AC_PACKING' and PALLET_FULL_FLAG='Y' ";
		 sql = sql + sWhere;
		 Statement state=conMES.createStatement();
		 ResultSet rs=state.executeQuery(sql);
		 if (rs.next())
		 { 
		   imei = rs.getString("IMEI");
		   mCartonNo = rs.getString("MCARTON_NO");
		   //mCNoLength = mCartonNo.length();
		   carIMEILength = carIMEI.length();
		   inStationTime = rs.getString("IN_STATION_TIME");
		   stable="R";				 
		   rs.close();
		   state.close();	
		 }
		 //若不存在R Table
		 else
		 {	 
		   String sqlH = "select IMEI,MCARTON_NO,TO_CHAR(IN_STATION_TIME,'YYYY-MM-DD HH24-MI-SS') IN_STATION_TIME from SFISM4.H_WIP_TRACKING_T ";
		   String sWhereH = "where (IMEI = '"+carIMEI+"' or MCARTON_NO='"+carIMEI+"') and MODEL_NAME ='"+model+"'";// and GROUP_NAME='AC_PACKING' and PALLET_FULL_FLAG='Y' ";
		   sqlH = sqlH + sWhereH;
		   Statement stateH=conMES.createStatement();
		   ResultSet rsH=stateH.executeQuery(sqlH);
		   if (rsH.next())
		   { 
			 imei = rsH.getString("IMEI");
			 mCartonNo = rsH.getString("MCARTON_NO");
			 mCNoLength = mCartonNo.length();
			 carIMEILength = carIMEI.length();
			 inStationTime = rsH.getString("IN_STATION_TIME");	
			 stable="H";					 
		   }		
		   rsH.close();
		   stateH.close();				   				 
		  }		
	}  // end of else
  }	
%>			 				  
	    </strong></font></div></td>
		</tr>
  <tr valign="baseline">             
      <td width="20%" height="20" colspan="1" align="center" nowrap><strong><font size="2">          
          Carton No./IMEI No.</font></strong></td>            
      <td colspan="1"><input type="text" name="CARIMEI"  size="30" maxlength="21"></td>
      <td><input name="button3"  type="button" onClick='setSubmit("../jsp/WSShippingInputEntry.jsp")' value="Add"></td>
  </tr>  
  </table>
  <table width="100%" border="1" cellpadding="0" cellspacing="0">  
  <tr>      
      <td width="20%" bgcolor="#FF6666"><div align="center"><font size="2">	   
	   COUNT	 
	  </font></div></td>
	  <td width="26%" colspan="1" bgcolor="#FF6666"><div align="center"><font size="2">
	  IMEI	
      </font></div>	  </td> 
	  <td width="28%" colspan="1" bgcolor="#FF6666"><div align="center"><font size="2">
	  CARTON NO.
	  </font></div></td> 
	  <td width="26%" colspan="1" bgcolor="#FF6666"><div align="center"><font size="2">
	   MES PACKING TIME
	  </font></div></td>	  
  </tr>
  <tr>
    <td><div align="center"> <font size="2">
    <%
            if (carIMEILength==15)
	        { out.println("Count IMEI : 1"); }
	        else if (carIMEILength==21)
	        { out.println("Count IMEI : 10"); }		
      %>
</font></div></td>
    <td>
	   <input type="hidden" name="IMEI"  size="15" value="<%=imei%>" maxlength="15">	
	   <table>	      
	   <%	
	     if (dupIMEI=="N")
         {}
         else
         {   
	      try
		  {
		    if ( carIMEI == null ||  carIMEI.equals("") )
			{}
			else
			{			
			  if (sQty == null || sQty.equals("0"))
       		  {Qty=0;}
			  else
			  {Qty = Integer.parseInt(sQty);}//記錄目前出貨數
			  
			 String sqlIMEI="";
			 String sWhereIMEI="";
			 if (stable=="R")
			 {
	           sqlIMEI = "select IMEI from SFISM4.R_WIP_TRACKING_T ";
			 }
			 else
			 {
			   sqlIMEI = "select IMEI from SFISM4.H_WIP_TRACKING_T ";
			 }
		       sWhereIMEI= "where MODEL_NAME ='"+model+"' "; //and GROUP_NAME='AC_PACKING' and PALLET_FULL_FLAG='Y' ";
			   if (carIMEILength==15)
		       {  sWhereIMEI = sWhereIMEI + "and IMEI='"+imei+"' "; }
		       else if (carIMEILength==21)
		       {  sWhereIMEI = sWhereIMEI + "and MCARTON_NO='"+mCartonNo+"' "; }
		       sqlIMEI = sqlIMEI + sWhereIMEI;
		       Statement stateIMEI=conMES.createStatement();
	           ResultSet rsIMEI=stateIMEI.executeQuery(sqlIMEI);
	           while (rsIMEI.next())
		       {
			   /*
				Qty = Qty + 1;
				if (Qty > (COQty - ShQty))
	  		    {  				  
				  out.println("出貨數已超出可出貨數量!!");
				  Qty = Integer.parseInt(sQty);//記錄目前出貨數
				  chkQty = "N";//出貨數已超出可出貨數量
				  mCartonNo = "";
				  inStationTime = "";
				  break;
				
			    }
	   	        */
	   %>
					<tr bgcolor="#CCFFCC">		   
						<td><div align="center"><font size="2"><%=rsIMEI.getString("IMEI")%></font></div></td> 
					</tr>
			   <%                
                   //rs_hasData = rs.next();	   
                  }	    // End of While loop   
	              rsIMEI.close();
	              stateIMEI.close();
				  } // end carIMEI
                 } //end of try
                 catch (Exception e)
                {
                  out.println("Exception:"+e.getMessage());
                }   
			   }  //end of dupIMEI
              %>  
	   </table>      
    </td>
      <td><font size="2">
<%
if (chkQty=="N") {
} else {
	if (dupIMEI=="N") {
	} else {
	try {
		//String oneDArray[]= {"","MODEL",ymh1,ymh2,ymh3,ymh4,ymh5,ymh6}; 	 
		String oneDArray[]= {"","Carton No./IMEI No.","IMEI","Carton No.","MES PACKING TIME","COUNT"}; 	 	     			  
		arrayListCheckBoxBean.setArrayString(oneDArray);
		String a[][]=arrayListCheckBoxBean.getArray2DContent();//取得目前陣列內容  	   			    
		int i=0,j=0,k=0;		  
		
		if (carIMEI!=null && carIMEI!= "") {               		   
			if (a!=null ) {
				String b[][]=new String[a.length+1][a[i].length];		    			 
				for (i=0;i<a.length;i++) {
					for (j=0;j<a[i].length;j++) {
						b[i][j]=a[i][j];
					}
					b[i][4]=String.valueOf(k+1);
					k++;
				}
				//b[k][0]=chooseItem;			 
				b[k][0]=carIMEI;b[k][1]=imei;b[k][2]=mCartonNo;b[k][3]=inStationTime;b[k][4]=String.valueOf(k+1); 
				arrayListCheckBoxBean.setArray2DString(b); 	 								 	   			              				
			} else {     			  
				String c[][]={{carIMEI,imei,mCartonNo,inStationTime,"1"}};        			 
				arrayListCheckBoxBean.setArray2DString(c); 						 	                
			}  // end if                	                       		        		  
		} else {
			if (a!=null) {
				arrayListCheckBoxBean.setArray2DString(a);     			       	                
			} 
		} // end if

	} //end of try
	catch (Exception e) {
		out.println("Exception:"+e.getMessage());
	}
	}//end of dupIMEI 
}//end of if chkQty
%>
        </font>
        <input type="hidden" name="MCARTONNO" size="21" value="<%=mCartonNo%>" maxlength="21"> 
          <% if (mCartonNo==null) { } else {out.println(mCartonNo);} %>
	  </td><td><input type="hidden" name="INSTATIONTIME" size="20" value="<%=inStationTime%>">
        <%out.println(inStationTime);%>	</td>    
  </tr> 
  </table>        
  <input name="button" type="button" onClick="this.value=check(this.form.ITEMS)" value="Select All"> 
  <BR>		        
  <% 
		 //if (dupIMEI=="N")
         //{ }
         //else
         //{  
			  int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
	             try
                {	
			       String a[][]=arrayListCheckBoxBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
                   if (a!=null) 
		          {
		            div1=a.length;
				    div2=a[0].length;
	            	arrayListCheckBoxBean.setFieldName("ADDITEMS");		 	   			 
                    out.println(arrayListCheckBoxBean.getArray2DString());  	 				
		          }	//enf of a!=null if
				  else
				  {}
                } //end of try
                catch (Exception e)
              {
                out.println("Exception:"+e.getMessage());
              }
		//} //end of dupIMEI
 %>  
  <BR>
  <input name="button2" type="button" onClick='setSubmit2("../jsp/WSShippingInputEntry.jsp")'  value="DELETE" >		   
  <div align="center">
		     <input name="button4" type="button" onClick='setSubmit2("../jsp/WSShippingInsert.jsp")'  value="確認送出" >
  </div>
		   <!-- 表單參數 -->                   

	   <input type="hidden" name="CENTERNO" value=<%=CenterNo%> size="3" maxlength="3" >
	   <input type="hidden" name="LOCALE" value=<%=locale%> size="3" maxlength="3" >	
	   <input type="hidden" name="QTY" value=<%=Qty%> size="3" maxlength="3" >   
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnMESPage.jsp"%>
<!--=================================-->
</html>