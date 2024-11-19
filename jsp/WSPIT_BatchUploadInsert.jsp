<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="java.io.*,DateBean,jxl.*,jxl.write.*,jxl.format.*" %>
<!--=============To get the Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title>Insert PIT UploadFile into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
</head>
<body>
<%
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();
com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
upload_file.saveAs("c://clientupload/PIT/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
String uploadFile_name=upload_file.getFileName();
String uploadFilePath="c://clientupload/PIT/"+request.getRemoteAddr()+"-"+upload_file.getFileName();

//OPEN FILE
InputStream is = new FileInputStream(uploadFilePath);   // open uplad file
jxl.Workbook wb = Workbook.getWorkbook(is);  // open work book
jxl.Sheet sht = wb.getSheet(0);
int iMaxRows = sht.getRows(); // get max rows
int iMaxColumns=sht.getColumns(); //get Max Columns
//System.err.println("row:"+iMaxRows+" , column:"+iMaxColumns);

String model=mySmartUpload.getRequest().getParameter("MODEL");
String product=mySmartUpload.getRequest().getParameter("PRODUCT");
String object=mySmartUpload.getRequest().getParameter("OBJECT");
String version=mySmartUpload.getRequest().getParameter("VERSION");
String source=mySmartUpload.getRequest().getParameter("SOURCE");
String dateString="",seqkey="",seqno="";
String fromStatus=mySmartUpload.getRequest().getParameter("FROMSTATUS");
String action=mySmartUpload.getRequest().getParameter("ACTION");
String formID=mySmartUpload.getRequest().getParameter("FORMID");
String typeNo=mySmartUpload.getRequest().getParameter("TYPENO");

Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
ResultSet rs=null;

try
{	               	 	        
  if  (!upload_file.isMissing())
  {         
    //*********取得下一個流程資訊**********************************
    String nextStatus="",nextStatusName="";     
    rs=statement.executeQuery("select TOSTATUSID,STATUSNAME from WSWORKFLOW w,WSWFSTATUS s where TOSTATUSID=STATUSID and FORMID='"+formID+"' and TYPENO='"+typeNo+"' and FROMSTATUSID='"+fromStatus+"' and ACTIONID='"+action+"'");
    if (rs.next())
    {
     nextStatus=rs.getString("TOSTATUSID");  
 	 nextStatusName=rs.getString("STATUSNAME");        
    }    
    rs.close();  
    //************END OF 取得下一個流程資訊**************************     
  
    dateString=dateBean.getYearMonthDay(); 	     
	int i=4; //data set from 5th row
	String s="";		
	
	while (i<iMaxRows)
	{	
	  jxl.Cell cs = sht.getCell(0,i);	     
	  String cellStr=cs.getContents();		
	  if (!cellStr.equals("") && cellStr!=null) //當有資料內容時才新增
	  {	
		  //to get the series number   
		  seqkey="PIT"+dateString.substring(2); //this is the key,ex:PIT050603
		  rs=statement.executeQuery("select * from DOCSEQ where header='"+seqkey+"'");  
		  if (rs.next()==false)
		  {   
			String seqSql="insert into DOCSEQ values(?,?)";   
			PreparedStatement seqstmt=con.prepareStatement(seqSql);     
			seqstmt.setString(1,seqkey);
			seqstmt.setInt(2,1);   	
			seqstmt.executeUpdate();
			seqno=seqkey+"-0001";
			seqstmt.close();   
		  } else {   
			int lastno=rs.getInt("LASTNO");
			lastno++;
			String numberString = Integer.toString(lastno);
			String lastSeqNumber="0000"+numberString;
			lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-4);
			seqno=seqkey+"-"+lastSeqNumber;      
			String seqSql="update DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
			PreparedStatement seqstmt=con.prepareStatement(seqSql);        
			seqstmt.setInt(1,lastno);   	
			seqstmt.executeUpdate();   
			seqstmt.close(); 
		  }
		  rs.close(); 
		//============end of get series ================================= 		
		
		  String result="";	       	 
		  String sql="insert into PIT_MASTER(TICKETNO,MFUNCTION,SFUNCTION,S_LEVEL,PHNMN,ISP_SIM,ISP_NETWORK,PBBT,COMPARISON,LOCATION,RESULT,"+
					 "PRODUCT,MODEL,T_OBJECT,T_VERSION,T_SOURCE,ENTRYDATE,ENTRYTIME,ENTRYBY,STATUSID,STATUS) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		  PreparedStatement pstmt=con.prepareStatement(sql);		  
		  
		  pstmt.setString(1,seqno); //TicketNo 	  			  
		  for (int column=2;column<12;column++) 
		  {	  	   	 	    	    
			jxl.Cell s1 = sht.getCell(column-1,i);			
			s = s1.getContents();		
			s=s.trim();	   
			//System.err.println("columne no:"+column+" ->"+s);
			if (column==11) //this is Result in column=11
			{
				result=s;							      
			}
			pstmt.setString(column,s);               	   	  	     	      	    
		  }	  	 	   
		  
		  pstmt.setString(12,product);  
		  pstmt.setString(13,model);  
		  pstmt.setString(14,object);  
		  pstmt.setString(15,version);  
		  pstmt.setString(16,source); 	      
		  pstmt.setString(17,dateString); 	
		  pstmt.setString(18,dateBean.getHourMinute());
		  pstmt.setString(19,userID); 	
		  if (result.equals("OK")) 	//if result="OK",then close
		  { 
			pstmt.setString(20,"109"); //statusid 	
			pstmt.setString(21,"CLOSE"); //status		  
		  } else { 
			pstmt.setString(20,nextStatus); //statusid 	
			pstmt.setString(21,nextStatusName); //status	
		  }		
		  pstmt.executeUpdate();
		  pstmt.close(); 	  	  	 		  	 
	   } //end of if =>if (!cellStr.equals("") && cellStr!=null)
	   i++;
	 } //end of while to each row			
	 is.close();	  		
     out.println("<A HREF='WSPIT_BatchUploadEntry.jsp'>Upload PIT Data File</A>");
	%>
    &nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../WinsMainMenu.jsp'>HOME</A><BR>     	
	<%
	out.println("The file has been upload success!!<BR>");		
  } else {
    out.println("The file has been missed or not been selected!! Please try it again!!<BR>"); 
  }   
} //end of try
catch (Exception ee)
{
  %>
    <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
  <%
 out.println(ee.getMessage());
}//end of catch
%>
</body>
</html>
<%
  statement.close();  
%>
<!--=============To release the Connection==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
