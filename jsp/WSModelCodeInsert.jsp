<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="java.io.*,oracle.sql.*,oracle.jdbc.driver.*,DateBean,ArrayCheckBoxBean" %>
<html>
<head>
<title></title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!-- 2004-10-20 ADD 上市日期 to PIMASTER -->
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<%// By Kerwin for upload file%>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<%// By Kerwin for upload file%>
</head>
<body>
<%
// For upload file By Kerwin
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();
// For upload file By Kerwin

String APPNO="";
/*
String WEBID=request.getParameter("WEBID");
String RD_CODE=request.getParameter("RD_CODE");
String PCLS_CODE=request.getParameter("PCLS_CODE");
String APPEAR_CODE=request.getParameter("APPEAR_CODE");
String PLATFORM_CODE=request.getParameter("PLATFORM_CODE");
String PRODEXT_CODE=request.getParameter("PRODEXT_CODE");
String FTURE_CODE=request.getParameter("FTURE_CODE");
String FTURE_CODE2=request.getParameter("FTURE_CODE2");
String SALESCODE=request.getParameter("SALESCODE");
String BUYER=request.getParameter("BUYER");
String REMARK=request.getParameter("REMARK");
*/
String WEBID=mySmartUpload.getRequest().getParameter("WEBID");
String RD_CODE=mySmartUpload.getRequest().getParameter("RD_CODE");
String PCLS_CODE=mySmartUpload.getRequest().getParameter("PCLS_CODE");
String APPEAR_CODE=mySmartUpload.getRequest().getParameter("APPEAR_CODE");
String PLATFORM_CODE=mySmartUpload.getRequest().getParameter("PLATFORM_CODE");
String PRODEXT_CODE=mySmartUpload.getRequest().getParameter("PRODEXT_CODE");
String FTURE_CODE=mySmartUpload.getRequest().getParameter("FTURE_CODE");
String FTURE_CODE2=mySmartUpload.getRequest().getParameter("FTURE_CODE2");
String SALESCODE=mySmartUpload.getRequest().getParameter("SALESCODE");
String BUYER=mySmartUpload.getRequest().getParameter("BUYER");
String REMARK=mySmartUpload.getRequest().getParameter("REMARK");
String NXSERNO=mySmartUpload.getRequest().getParameter("NXSERNO"); // Y 往下序號
String SERNO=mySmartUpload.getRequest().getParameter("SERNO");     // 不序號時需給 序號
String SPLATFM_NAME="";

System.err.println("Step1");

String seqno=null;
String seqkey=null;
String dateString=null;
//String recPersonID="B01815";
String recPersonID=userID;
String remark=mySmartUpload.getRequest().getParameter("REMARK");   //String remark=request.getParameter("REMARK");
String MODELNO=RD_CODE+PCLS_CODE+APPEAR_CODE+PLATFORM_CODE;
String RDDPT=null;
String PROD_CLASS=null;
String seqnoApp=null;
/*
String pjtnYear=request.getParameter("PJTNYEAR");
String pjtnMonth=request.getParameter("PJTNMONTH");
String pjtnDay=request.getParameter("PJTNHDAY");
*/
String pjtnYear=mySmartUpload.getRequest().getParameter("PJTNYEAR");
String pjtnMonth=mySmartUpload.getRequest().getParameter("PJTNMONTH");
String pjtnDay=mySmartUpload.getRequest().getParameter("PJTNHDAY"); 

 
String pjtnDate=pjtnYear+pjtnMonth+pjtnDay;
//String recYear=request.getParameter("RECYEAR");
//String recMonth=request.getParameter("RECMONTH");
//String recDay=request.getParameter("RECDAY"); 
//String recDate=recYear+recMonth+recDay;
String MVERSION=null;
String user_NAME=null;
int lastmno=0;


// FOR UPLOAD FILE bY KERWIN //

System.err.println("Step2");

com.jspsmart.upload.File front_file=mySmartUpload.getFiles().getFile(0);
front_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName()); 
String frontFile_name=front_file.getFileName();
String frontFilePath="c://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName();
com.jspsmart.upload.File side_file=mySmartUpload.getFiles().getFile(1); 
side_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+side_file.getFileName());
String sideFile_name=side_file.getFileName();
String sideFilePath="c://clientupload/"+request.getRemoteAddr()+"-"+side_file.getFileName();

// FOR UPLOAD FILE bY KERWIN //


System.err.println("Step3");

try
{ // 先取 PM UID作為產生單號依據 起
  String pmUid = "";   
  Statement statePMUID=con.createStatement();
  ResultSet rsPMUID=statePMUID.executeQuery("select * from MRPM_USER where WEBID='"+WEBID+"'");
  if (rsPMUID.next()) {
   pmUid = rsPMUID.getString("PMUID"); 
   user_NAME = rsPMUID.getString("USER_NAME");
  } 
  rsPMUID.close();
  statePMUID.close(); 
  // 先取 PM UID作為產生單號依據 止    
  //////////////////////////////////////////////////////////////////////////////////////
//  out.println("Step1="); 
   String dateStringGet=dateBean.getYearMonthDay();
		 // Hour=dateBean.getHourMinute();
		  //out.print(Hour);
   String seqkeyApp="MR"+pmUid+dateStringGet;
   seqnoApp="";
          //====先取得申請流水號===== 
		   //out.print(seqkey);
   Statement stateA=con.createStatement();
   ResultSet rsA=stateA.executeQuery("select * from DOCSEQ where header='"+seqkeyApp+"'");
  
   if (rsA.next()==false)
    {
//     out.println("Step2=");  
      String seqSqlA="insert into DOCSEQ values(?,?)";   
      PreparedStatement seqstmtA=con.prepareStatement(seqSqlA);     
      seqstmtA.setString(1,seqkeyApp);
      seqstmtA.setInt(2,1);   
// out.println("Step3="); 
      seqstmtA.executeUpdate();
      seqnoApp=seqkeyApp+"-01";
      seqstmtA.close();   
    } 
  else
    {
      int lastnoApp=rsA.getInt("LASTNO");
//  out.println("Step4=");      
      String sqlB = "select * from MRMODELAPP where substr(APPNO,1,13)='"+seqkeyApp+"' and to_number(substr(APPNO,15,2))= '"+lastnoApp+"' ";
      ResultSet rsB=stateA.executeQuery(sqlB); 
   //===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
      if (rsB.next())
        {         
          lastnoApp++;
          String numberString = Integer.toString(lastnoApp);
          String lastSeqNumber="00"+numberString;
          lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-2);
          seqnoApp=seqkeyApp+"-"+lastSeqNumber;     
   
         String seqSqlB="update DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkeyApp+"'";   
         PreparedStatement seqstmtB=con.prepareStatement(seqSqlB);        
         seqstmtB.setInt(1,lastnoApp);   
//	 out.println("Step5="); 
         seqstmtB.executeUpdate();   
         seqstmtB.close(); 
       } 
      else
       { 
   //out.println("Step6="); 
      //===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
        String sSqlC = "select to_number(substr(max(APPNO),15,2)) as LASTNO from MRMODELAPP where substr(APPNO,1,13)='"+seqkeyApp+"' ";
        ResultSet rsC=stateA.executeQuery(sSqlC);
	 
	    if (rsC.next()==true)
	      {
            int lastno_r=rsC.getInt("LASTNO");
	  
	        lastno_r++;
	  
	        String numberString_r = Integer.toString(lastno_r);
            String lastSeqNumber_r="00"+numberString_r;
            lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-2);
            seqnoApp=seqkeyApp+"-"+lastSeqNumber_r;  
	 
	        String seqSqlC="update DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkeyApp+"'";   
            PreparedStatement seqstmtC=con.prepareStatement(seqSqlC);        
            seqstmtC.setInt(1,lastno_r);   
	
            seqstmtC.executeUpdate();   
            seqstmtC.close();  
	      }
        rsC.close();
       } // end of else rsB
       rsB.close();
    }  //end of 流水編號
    rsA.close();
    stateA.close();  
  ///////////////////////////////////////////////////////////////////////////////


//  out.println("Step7="); 

  dateString=dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();
  MVERSION=dateString;
  seqkey=PLATFORM_CODE;
  //====先取得產品流水號=====  
  Statement statement=con.createStatement();
  ResultSet rs=statement.executeQuery("select * from DOCSEQ where header='"+seqkey+"'");
  if (rs.next()==false)
    {  // out.println("Step8=");  
      String seqSql="insert into DOCSEQ values(?,?)";   
      PreparedStatement seqstmt=con.prepareStatement(seqSql);     
      seqstmt.setString(1,seqkey);
      seqstmt.setInt(2,1);   
	
      seqstmt.executeUpdate();
      seqno="01";
      seqstmt.close();  
   //out.println("Step8=");  
   //   MODELNO=MODELNO+seqno+PRODEXT_CODE+FTURE_CODE+FTURE_CODE2; 
    } 
  else
    {
      int lastno=rs.getInt("LASTNO");
//	  out.println(" "+MODELNO);
      if (NXSERNO !=null && NXSERNO.equals("Y") )
        {    
          String sql = "select * from MRMODELAPP where substr(MODELNO,4,2)='"+seqkey+"' and to_number(substr(MODELNO,6,2))= "+lastno+" ";
          ResultSet rs2=statement.executeQuery(sql); 
   //===(處理跳號問題)若rprepair及mrdocseq皆存在相同最大號=========依原方式取最大號 //
          if (rs2.next())
            {         
              lastno++;
              String numberString = Integer.toString(lastno);
              String lastSeqNumber="00"+numberString;
              lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-2);
              seqno=lastSeqNumber;     
//         	  out.println(lastno);
 
              String seqSql="update DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
              PreparedStatement seqstmt=con.prepareStatement(seqSql);        
              seqstmt.setInt(1,lastno);   
              seqstmt.executeUpdate();   
              seqstmt.close(); 
            } 
          else
            {
   //===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前mrdocSeq的lastno內容(會依維修地區別)
              String sSql = "select to_number(substr(max(MODELNO),6,2)) as LASTNO from MRMODELAPP where substr(MODELNO,4,2)='"+seqkey+"' ";
              ResultSet rs3=statement.executeQuery(sSql);
	 
     	      if (rs3.next()==true)
                {
                  int lastno_r=rs3.getInt("LASTNO");
             	  lastno_r++;
             	  String numberString_r = Integer.toString(lastno_r);
                  String lastSeqNumber_r="00"+numberString_r;
                  lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-2);
                  seqno=lastSeqNumber_r;
	 
            	  String seqSql="update DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
                  PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                  seqstmt.setInt(1,lastno_r);   
                  seqstmt.executeUpdate();   
                  seqstmt.close();  
   	            }  // END OF IF
            }  // END OF ELSE
		}   // end of nxserno	
      else
      if (NXSERNO==null || NXSERNO.equals(""))
        {
		  String numberString = SERNO;
          String lastSeqNumber="00"+numberString;
          lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-2);
          seqno=lastSeqNumber;     
		}
    }   // END OF ELSE  

  if (FTURE_CODE.equals("--")) FTURE_CODE="";
  if (FTURE_CODE2.equals("--")) FTURE_CODE2="";
  MODELNO=MODELNO+seqno+PRODEXT_CODE+FTURE_CODE+FTURE_CODE2; 
//  out.println("Step10=");  
  //=============================================================================      
     String sSql = "select RDDPT from MRDPT where RD_CODE = '"+RD_CODE+"' ";
     ResultSet rs4=statement.executeQuery(sSql);
	 if (rs4.next()==true)
    	  RDDPT=rs4.getString("RDDPT");

     String sSqlz = "select PROD_CLASS from MRPRODCLS where PCLS_CODE = '"+PCLS_CODE+"' ";
     ResultSet rs5=statement.executeQuery(sSqlz);
	 if (rs5.next()==true)
    	  PROD_CLASS=rs5.getString("PROD_CLASS");
//  out.println("seqnoApp="+seqnoApp);


  String sqlw="insert into MRMODELAPP values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sqlw);  
  pstmt.setString(1,"MO");
  //pstmt.setString(2,"N/A");
  pstmt.setString(2,seqnoApp);
  pstmt.setString(3,MODELNO);
  pstmt.setString(4,"");
  pstmt.setString(5,BUYER);
  pstmt.setString(6,"");
  pstmt.setString(7,"");
  pstmt.setString(8,pjtnDate);
  pstmt.setString(9,"");
  pstmt.setString(10,RDDPT);
  pstmt.setString(11,PROD_CLASS);  
  pstmt.setString(12,REMARK);
  pstmt.setString(13,WEBID);
  pstmt.setString(14,dateStringGet);
  pstmt.setString(15,userID);
  pstmt.setString(16,dateString);
  pstmt.setString(17,MVERSION);
  pstmt.executeUpdate(); 

  //===INSERT INTO HISTORY==========================================================      
  String sqlh="insert into MRMODEL_HIST values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  pstmt=con.prepareStatement(sqlh);  
  pstmt.setString(1,"MO");
  //pstmt.setString(2,"N/A");
  pstmt.setString(2,seqnoApp);
  pstmt.setString(3,MODELNO);
  pstmt.setString(4,"");
  pstmt.setString(5,BUYER);
  pstmt.setString(6,"");
  pstmt.setString(7,"");
  pstmt.setString(8,pjtnDate);
  pstmt.setString(9,"");
  pstmt.setString(10,RDDPT);
  pstmt.setString(11,PROD_CLASS);  
  pstmt.setString(12,REMARK);
  pstmt.setString(13,WEBID);
  pstmt.setString(14,dateStringGet);
  pstmt.setString(15,"");
  pstmt.setString(16,"");
  pstmt.setString(17,"");
  pstmt.setString(18,userID);
  pstmt.setString(19,dateString);
  pstmt.setString(20,MVERSION);
  pstmt.executeUpdate(); 

//2004-10-08  2004-10-20 ADD 上市日期DEFAULT= 20991231 ADD  
  //===INSERT INTO PIMASTER==========================================================      
   String sSqJ = "select SPLATFM_NAME from PRPROD_PLATFORM where PLATFORM_CODE = '"+PLATFORM_CODE+"' ";
   ResultSet rs9=statement.executeQuery(sSqJ);
   if (rs9.next()==true)
   	  SPLATFM_NAME=rs9.getString("SPLATFM_NAME");
// 2004-10-08 -- 2099-12-31 for 上市日期 END
// 2005-02-25 -- -------- for 上市日期 END
// 2005-06-10 -- for BRAND END
  String sqlp="insert into PIMASTER(PROJECTCODE,PRODUCTTYPE,CREATEDBY,CREATEDDATE,DESIGNHOUSE,PLATFORM,LAUNCHDATE,BRAND) values(?,?,?,?,?,?,?,?)";
  pstmt=con.prepareStatement(sqlp);  
  pstmt.setString(1,MODELNO);
  pstmt.setString(2,PROD_CLASS);
  pstmt.setString(3,"MRMODEL");
  pstmt.setString(4,dateStringGet);
  pstmt.setString(5,RDDPT);
  pstmt.setString(6,SPLATFM_NAME);
//  pstmt.setString(7,"20991231");
  pstmt.setString(7,"--------");
  pstmt.setString(8,"--");
  pstmt.executeUpdate(); 
    
  pstmt.close();  

  statement.close();
  rs.close(); 

System.err.println("Step4");


// Start up for upload file by Kerwin

   Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
   stmt.executeUpdate("insert into MRMODEL_DOCMNT(APPNO,MODELNO,SPECFILE,SPECFILE_NAME,IMAGEVIEW,IMAGEVIEW_NAME) values('"+seqnoApp+"','"+MODELNO+"',empty_blob(),'"+frontFile_name+"',empty_blob(),'"+sideFile_name+"')");	
  //inser Binary File To DB    
  if  (!front_file.isMissing() || !side_file.isMissing()) 
  {
    ResultSet rs7=stmt.executeQuery("select SPECFILE,IMAGEVIEW from MRMODEL_DOCMNT where APPNO='"+seqnoApp+"' for UPDATE");  	
    if (rs7.next())
    {
     BLOB myblob=null;
     FileInputStream instream=null;
     OutputStream outstream=null;
     int bufsize=0;
     byte[] buffer =null;
     int fileLength=0;   
     
	 if  (!front_file.isMissing())
	 {
       myblob=((OracleResultSet)rs7).getBLOB(1);
       instream=new FileInputStream(frontFilePath);
       outstream=myblob.getBinaryOutputStream();
       bufsize=myblob.getBufferSize();
       buffer = new byte[bufsize];   
       while ((fileLength=instream.read(buffer))!=-1)   
           outstream.write(buffer,0,fileLength);
       instream.close();	 
       outstream.close();	        	   
	 } //end of frontviewfile if
	   
	 if  (!side_file.isMissing())
	 {
       myblob=((OracleResultSet)rs7).getBLOB(2);
       instream=new FileInputStream(sideFilePath);
       outstream=myblob.getBinaryOutputStream();
       bufsize=myblob.getBufferSize();
       buffer = new byte[bufsize];   
       while ((fileLength=instream.read(buffer))!=-1)   
           outstream.write(buffer,0,fileLength);
       instream.close();	 
       outstream.close();
   	 } //end of sideFileView if
	 
/* 
	 if  (!open_file.isMissing())
	 {
       myblob=((OracleResultSet)rs).getBLOB(3);
       instream=new FileInputStream(openFilePath);
       outstream=myblob.getBinaryOutputStream();
       bufsize=myblob.getBufferSize();
       buffer = new byte[bufsize];   
       while ((fileLength=instream.read(buffer))!=-1)   
           outstream.write(buffer,0,fileLength);
       instream.close();	 
       outstream.close();	   
	 } //end of openViewFile if 
	 
     if  (!back_file.isMissing() )
	 {
       myblob=((OracleResultSet)rs).getBLOB(4);
       instream=new FileInputStream(backFilePath);
       outstream=myblob.getBinaryOutputStream();
       bufsize=myblob.getBufferSize();
       buffer = new byte[bufsize];   
       while ((fileLength=instream.read(buffer))!=-1)   
           outstream.write(buffer,0,fileLength);
       instream.close();	 
       outstream.close();	   
	 } //end of openViewFile if 
*/ 

     out.println("Image file upload success!!<BR>");  	          
    } // end of rs if  
	stmt.close();
    rs7.close();
  } //enf of open_file,front_file,side_file if	


 // End of upload file by Kerwin  

 //執行sendMail動作
  
     out.println("<img src='../jsp/WSMRNewModelSendMail.jsp?APPUSERID="+WEBID+"&APPNO='"+seqnoApp+"' height='0' width='0'>&nbsp;&nbsp;");	

//end of //執行sendMail動作
 
  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
session.setAttribute("DISPLAY","產品編碼 : ");
session.setAttribute("MODELNO",MODELNO);
session.setAttribute("DISPLAYAPPNO","產品編碼申請單號 : ");
session.setAttribute("APPNO",seqnoApp);
response.sendRedirect("WSModelCodeInsShow.jsp");

%>

<br>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
