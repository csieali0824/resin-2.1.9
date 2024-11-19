<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,oracle.sql.*,oracle.jdbc.driver.*,java.sql.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="com.jspsmart.upload.*,DateBean"%>
<!--=================================-->
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
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
<title>TS Label Process</title>
</head>
<body>
<FORM NAME="MYFORMD" METHOD="POST"> 
<%

String LABEL_CODE = request.getParameter("LABEL_CODE");
if (LABEL_CODE==null) LABEL_CODE="";
String LABEL_GROUP_CODE =request.getParameter("LABEL_GROUP_CODE");
if (LABEL_GROUP_CODE==null) LABEL_GROUP_CODE="";
String LABEL_NAME =request.getParameter("LABEL_NAME");
if (LABEL_NAME==null) LABEL_NAME="";
String LABEL_TYPE_CODE = request.getParameter("LABEL_TYPE_CODE");
if (LABEL_TYPE_CODE==null) LABEL_TYPE_CODE="";
String EFFECTIVE_FROM = request.getParameter("EFFECTIVE_FROM");
if (EFFECTIVE_FROM==null) EFFECTIVE_FROM="";
String EFFECTIVE_TO =request.getParameter("EFFECTIVE_TO");
if (EFFECTIVE_TO==null) EFFECTIVE_TO="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String SHIPPING_MARK= request.getParameter("SHIPPING_MARK"); 
if (SHIPPING_MARK==null) SHIPPING_MARK="";
String REMARKS= request.getParameter("REMARKS");  
if (REMARKS==null) REMARKS="";
//out.println("SHIPPING_MARK="+SHIPPING_MARK);
String sql ="",strExist="",strNoFound="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

try
{
	if (STATUS.equals("UPD"))
	{
		sql= " update oraddman.tsyew_label_all  "+
			 " set LABEL_NAME=?"+
			 ",LABEL_GROUP_CODE=?"+
			 ",LABEL_TYPE_CODE=?"+
			 ",EFFECTIVE_FROM_DATE=TO_DATE(?,'yyyymmdd')"+
			 ",EFFECTIVE_TO_DATE=to_date(?,'yyyymmdd')"+
			 ",LAST_UPDATED_BY=?"+
			 ",LAST_UPDATE_DATE=sysdate"+
			 ",REMARKS=?"+
			 " where LABEL_CODE = ?";
		//out.println(sql);
		PreparedStatement st1 = con.prepareStatement(sql);
		st1.setString(1,LABEL_NAME);
		st1.setString(2,LABEL_GROUP_CODE); 
		st1.setString(3,LABEL_TYPE_CODE); 
		st1.setString(4,(EFFECTIVE_FROM.equals("")?"":EFFECTIVE_FROM));
		st1.setString(5,(EFFECTIVE_TO.equals("")?"":EFFECTIVE_TO));
		st1.setString(6,UserName);
		st1.setString(7,REMARKS); 
		st1.setString(8,LABEL_CODE);
		st1.executeUpdate();
		st1.close();
		
	}
	else
	{
		sql = " select  'TSYEW'|| LPAD(NVL(MAX(TO_NUMBER(REPLACE(UPPER(LABEL_CODE),'TSYEW',''))),0)+1,4,'0') AS SEQ from oraddman.tsyew_label_all a ";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			LABEL_CODE = rs.getString(1);
		}
		rs.close();
		statement.close();	
			
		sql = " insert into oraddman.tsyew_label_all "+
			  " (label_code"+
			  ", label_name"+
			  ", label_file"+
			  ", label_group_code"+
			  ", label_type_code"+
			  ", effective_from_date"+
			  ", effective_to_date"+
			  ", creation_date"+
			  ", created_by"+
			  ", last_update_date"+
			  ", last_updated_by"+
			  ", REMARKS)"+ 
			  " values ("+
			  " ?"+
			  ",?"+
			  ",empty_blob()"+
			  ",?"+
			  ",?"+
			  ",TO_DATE(?,'yyyymmdd')"+
			  ",TO_DATE(?,'yyyymmdd')"+
			  ",sysdate"+
			  ",?"+
			  ",sysdate"+
			  ",?"+
			  ",?)";
		//out.println(sql);
		PreparedStatement st1 = con.prepareStatement(sql);
		st1.setString(1,LABEL_CODE);	
		st1.setString(2,LABEL_NAME);
		st1.setString(3,LABEL_GROUP_CODE); 
		st1.setString(4,LABEL_TYPE_CODE); 
		st1.setString(5,(EFFECTIVE_FROM.equals("")?"":EFFECTIVE_FROM));
		st1.setString(6,(EFFECTIVE_TO.equals("")?"":EFFECTIVE_TO));
		st1.setString(7,UserName); 
		st1.setString(8,UserName); 
		st1.setString(9,REMARKS); 
		st1.executeUpdate();
		st1.close();
			
	}	

	mySmartUpload.initialize(pageContext); 
	mySmartUpload.upload();
	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
	String uploadFile_name="",uploadFilePath="";
	uploadFile_name=upload_file.getFileName();
	//out.println("uploadFile_name="+uploadFile_name);
	uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_label\\"+LABEL_CODE+"."+upload_file.getFileExt();
	upload_file.saveAs(uploadFilePath); 

	if  (!upload_file.isMissing()) 
	{
		Statement stmt=con.createStatement();
		ResultSet rs7=stmt.executeQuery("select label_file from oraddman.tsyew_label_all where LABEL_CODE='"+LABEL_CODE+"' for UPDATE");  	
		if (rs7.next())
		{
			BLOB myblob=null;
			FileInputStream instream=null;
			OutputStream outstream=null;
			int bufsize=0;
			byte[] buffer =null;
			int fileLength=0;   
 
			myblob=((OracleResultSet)rs7).getBLOB(1);
			instream=new FileInputStream(uploadFilePath);
			outstream=myblob.getBinaryOutputStream();
			bufsize=myblob.getBufferSize();
			buffer = new byte[bufsize];   
			while ((fileLength=instream.read(buffer))!=-1)   
				outstream.write(buffer,0,fileLength);
			instream.close();	 
			outstream.close();	        	   
		}
		rs7.close();
	}
		
	if (STATUS.equals("UPD"))		
	{
%>
		<script language="javascript">
			alert("修改成功!!");
			location.replace("/oradds/jsp/TSYewLabelFilesQuery.jsp?LABEL_GROUP=<%=LABEL_GROUP_CODE%>")
		</script>	
<%
	}
	else
	{
%>
		<script language="javascript">
			alert("新增成功!!");
			location.replace("/oradds/jsp/TSYewLabelFilesAdd.jsp?LABEL_GROUP=<%=LABEL_GROUP_CODE%>")
		</script>
<%
	}
}
catch(Exception e)
{
	out.println("<div align='center' style='color:#ff0000'>交易失敗:"+e.getMessage()+"</div>");
}

%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
