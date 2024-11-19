<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="array2DDrawInputBean" scope="session" class="Array2DimensionInputBean"/>
<title>IQC Drawing Examine data Input Entry</title>
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
</STYLE>
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
 flag=confirm("是否確認刪除?"); 
 return flag;
}
function setSubmit(URL)
{
   warray=new Array(document.MYFORM.PARTCODE.value,document.MYFORM.NO1.value,document.MYFORM.NO2.value,document.MYFORM.NO3.value,document.MYFORM.NO4.value,document.MYFORM.NO5.value,document.MYFORM.NO6.value,document.MYFORM.NO7.value,document.MYFORM.NO8.value,document.MYFORM.NO9.value,document.MYFORM.NO10.value,
                    document.MYFORM.NO21.value,document.MYFORM.NO22.value,document.MYFORM.NO23.value,document.MYFORM.NO24.value,document.MYFORM.NO25.value,document.MYFORM.NO26.value,document.MYFORM.NO27.value,document.MYFORM.NO28.value,document.MYFORM.NO29.value,document.MYFORM.NO30.value,
					document.MYFORM.NO31.value,document.MYFORM.NO32.value,document.MYFORM.NO33.value,document.MYFORM.NO34.value,document.MYFORM.NO35.value,document.MYFORM.NO36.value,document.MYFORM.NO37.value,document.MYFORM.NO38.value,document.MYFORM.NO39.value,document.MYFORM.NO40.value,
					document.MYFORM.NO41.value,document.MYFORM.NO42.value,document.MYFORM.NO43.value,document.MYFORM.NO44.value,document.MYFORM.NO45.value,document.MYFORM.NO46.value,document.MYFORM.NO47.value,document.MYFORM.NO48.value,document.MYFORM.NO49.value,document.MYFORM.NO50.value);   
   for (i=0;i<26;i++) // 至少輸入25個檢測值
   {     
      if (warray[i]=="" || warray[i]==null)
      { 
      alert("Before you want to add , please do not let the any field of data be Null !!");   
      return(false);
      } 
	  
	  if (warray[0]=="--" || warray[0]==null)
      { 
      alert("請選擇規格圖面位置 !!"); 
	  document.MYFORM.PARTCODE.focus(); 
      return(false);
      } 
   } //end of for  null check
 
   for (i=1;i<26;i++) // 25個檢測值需為數字
   {     
      txt=warray[i];
	  for (j=1;j<txt.length;j++)      
     { 
	  c=txt.charAt(j);
      
	     if ("0123456789.".indexOf(c,0)<0) 
	     {
            alert("Code data should be numerical!!");   
            return(false);
		 }     
      } 
   } //end of for  null check
 
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setSubmit2(URL,dim1,dim2)
{    
   if (dim1<1)  //-Y!LS|3¢Do|o!MeRA?h?¢G!Aa|sAE
   {
       alert("No Need to Save because there is no any data being Added!!");   
       return(false);
   }

   for (i=0;i<dim1;i++)
   {     
      for (j=1;j<dim2;j++)
	  {
	     if (document.MYFORM.elements["MONTH"+i+"-"+j].value=="" || document.MYFORM.elements["MONTH"+i+"-"+j].value==null)
		 { 
           alert("Before you want to save , please do not let the Remark field be Null !!");   
           return(false);
		 }  
	  } //enf for of jj             
   } //end of for null check
   
    for (i=0;i<dim1;i++)
   {     
      for (k=1;k<dim2;k++)
	  {
         txt=document.MYFORM.elements["MONTH"+i+"-"+k].value;
	     for (j=0;j<txt.length;j++)      
         { 
	       c=txt.charAt(j);
          /*
	        if ("0123456789.".indexOf(c,0)<0) 
	       {
             alert("Monthly Cost of forecast detail should be numerical!!");   
             return(false);
		    }
         */
         }
	   } //enf for of k
   } //end of for  null check

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<style type="text/css">
<!--
.style1 {
	color: #CC0000;
	font-weight: bold;
}
.style2 {
	font-family: Arial;
	font-weight: bold;
	color: #FFFFFF;
}
.style3 {
	color: #993333;
	font-size: large;
}
-->
</style>
<body>
<span class="style3">品管IQC檢驗批檢測資料明細</span>
<FORM ACTION="../jsp/TSIQCInspectLotDrawingInput.jsp" METHOD="post" NAME="MYFORM">
<A HREF="/oradds/OraddsMainMenu.jsp">回首頁</A> 
<%
  
  String classID=request.getParameter("CLASSID"); 
  String inspLotNo=request.getParameter("INSPLOTNO");
  String iMatCode=request.getParameter("IMATCODE");
 
  
  String materialType=request.getParameter("MATERIALTYPE"); 
  String inspClassName = request.getParameter("INSPCLASSNAME");   
  String insertPage=request.getParameter("INSERT");   
  //if (delAll=="TRUE" || delAll.equals("TRUE")) { array2DDrawInputBean.setArray2DString(null); }    
  
  if (insertPage==null) // 若輸入模式離開此頁面,則BeanArray內容清空
  {    
	array2DDrawInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
  } 
  
  int commitmentMonth=0;
  array2DDrawInputBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
  String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
  String isModelSelected=request.getParameter("ISMODELSELECTED"); 
  
  String [] addItems=request.getParameterValues("ADDITEMS");
  String chooseItem=request.getParameter("CHOOSEITEM");
  String iNo=request.getParameter("INO");
  String partCode=request.getParameter("PARTCODE"),no1=request.getParameter("NO1"),no2=request.getParameter("NO2"),no3=request.getParameter("NO3"),no4=request.getParameter("NO4"),no5=request.getParameter("NO5"),no6=request.getParameter("NO6"),no7=request.getParameter("NO7"),no8=request.getParameter("NO8"),no9=request.getParameter("NO9"),no10=request.getParameter("NO10");
  String no11=request.getParameter("NO11"),no12=request.getParameter("NO12"),no13=request.getParameter("NO13"),no14=request.getParameter("NO14"),no15=request.getParameter("NO15"),no16=request.getParameter("NO16"),no17=request.getParameter("NO17"),no18=request.getParameter("NO18"),no19=request.getParameter("NO19"),no20=request.getParameter("NO20");
  String no21=request.getParameter("NO21"),no22=request.getParameter("NO22"),no23=request.getParameter("NO23"),no24=request.getParameter("NO24"),no25=request.getParameter("NO25"),no26=request.getParameter("NO26"),no27=request.getParameter("NO27"),no28=request.getParameter("NO28"),no29=request.getParameter("NO29"),no30=request.getParameter("NO30");
  String no31=request.getParameter("NO31"),no32=request.getParameter("NO32"),no33=request.getParameter("NO33"),no34=request.getParameter("NO34"),no35=request.getParameter("NO35"),no36=request.getParameter("NO36"),no37=request.getParameter("NO37"),no38=request.getParameter("NO38"),no39=request.getParameter("NO39"),no40=request.getParameter("NO40");
  String no41=request.getParameter("NO41"),no42=request.getParameter("NO42"),no43=request.getParameter("NO43"),no44=request.getParameter("NO44"),no45=request.getParameter("NO45"),no46=request.getParameter("NO46"),no47=request.getParameter("NO47"),no48=request.getParameter("NO48"),no49=request.getParameter("NO49"),no50=request.getParameter("NO50");
  String [] allMonth={iNo,partCode,no1,no2,no3,no4,no5,no6,no7,no8,no9,no10,no11,no12,no13,no14,no15,no16,no17,no18,no19,no20,no21,no22,no23,no24,no25,no26,no27,no28,no29,no30,no31,no32,no33,no34,no35,no36,no37,no38,no39,no40,no41,no42,no43,no44,no45,no46,no47,no48,no49,no50};
  if (no1==null) no1="0.00"; if (no2==null) no2="0.00"; if (no3==null) no3="0.00"; if (no4==null) no4="0.00";if (no5==null) no5="0.00";if (no6==null) no6="0.00";if (no7==null) no7="0.00";if (no8==null) no8="0.00";if (no9==null) no9="0.00";if (no10==null) no10="0.00";
  if (no11==null) no11="0.00"; if (no12==null) no12="0.00"; if (no13==null) no13="0.00"; if (no14==null) no14="0.00";if (no15==null) no15="0.00";if (no16==null) no16="0.00";if (no17==null) no17="0.00";if (no18==null) no18="0.00";if (no19==null) no19="0.00";if (no20==null) no20="0.00";
  if (no21==null) no21="0.00"; if (no22==null) no22="0.00"; if (no23==null) no23="0.00"; if (no24==null) no24="0.00";if (no25==null) no25="0.00";if (no26==null) no26="0.00";if (no27==null) no27="0.00";if (no28==null) no28="0.00";if (no29==null) no29="0.00";if (no30==null) no30="0.00";
  if (no31==null) no31="0.00"; if (no32==null) no32="0.00"; if (no33==null) no33="0.00"; if (no34==null) no34="0.00";if (no35==null) no35="0.00";if (no36==null) no36="0.00";if (no37==null) no37="0.00";if (no38==null) no38="0.00";if (no39==null) no39="0.00";if (no40==null) no40="0.00";
  if (no41==null) no41="0.00"; if (no42==null) no42="0.00"; if (no43==null) no43="0.00"; if (no44==null) no44="0.00";if (no45==null) no45="0.00";if (no46==null) no46="0.00";if (no47==null) no47="0.00";if (no48==null) no48="0.00";if (no49==null) no49="0.00";if (no50==null) no50="0.00";
  if (iNo==null || iNo.equals("")) iNo = "1"; 
  
//if (delAll==null || delAll.equals("")) { } else { array2DDrawInputBean.setArray2DString(null); } 
try 
{    
   String at[][]=array2DDrawInputBean.getArray2DContent();//!Lu!Oo¢DO?e¢X}|C?oRe     
  //*************!LIDetail!MeRAuser¢Di!Aa|A-!N!±i?oRe,?G¢D2?!P!ON!La?oRe-??g?J¢X}|C?o
   if (at!=null) 
   {
      for (int ac=0;ac<at.length;ac++)
	  {    	        
          for (int subac=1;subac<at[ac].length;subac++)
	      {
		      at[ac][subac]=request.getParameter("MONTH"+ac+"-"+subac); //取上一頁之輸入欄位
		   }  //end for array second layer count
	  } //end for array first layer count
   	 array2DDrawInputBean.setArray2DString(at);  //reset Array
   }   //end if of array !=null
   //********************************************************************

  if (addItems!=null) //若有選取則表示要作刪除
  {
    String a[][]=array2DDrawInputBean.getArray2DContent();//重新取得陣列內容        
    if (a!=null && addItems.length>0)      
    { 		 
	 if (a.length>addItems.length)
	 {	  	  	    
       String t[][]=new String[a.length-addItems.length][a[0].length];   // 新陣列的大小= [原始列-選擇刪除列][行]  = [列][行]     
	   int cc=0;
	   for (int m=0;m<a.length;m++)
	   {
	    String inArray="N";		
		for (int n=0;n<addItems.length;n++)  
		{
		 if (addItems[n].equals(a[m][0])) inArray="Y";   // *** 指的是 比較 刪除的 CheckBox(AddItems) 被選起來 ***
		} //end of for addItems.length  		 
		if (inArray.equals("N")) 
		{
		  for (int gg=0;gg<52;gg++)  //置入陣列中元素數(注意..此處決定了陣列的Entity數目,若不同Entity數,必需修改此處,否則Delete 不Work)
		  {                           // 目前共52個 (iNo,partCode,no1,~ no50)    		 
			 if (gg==0)
			 {
			   t[cc][gg]= Integer.toString(cc+1); // 把第一行的值重算			  
			 }
			 else {
			        t[cc][gg]=a[m][gg];         
			      }
	      }
		 cc++;			     
		}  
	   } //end of for a.length	   
	   array2DDrawInputBean.setArray2DString(t);
	 } else { 	  // 表是選擇全部作刪除 			 
	          array2DDrawInputBean.setArray2DString(null); //!ON¢X}|C?oRe2MaA
	        }  
	}//end of if a!=null
  }  
  //dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//!ON?e!|A?O|^aicl-E
 } //end of try
 catch (Exception e)
 {
  out.println("Exception:"+e.getMessage());
 }  
 
 
 //  取此張檢驗批的類型及物料種類
 try
 {            
			  String sqlBas = "select a.IMATCODE, b.CLASS_DESC, c.IMAT_NAME from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_CLASS b, ORADDMAN.TSCIQC_IMATCODE c "+
			                 " where a.IQC_CLASS_CODE = b.CLASS_ID and a.IMATCODE = c.IMAT_CODE and INSPLOT_NO = '"+inspLotNo+"' and CLASS_ID ='"+classID+"' ";
		      Statement stateBas=con.createStatement();
              ResultSet rsBas=stateBas.executeQuery(sqlBas);
			  if (rsBas.next() && insertPage==null)
			  {
			    iMatCode =rsBas.getString("IMATCODE"); 
			    inspClassName = rsBas.getString("CLASS_DESC");
				materialType = rsBas.getString("IMAT_NAME");
			  }  // End of if (rsVal.next()) 	
			  //else if (aIQCWaferDiceCode!=null) examValue = aIQCWaferDiceCode[itemNo][examNo];			  		 
              rsBas.close();
              stateBas.close(); 
 
 } //end of try
 catch (SQLException e)
 {
  out.println("SQLException:"+e.getMessage());
 }  

%>
</head>
<table width="101%" border="0">
  <tr bgcolor="#C4AF9D">    
    <td width="33%" bordercolor="#FFFFFF" nowrap><font color="#993333">檢驗批單號</font>
       <font color="#000066" face="Arial"><strong>
       <% 		 		 		 
	     out.println(inspLotNo);
       %>  </strong></font>      
    </td>
    <td width="33%" bordercolor="#FFFFFF" nowrap><font color="#993333">檢驗類型</font>
       <font color="#000066" face="Arial"><strong>
       <% 		 		 		 
	     out.println(classID+"("+inspClassName+")");
       %>  </strong></font> 
    </td>
    <td width="33%" bordercolor="#FFFFFF" nowrap><font color="#993333">物料種類</font>
      <font color="#000066" face="Arial"><strong> 
      <% 		 		 		 
	     out.println(iMatCode+"("+materialType+")");
       %>  </strong></font> 
   </td>    
  </tr>
</table>
<table cellSpacing="1" bordercolordark="#D0C8C1" cellPadding="1" width="101%" align="center" borderColorLight="#ffffff" border="0">
  <tr bgcolor="#C4AF9D">
	  <td rowspan="1"><div align="center"><font color="#993333">圖位</font></div></td> 
	  <td>NO1</td>
	  <td>NO2</td> 
	  <td>NO3</td> 
	  <td>NO4</td>
	  <td>NO5</td> 
	  <td>NO6</td> 
	  <td>NO7</td>
	  <td>NO8</td> 
	  <td>NO9</td> 
	  <td>NO10</td>
	  <td>NO11</td>
	  <td>NO12</td> 
	  <td>NO13</td> 
	  <td>NO14</td>
	  <td>NO15</td> 
	  <td>NO16</td> 
	  <td>NO17</td>
	  <td>NO18</td> 
	  <td>NO19</td> 
	  <td>NO20</td>	
	  <td>NO21</td>
	  <td>NO22</td> 
	  <td>NO23</td> 
	  <td>NO24</td>
	  <td>NO25</td>
	  <td rowspan="4"><INPUT TYPE="button"  value='新增' onClick='setSubmit("../IQCInclude/TSIQCInspectLotDrawingInput.jsp?INSERT=Y")' ></td> 
</tr>
<tr>     
    <td width="4%" rowspan="4" bgcolor="#C4AF9D"> 
	    <select name="PARTCODE">
		    <option value="--" selected>--</option>		    
            <option value="A">A</option>
            <option value="B">B</option>
			<option value="C">C</option>
            <option value="D">D</option>
			<option value="E">D</option>
            <option value="F">F</option>
			<option value="G">G</option>
			<option value="H">H</option>
            <option value="I">I</option>
			<option value="J">J</option>
            <option value="K">K</option>
			<option value="L">L</option>
            <option value="M">M</option>
			<option value="N">N</option>
			<option value="O">O</option>
            <option value="P">P</option>
        </select> 
    </td>
    <td><input type="text" name="NO1" size="3%" <%if (allMonth[2]!=null) out.println("value="+allMonth[2]); else out.println("value="+no1);%> ></td>
	<td><input type="text" name="NO2" size="3%" <%if (allMonth[3]!=null) out.println("value="+allMonth[3]); else out.println("value="+no2);%> ></td>
    <td><input type="text" name="NO3" size="3%"  <%if (allMonth[4]!=null) out.println("value="+allMonth[4]); else out.println("value="+no3);%> ></td>
	<td><input type="text" name="NO4" size="3%"   <%if (allMonth[5]!=null) out.println("value="+allMonth[5]); else out.println("value="+no4);%>></td>
    <td><input type="text" name="NO5"  size="3%" <%if (allMonth[6]!=null) out.println("value="+allMonth[6]); else out.println("value="+no5);%>></td>
    <td><input type="text" name="NO6"  size="3%" <%if (allMonth[7]!=null) out.println("value="+allMonth[7]); else out.println("value="+no6);%>></td>
    <td><input type="text" name="NO7"  size="3%" <%if (allMonth[8]!=null) out.println("value="+allMonth[8]); else out.println("value="+no7);%>></td>
	<td><input type="text" name="NO8"  size="3%" <%if (allMonth[9]!=null) out.println("value="+allMonth[9]); else out.println("value="+no8);%>></td>
	<td><input type="text" name="NO9"  size="3%" <%if (allMonth[10]!=null) out.println("value="+allMonth[10]); else out.println("value="+no9);%>></td>
	<td><input type="text" name="NO10"  size="3%" <%if (allMonth[11]!=null) out.println("value="+allMonth[11]); else out.println("value="+no10);%>></td>
	<td><input type="text" name="NO11"  size="3%" <%if (allMonth[12]!=null) out.println("value="+allMonth[12]); else out.println("value="+no11);%>></td>
	<td><input type="text" name="NO12"  size="3%" <%if (allMonth[13]!=null) out.println("value="+allMonth[13]); else out.println("value="+no12);%>></td>
	<td><input type="text" name="NO13"  size="3%" <%if (allMonth[14]!=null) out.println("value="+allMonth[14]); else out.println("value="+no13);%>></td>
	<td><input type="text" name="NO14"  size="3%" <%if (allMonth[15]!=null) out.println("value="+allMonth[15]); else out.println("value="+no14);%>></td>
	<td><input type="text" name="NO15"  size="3%" <%if (allMonth[16]!=null) out.println("value="+allMonth[16]); else out.println("value="+no15);%>></td>
	<td><input type="text" name="NO16"  size="3%" <%if (allMonth[17]!=null) out.println("value="+allMonth[17]); else out.println("value="+no16);%>></td>
	<td><input type="text" name="NO17"  size="3%" <%if (allMonth[18]!=null) out.println("value="+allMonth[18]); else out.println("value="+no17);%>></td>
	<td><input type="text" name="NO18"  size="3%" <%if (allMonth[19]!=null) out.println("value="+allMonth[19]); else out.println("value="+no18);%>></td>
	<td><input type="text" name="NO19"  size="3%" <%if (allMonth[20]!=null) out.println("value="+allMonth[20]); else out.println("value="+no19);%>></td>
	<td><input type="text" name="NO20"  size="3%" <%if (allMonth[21]!=null) out.println("value="+allMonth[21]); else out.println("value="+no20);%>></td>
	<td><input type="text" name="NO21"  size="3%" <%if (allMonth[22]!=null) out.println("value="+allMonth[22]); else out.println("value="+no21);%>></td>
	<td><input type="text" name="NO22"  size="3%" <%if (allMonth[23]!=null) out.println("value="+allMonth[23]); else out.println("value="+no22);%>></td>
	<td><input type="text" name="NO23"  size="3%" <%if (allMonth[24]!=null) out.println("value="+allMonth[24]); else out.println("value="+no23);%>></td>
	<td><input type="text" name="NO24"  size="3%" <%if (allMonth[25]!=null) out.println("value="+allMonth[25]); else out.println("value="+no24);%>></td>
	<td><input type="text" name="NO25"  size="3%" <%if (allMonth[26]!=null) out.println("value="+allMonth[26]); else out.println("value="+no25);%>></td>	
</tr>
<tr bgcolor="#C4AF9D">	  
	  <td>NO26</td> 
	  <td>NO27</td>
	  <td>NO28</td> 
	  <td>NO29</td> 
	  <td>NO30</td>  
	  <td>NO31</td> 
	  <td>NO32</td>
	  <td>NO33</td> 
	  <td>NO34</td> 
	  <td>NO35</td>
	  <td>NO36</td> 
	  <td>NO37</td>
	  <td>NO38</td> 
	  <td>NO39</td> 
	  <td>NO40</td>  
	  <td>NO41</td> 
	  <td>NO42</td>
	  <td>NO43</td> 
	  <td>NO44</td> 
	  <td>NO45</td>
	  <td>NO46</td> 
	  <td>NO47</td>
	  <td>NO48</td> 
	  <td>NO49</td> 
	  <td>NO50</td>
</tr>
<tr>
    <td><input type="text" name="NO26"  size="3%" <%if (allMonth[27]!=null) out.println("value="+allMonth[27]); else out.println("value="+no26);%>></td>	
	<td><input type="text" name="NO27"  size="3%" <%if (allMonth[28]!=null) out.println("value="+allMonth[28]); else out.println("value="+no27);%>></td>
	<td><input type="text" name="NO28"  size="3%" <%if (allMonth[29]!=null) out.println("value="+allMonth[28]); else out.println("value="+no28);%>></td>
	<td><input type="text" name="NO29"  size="3%" <%if (allMonth[30]!=null) out.println("value="+allMonth[30]); else out.println("value="+no29);%>></td>
	<td><input type="text" name="NO30"  size="3%" <%if (allMonth[31]!=null) out.println("value="+allMonth[31]); else out.println("value="+no30);%>></td>
	<td><input type="text" name="NO31"  size="3%" <%if (allMonth[32]!=null) out.println("value="+allMonth[32]); else out.println("value="+no31);%>></td>
	<td><input type="text" name="NO32"  size="3%" <%if (allMonth[33]!=null) out.println("value="+allMonth[33]); else out.println("value="+no32);%>></td>
	<td><input type="text" name="NO33"  size="3%" <%if (allMonth[34]!=null) out.println("value="+allMonth[34]); else out.println("value="+no33);%>></td>
	<td><input type="text" name="NO34"  size="3%" <%if (allMonth[35]!=null) out.println("value="+allMonth[35]); else out.println("value="+no34);%>></td>
	<td><input type="text" name="NO35"  size="3%" <%if (allMonth[36]!=null) out.println("value="+allMonth[36]); else out.println("value="+no35);%>></td>
	<td><input type="text" name="NO36"  size="3%" <%if (allMonth[37]!=null) out.println("value="+allMonth[37]); else out.println("value="+no36);%>></td>
	<td><input type="text" name="NO37"  size="3%" <%if (allMonth[38]!=null) out.println("value="+allMonth[38]); else out.println("value="+no37);%>></td>
	<td><input type="text" name="NO38"  size="3%" <%if (allMonth[39]!=null) out.println("value="+allMonth[39]); else out.println("value="+no38);%>></td>
	<td><input type="text" name="NO39"  size="3%" <%if (allMonth[40]!=null) out.println("value="+allMonth[40]); else out.println("value="+no39);%>></td>
	<td><input type="text" name="NO40"  size="3%" <%if (allMonth[41]!=null) out.println("value="+allMonth[41]); else out.println("value="+no40);%>></td>
	<td><input type="text" name="NO41"  size="3%" <%if (allMonth[42]!=null) out.println("value="+allMonth[42]); else out.println("value="+no41);%>></td>
	<td><input type="text" name="NO42"  size="3%" <%if (allMonth[43]!=null) out.println("value="+allMonth[43]); else out.println("value="+no42);%>></td>
	<td><input type="text" name="NO43"  size="3%" <%if (allMonth[44]!=null) out.println("value="+allMonth[44]); else out.println("value="+no43);%>></td>
	<td><input type="text" name="NO44"  size="3%" <%if (allMonth[45]!=null) out.println("value="+allMonth[45]); else out.println("value="+no44);%>></td>
	<td><input type="text" name="NO45"  size="3%" <%if (allMonth[46]!=null) out.println("value="+allMonth[46]); else out.println("value="+no45);%>></td>
	<td><input type="text" name="NO46"  size="3%" <%if (allMonth[47]!=null) out.println("value="+allMonth[47]); else out.println("value="+no46);%>></td>
	<td><input type="text" name="NO47"  size="3%" <%if (allMonth[48]!=null) out.println("value="+allMonth[48]); else out.println("value="+no47);%>></td>
	<td><input type="text" name="NO48"  size="3%" <%if (allMonth[49]!=null) out.println("value="+allMonth[49]); else out.println("value="+no48);%>></td>
	<td><input type="text" name="NO49"  size="3%" <%if (allMonth[50]!=null) out.println("value="+allMonth[50]); else out.println("value="+no49);%>></td>
	<td><input type="text" name="NO50"  size="3%" <%if (allMonth[51]!=null) out.println("value="+allMonth[51]); else out.println("value="+no50);%>></td>
    </tr>  
  <tr>  
    <td colspan="8"></td>
    </tr>
  <tr bgcolor="#FFCC33">
    <td bgcolor="#C4AF9D" colspan="32">
     <%
	  try
      { //out.println("Step0");
	    String oneDArray[]= {"","NO","PART","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50"}; 	 	     			  
    	array2DDrawInputBean.setArrayString(oneDArray);
	     String a[][]=array2DDrawInputBean.getArray2DContent();//!Lu!Oo¢DO?e¢X}|C?oRe  	   			    
		 int i=0,j=0,k=0;
	     if (partCode!=null && !partCode.equals("--") && bringLast==null) //bringLast?O¢DI!LOAN!±O?O!±_!Oa¢DX?W?@|!M?e?J?!±3I!Psac¢D?!MeRA
		 { out.println("Step1");           		    
		   if (a!=null) 
		   {  out.println("Step2");
		     String b[][]=new String[a.length+1][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 {
			  for (j=0;j<a[i].length;j++)
			  {
			    if (a[i][j]!=null && !a[i][j].equals("") && !a[i][j].equals("null")) // 判斷 array內容,不為 null或空值才存入陣列
				{
			      b[i][j]=a[i][j];	
				}  //  不為 null或空值才存入陣列 				
			  }			  
			  // k++;          
			   if (b[k][1]!=null && !b[k][1].equals("--") && !b[k][1].equals("null")) //判斷partCode內容,不為null或空值才累加_起 
			   {
			     k++;
			   } // 判斷interface內容,不為null或空值才累加_迄    
			 }
			 
			 iNo = Integer.toString(k+1);  // 把料項序號給第一個位置
             
			 //b[k][0]=chooseItem;			 
			 b[k][0]=iNo;b[k][1]=partCode;b[k][2]=no1;b[k][3]=no2;b[k][4]=no3;b[k][5]=no4;b[k][6]=no5;b[k][7]=no6;b[k][8]=no7;b[k][9]=no8;b[k][10]=no9;b[k][11]=no10;
			 b[k][12]=no11;b[k][13]=no12;b[k][14]=no13;b[k][15]=no14;b[k][16]=no15;b[k][17]=no16;b[k][18]=no17;b[k][19]=no18;b[k][20]=no19;b[k][21]=no20;	
			 b[k][22]=no21;b[k][23]=no22;b[k][24]=no23;b[k][25]=no24;b[k][26]=no25;b[k][27]=no26;b[k][28]=no27;b[k][29]=no28;b[k][30]=no29;b[k][31]=no30;
			 b[k][32]=no31;b[k][33]=no32;b[k][34]=no33;b[k][35]=no34;b[k][36]=no35;b[k][37]=no36;b[k][38]=no37;b[k][39]=no38;b[k][40]=no39;b[k][41]=no40;	
			 b[k][42]=no41;b[k][43]=no42;b[k][44]=no43;b[k][45]=no44;b[k][46]=no45;b[k][47]=no46;b[k][48]=no47;b[k][49]=no48;b[k][50]=no49;b[k][51]=no50; 
			 array2DDrawInputBean.setArray2DString(b); 			 						 			 	   			              
		   } 
		   else 
		   {	//out.println("Step3");
		           if (partCode!=null && !partCode.equals("--"))
				   { 
		            String c[][]={{iNo,partCode,no1,no2,no3,no4,no5,no6,no7,no8,no9,no10,no11,no12,no13,no14,no15,no16,no17,no18,no19,no20,no21,no22,no23,no24,no25,no26,no27,no28,no29,no30,no31,no32,no33,no34,no35,no36,no37,no38,no39,no40,no41,no42,no43,no44,no45,no46,no47,no48,no49,no50}};			             			 
		            array2DDrawInputBean.setArray2DString(c); 	
				   }	
			 //array2DDrawInputBean.setArray2DString(null);  // if DELETE 					 	                
		   }                   	                       		        		  
		 } else {
		   if (a!=null) 
		   {//out.println("Step4");
		     array2DDrawInputBean.setArray2DString(a);     			       	                
		   } 
		 }
		 //end if of chooseItem is null
		 //out.println("Step5");
		 //###################¢Xw1i¢DO?e¢X}|C?oRe?i|aAE?d?!O!Li#############################		  
		  Statement chkstat=con.createStatement();
          ResultSet chkrs=null;
		  String T2[][]=array2DDrawInputBean.getArray2DContent();//!Lu!Oo¢DO?e¢X}|C?oRe¢X£g?¢X?E|s¢DI;	  			  	
		  String tp[]=array2DDrawInputBean.getArrayContent();
		  if  (T2!=null) 
		  {  		   
		    //-------------------------!Lu!OoAa|s¢DI¢X}|C-------------------- 		    
	        String temp[][]=new String[T2.length][T2[0].length];		    
			 for (int ti=0;ti<T2.length;ti++)
			 {
			    for (int tj=0;tj<T2[ti].length;tj++)  
			   {				 
				  temp[ti][tj]=T2[ti][tj];
				}
		      }		
		    //--------------------------------------------------------------------
			int ti=0,tj=0;
            
            temp[ti][tj]="N";
		    array2DDrawInputBean.setArray2DCheck(temp);  //!Mm?JAE?d¢X}|C¢DH?¢X!O!O!Li?!±¢DI			   
		  } else {    		      		     
		      array2DDrawInputBean.setArray2DCheck(null);
		  }	 //end if of T2!=null	   
		  if (chkrs!=null) chkrs.close();
		  chkstat.close();		  
		 //##############################################################	    	 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
     %>	 
	</td>              
    </tr>
</table>
<table border="1" cellSpacing="0" cellPadding="0" width="101%" align="center" bordercolorlight="#FFFFFF" bordercolordark="#B9BB99">
 <tr bgcolor="#C4AF9D">
  <td colspan="3"> 
   <input name="button" type=button onClick="this.value=check(this.form.ADDITEMS)" value='選擇全部'>
  <font color='#336699' size='2'>-----DETAIL you choosed to be saved--------------------------------------------------------------------------------------------------------------------------------------</font>
  </td>  
 </tr>
 <tr bgcolor="#C4AF9D">
  <td colspan="3">
<% 
     int div1=0,div2=0;      //¢X£g?¢X1Boa|@|3|h?O-OrowcMcolumn?e?JAa|iaoAU?A
	  try
      {	//out.println("Step6");
	    String a[][]=array2DDrawInputBean.getArray2DContent();//!Lu!Oo¢DO?e¢X}|C?oRe 
        	    		                       		    		  	   
         if (a!=null) 
		 {//out.println("Step7");
		        div1=a.length;
				div2=a[0].length;
	        	array2DDrawInputBean.setFieldName("ADDITEMS");			
                //out.println("Step8");   			 	   			 
                //out.println(array2DDrawInputBean.getArray2DString());
				out.println(array2DDrawInputBean.getArray2DDrawString());
                isModelSelected = "Y";	// 若Model 明細內有任一筆資料,則為 "Y" 	       		   	 				
		 }	//enf of a!=null if
           
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
</td>
 </tr> 
 <tr bgcolor="#C4AF9D">
   <td colspan="3">
<INPUT name="button2" TYPE="button" onClick='setSubmit("../IQCInclude/TSIQCInspectLotDrawingInput.jsp?INSERT=Y")'  value='刪除' >
<font color='#336699' size='2'>-----CLICK checkbox and choice to delete----------------------------------------------------------------------------------------------------------------------------------------</font>	
</td>
 </tr>
</table>
<HR>
<INPUT TYPE="button"  value='儲存' onClick='setSubmit2("../IQCInclude/TSIQCInspectLotDrawingInsert.jsp",<%=div1%>,<%=div2%>)' >
<!-- ai3a¢XN?A -->      	
	<input name="INSERT" type="HIDDEN" value="<%=insertPage%>">
	<input name="INO" type="HIDDEN" value="<%=iNo%>" >
	<input name="INSPLOTNO" type="hidden" value="<%=inspLotNo%>" >
	<input name="CLASSID" type="hidden" value="<%=classID%>" >
	<input name="INSPCLASSNAME" type="hidden" value="<%=inspClassName%>" >
	<input name="MATERIALTYPE" type="hidden" value="<%=materialType%>" >
</FORM>
</body>
<!--=============¢FFDH?U¢FFXI?q?¢FFXAAcn3s¢FGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
