<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,java.lang.Math.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="java.io.*,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Insert UploadFile into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<A HREF='../OraddsMainMenu.jsp'>首頁</A>&nbsp;&nbsp;<A HREF='../jsp/TSSalesDRQOrderUpfile.jsp'>回上一頁</A><BR>  
<%
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();

String salesAreaNo=mySmartUpload.getRequest().getParameter("SALESAREANO");


//out.println("Step1");
com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
upload_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
String uploadFile_name=upload_file.getFileName();
String uploadFilePath="c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName();
//out.println("Step2");
String seqno=null;
String seqkey=null;
String dateString=null;
String recCenterNo=null;
String agentName=null;

String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間 //
try
{
 if (salesAreaNo=="001" || salesAreaNo.equals("001"))
 {
  if  (!upload_file.isMissing())
  { 
    //out.println("Step3");
    //to get the RMA sequence number
    dateString=dateBean.getYearMonthDay();
    //seqkey="002-001"+dateString;     userAgentNo
	seqkey=salesAreaNo+dateString;  
    Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery("select * from RPDOCSEQ where header='"+seqkey+"'");
  
    if (rs.next()==false)
    {   //out.println("Step4");
     String seqSql="insert into RPDOCSEQ values(?,?)";   
     PreparedStatement seqstmt=con.prepareStatement(seqSql);     
     seqstmt.setString(1,seqkey);
     seqstmt.setInt(2,1);   
	
     seqstmt.executeUpdate();
     seqno=seqkey+"-001";
     seqstmt.close();   
    } else {
     int lastno=rs.getInt("LASTNO");
     lastno++;
     String numberString = Integer.toString(lastno);
     String lastSeqNumber="000"+numberString;
     lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
     seqno=seqkey+"-"+lastSeqNumber;     
   
     String seqSql="update RPDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
     PreparedStatement seqstmt=con.prepareStatement(seqSql);        
     seqstmt.setInt(1,lastno);   
	
     seqstmt.executeUpdate();   
     seqstmt.close(); 
   } //END OF rs.next()  
   rs.close();

    // 先刪除 QCPROD 檔、後新增;相當於作修改        
    try
    { 
              String sqlD="delete from RPADMIN.RPREP_UPFILE where UFILENAME='"+uploadFile_name+"' and TRANSDTIME < '"+strDateTime+"' ";   
              out.println("<font color='#FF9999' size=3><strong>File Upload Success !!!</strong></font>"); 
     
              PreparedStatement seqstmt=con.prepareStatement(sqlD); //out.println("Step1.1.2"); 
              seqstmt.executeUpdate();
              //seqno=seqkey+"-001";
              seqstmt.close();  
    } //end of try
    catch (Exception e)
    {
     out.println("Exception:"+e.getMessage());		  
    }  
//out.println("Step1");
            /*  For Excel View  */         
            // 取得上傳Excel報表
	        InputStream is = new FileInputStream("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
            //InputStream is = new FileInputStream("c://clientupload/QCTrackTest.xls");          	
            //jxl.Workbook wb = Workbook.getWorkbook(is); 
            jxl.Workbook wb = Workbook.getWorkbook(is);     
            //jxl.Workbook wb = Workbook.getWorkbook("c://clientupload/QCTrackTest.xls");    
            //                jxl.Sheet
            //jxl.Sheet sht = wb.getSheet("DBTEL"); 
            jxl.Sheet sht = wb.getSheet(0);
//out.println("Step2<BR>");
    if (sht.getName().substring(0,5)=="DBTEL" || sht.getName().substring(0,5).equals("DBTEL"))
    {      
            String DBFAULT1="";
            String DBSYMPTOM1="";
            String DBFAULT2="";
            String DBSYMPTOM2="";
            String DBFAULT3="";
            String DBSYMPTOM3="";   
            String DBSYMDESC=""; 

            String isTransMitted="N";                 

            int rowCount = sht.getRows();  // 取此次筆數 
            out.println("總共成功上載="+rowCount+"筆資料<BR>");
            out.println("<table width='100%' border='0' cellspacing='1' cellpadding='1'><tr bgcolor='#000099'><td><font size='2' color='#FFFFFF'>&nbsp;</font></td><td><font size='2' color='#FFFFFF'>廠別名稱</font></td><td><font size='2' color='#FFFFFF'>直客名稱</font></td><td><font size='2' color='#FFFFFF'>收件日期</font></td>"+
                         "<td><font size='2' color='#FFFFFF'>完修日期</font></td><td><font size='2' color='#FFFFFF'>廠牌</font></td><td><font size='2' color='#FFFFFF'>機種</font></td>"+
                         "<td><font size='2' color='#FFFFFF'>IMEI</font></td><td><font size='2' color='#FFFFFF'>保固類型</font></td><td><font size='2' color='#FFFFFF'>重修狀態</font></td>"+  
                         "<td><font size='2' color='#FFFFFF'>故障代碼 1</font></td><td><font size='2' color='#FFFFFF'>故障原因 1</font></td><td><font size='2' color='#FFFFFF'>故障代碼 2</font></td>"+
                         "<td><font size='2' color='#FFFFFF'>故障原因 2</font></td><td><font size='2' color='#FFFFFF'>故障代碼 3</font></td><td><font size='2' color='#FFFFFF'>故障原因 3</font></td>"+  
                         "<td><font size='2' color='#FFFFFF'>送修軟體版本</font></td><td><font size='2' color='#FFFFFF'>完修軟體版本</font></td><td><font size='2' color='#FFFFFF'>處理方式</font></td>"+ 
                         "<td><font size='2' color='#FFFFFF'>耗用品名</font></td><td><font size='2' color='#FFFFFF'>處理說明</font></td><td><font size='2' color='#FFFFFF'>完修人員</font></td>"+ 
                         "<td><font size='2' color='#FFFFFF'>單據註記</font></td><td><font size='2' color='#FFFFFF'>五聯單號</font></td></tr>");     
            int i = 1;
			//int j = 0; 
            int lastBase = 0;   
            while (i<rowCount)  
            {  
              out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+i+"</font></td>");               

              jxl.Cell wcDSN = sht.getCell(0, i);    //ws.getWritableCell(int column, int row);  // 讀廠別名稱                                
              String DSN = wcDSN.getContents();  
              //out.println("DSN="+DSN+" ");
              out.print("<td><font size='2'>"+DSN+"</font></td>");
        
              jxl.Cell wcCMRNAME = sht.getCell(1, i);    //ws.getWritableCell(int column, int row);  // 讀直客名稱                                
              String CMRNAME = wcCMRNAME.getContents();  
              //out.println("CMRNAME="+CMRNAME+" ");
              out.print("<td><font size='2'>"+CMRNAME+"</font></td>"); 
   
              jxl.Cell wcRECDATE = sht.getCell(2, i);    //ws.getWritableCell(int column, int row);  // 讀收件日期                                
              String RECDATE = wcRECDATE.getContents(); 
           /*  if (RECDATE.length() != -1)
             { 
              int recDate = Integer.parseInt(RECDATE.substring(0,2))+1911; 
              int recDateIndx = RECDATE.indexOf("/"); 
             }             
           */     
              //out.println("RECDATE="+RECDATE+" ");
             
             if (RECDATE.length() != -1 && RECDATE != null && !RECDATE.equals(""))
             {
              //out.println(RECDATE.substring(0,2));      
              int recDate = Integer.parseInt(RECDATE.substring(0,2))+1911; 
              //out.println(recDate);
              String recDATEGet = Integer.toString(recDate) + RECDATE.substring(3,5) + RECDATE.substring(6,8); 
              //out.println(Integer.toString(recDate));     
              RECDATE = recDATEGet; 
             } 
             
              out.print("<td><font size='2'>"+RECDATE+"</font></td>");    
                    
              jxl.Cell wcFINDATE = sht.getCell(3, i);    //ws.getWritableCell(int column, int row);  // 讀完修日期                                
              String FINDATE = wcFINDATE.getContents();  
              //out.println("FINDATE="+FINDATE+" ");
             if (FINDATE == null || FINDATE.equals("") || FINDATE==" " || FINDATE.equals(" "))         
             {  FINDATE = RECDATE; }   // 若完修日期 等於空白則認定收件日為完修日
    
             if (FINDATE != null && !FINDATE.equals("") && FINDATE.length() != -1 && (FINDATE.substring(0,2)=="93" || FINDATE.substring(0,2).equals("93")) )       
             {
              int finDate = Integer.parseInt(FINDATE.substring(0,2))+1911; 
              String finDATEGet =  Integer.toString(finDate) + FINDATE.substring(3,5) + FINDATE.substring(6,8); 
              FINDATE = finDATEGet;  
             } else if (FINDATE.length()>7) { FINDATE = FINDATE.substring(0,8); }
             
              out.print("<td><font size='2'>"+FINDATE+"</font></td>");   

              jxl.Cell wcBRAND = sht.getCell(4, i);    //ws.getWritableCell(int column, int row);  // 讀廠牌                                
              String BRAND = wcBRAND.getContents();  
              //out.println("BRAND="+BRAND+" ");
              out.print("<td><font size='2'>"+BRAND+"</font></td>");
   
              jxl.Cell wcMODEL = sht.getCell(5, i);    //ws.getWritableCell(int column, int row);  // 讀機種                                
              String MODEL = wcMODEL.getContents();  
              //out.println("MODEL="+MODEL+" "); 
              out.print("<td><font size='2'>"+MODEL+"</font></td>");

              jxl.Cell wcIMEI = sht.getCell(6, i);    //ws.getWritableCell(int column, int row);  // 讀IMEI                                
              String IMEI = wcIMEI.getContents();  
              //out.println("IMEI="+IMEI+" ");
              out.print("<td><font size='2'>"+IMEI+"</font></td>");      
  
              jxl.Cell wcWARRTYPE = sht.getCell(7, i);    //ws.getWritableCell(int column, int row);  // 讀保固類型                                
              String WARRTYPE = wcWARRTYPE.getContents(); 
              if ( WARRTYPE=="保固內" || WARRTYPE.equals("保固內") || WARRTYPE=="新品" || WARRTYPE.equals("新品")) 
              { WARRTYPE = "VALID"; }
              else { WARRTYPE = "INVALID"; }     
              //out.println("WARRTYPE="+WARRTYPE+" ");
              out.print("<td><font size='2'>"+WARRTYPE+"</font></td>"); 
    
              jxl.Cell wcRTNFLAG = sht.getCell(8, i);    //ws.getWritableCell(int column, int row);  // 讀重修狀態                                
              String RTNFLAG = wcRTNFLAG.getContents();  
              //out.println("RTNFLAG="+RTNFLAG+" "); 
              out.print("<td><font size='2'>"+RTNFLAG+"</font></td>");   

              jxl.Cell wcFAULTCODE1 = sht.getCell(9, i);    //ws.getWritableCell(int column, int row);  // 讀故障代碼 1                               
              String FAULTCODE1 = wcFAULTCODE1.getContents();  
              //out.println("FAULTCODE1="+FAULTCODE1+" "); 
              if (Integer.parseInt(FAULTCODE1)<=9) { FAULTCODE1 = "0" + FAULTCODE1;}
              String sqlF1 = "select DBFAULT,DBSYMPTOM,DBSYMDESC from SENAO_FAULTMAP where SEN_FAULT1='"+FAULTCODE1+"' ";                         
              Statement stateF1=con.createStatement();
              ResultSet rsF1=stateF1.executeQuery(sqlF1);  
              if (rsF1.next())  
              {  
                 DBFAULT1 = rsF1.getString("DBFAULT"); 
                 DBSYMPTOM1 = rsF1.getString("DBSYMPTOM"); 
                 DBSYMDESC = rsF1.getString("DBSYMDESC");     
              } 
              rsF1.close();
              stateF1.close(); 
              out.print("<td><font size='2'>"+FAULTCODE1+"</font></td>");       

              jxl.Cell wcFAULTDESC1 = sht.getCell(10, i);    //ws.getWritableCell(int column, int row);  // 讀故障原因 1                               
              String FAULTDESC1 = wcFAULTDESC1.getContents();  
              //out.println("FAULTDESC1="+FAULTDESC1+" ");       
              out.print("<td><font size='2'>"+FAULTDESC1+"</font></td>");       

              jxl.Cell wcFAULTCODE2 = sht.getCell(11, i);    //ws.getWritableCell(int column, int row);  // 讀故障代碼 2                                
              String FAULTCODE2 = wcFAULTCODE2.getContents();  
                
              //out.println("FAULTCODE2="+FAULTCODE2+" ");  
              out.print("<td><font size='2'>"+FAULTCODE2+"</font></td>");

              jxl.Cell wcFAULTDESC2 = sht.getCell(12, i);    //ws.getWritableCell(int column, int row);  // 讀故障原因 2                               
              String FAULTDESC2 = wcFAULTDESC2.getContents();  
              //out.println("FAULTDESC2="+FAULTDESC2+" ");
              if (FAULTCODE2 != null && !FAULTCODE2.equals("") && FAULTCODE2 !="/") 
              { 
                //if (Integer.parseInt(FAULTCODE2)<=9) { FAULTCODE2 = "0" + FAULTCODE2; }                
                String sqlF2 = "select DBFAULT,DBSYMPTOM from SENAO_FAULTMAP where SEN_FAUDESC='"+FAULTDESC2+"' ";                         
                Statement stateF2=con.createStatement();
                ResultSet rsF2=stateF2.executeQuery(sqlF2);  
                if (rsF2.next())  
                {  
                   DBFAULT2 = rsF2.getString("DBFAULT"); 
                   DBSYMPTOM2 = rsF2.getString("DBSYMPTOM");                       
                } 
                rsF2.close();
                stateF2.close();
              }                 
              out.print("<td><font size='2'>"+FAULTDESC2+"</font></td>");
    
               jxl.Cell wcFAULTCODE3 = sht.getCell(13, i);    //ws.getWritableCell(int column, int row);  // 讀故障代碼 3                                
              String FAULTCODE3 = wcFAULTCODE3.getContents(); 
              
              //out.println("FAULTCODE3="+FAULTCODE3+" "); 
              out.print("<td><font size='2'>"+FAULTCODE3+"</font></td>");          

              jxl.Cell wcFAULTDESC3 = sht.getCell(14, i);    //ws.getWritableCell(int column, int row);  // 讀故障原因 3                               
              String FAULTDESC3 = wcFAULTDESC3.getContents();  
              //out.println("FAULTDESC3="+FAULTDESC3+" ");
              if (FAULTCODE3 != null && !FAULTCODE3.equals("")) 
              { 
                //if (Integer.parseInt(FAULTCODE3)<=9) { FAULTCODE3 = "0" + FAULTCODE3; }                
                String sqlF3 = "select DBFAULT,DBSYMPTOM from SENAO_FAULTMAP where SEN_FAUDESC='"+FAULTDESC3+"' ";                         
                Statement stateF3=con.createStatement();
                ResultSet rsF3=stateF3.executeQuery(sqlF3);  
                if (rsF3.next())  
                {  
                   DBFAULT3 = rsF3.getString("DBFAULT"); 
                   DBSYMPTOM3 = rsF3.getString("DBSYMPTOM");                       
                } 
                rsF3.close();
                stateF3.close();
              }            

              out.print("<td><font size='2'>"+FAULTDESC3+"</font></td>");  
      
              jxl.Cell wcSENDSOFTWARE = sht.getCell(15, i);    //ws.getWritableCell(int column, int row);  // 讀送修軟體版本                               
              String SENDSOFTWARE = wcSENDSOFTWARE.getContents();  
              //out.println("SENDSOFTWARE="+SENDSOFTWARE+" ");
              out.print("<td><font size='2'>"+SENDSOFTWARE+"</font></td>");            

              jxl.Cell wcFINSOFTWARE = sht.getCell(16, i);    //ws.getWritableCell(int column, int row);  // 讀完修軟體版本                               
              String FINSOFTWARE = wcFINSOFTWARE.getContents();  
              //out.println("FINSOFTWARE="+FINSOFTWARE+" ");  
              out.print("<td><font size='2'>"+FINSOFTWARE+"</font></td>");         

              jxl.Cell wcRPMETHOD = sht.getCell(17, i);    //ws.getWritableCell(int column, int row);  // 讀處理方式                               
              String RPMETHOD = wcRPMETHOD.getContents();  
              //out.println("RPMETHOD="+RPMETHOD+" ");
              out.print("<td><font size='2'>"+RPMETHOD+"</font></td>");      

              jxl.Cell wcCONSUMEITEM = sht.getCell(19, i);    //ws.getWritableCell(int column, int row);  // 讀耗用品名                               
              String CONSUMEITEM = wcCONSUMEITEM.getContents();  
              //out.println("CONSUMEITEM="+CONSUMEITEM+" ");
              out.print("<td><font size='2'>"+CONSUMEITEM+"</font></td>");         

              jxl.Cell wcRPMETHODDESC = sht.getCell(20, i);    //ws.getWritableCell(int column, int row);  // 讀處理說明                               
              String RPMETHODDESC = wcRPMETHODDESC.getContents();  
              //out.println("RPMETHODDESC="+RPMETHODDESC+" ");
              out.print("<td><font size='2'>"+RPMETHODDESC+"</font></td>");   

              jxl.Cell wcRPPERSON = sht.getCell(21, i);    //ws.getWritableCell(int column, int row);  // 讀完修人員                               
              String RPPERSON = wcRPPERSON.getContents();  
              //out.println("RPPERSON="+RPPERSON+" "); 
              out.print("<td><font size='2'>"+RPPERSON+"</font></td>");       

              jxl.Cell wcREMARK = sht.getCell(22, i);    //ws.getWritableCell(int column, int row);  // 讀單據註記                               
              String REMARK = wcREMARK.getContents();  
              //out.println("REMARK="+REMARK+" ");
              out.print("<td><font size='2'>"+REMARK+"</font></td>");  

              jxl.Cell wcREPNO = sht.getCell(23, i);    //ws.getWritableCell(int column, int row);  // 讀五聯單號                               
              String REPNO = wcREPNO.getContents();  
              //out.println("REPNO="+REPNO+"<BR>");
              out.print("<td><font size='2'>"+REPNO+"</font></td></tr>");   

              i++;                                        

              if (IMEI !=null && !IMEI.equals(""))
			  {
				 String sqlTC =  "insert into RPADMIN.RPREP_UPFILE(IMEI,DSN,CMRNAME,CMRTEL,RECPERSONID,SVRDOCNO,BUYPLACE,BUYDATE,MODEL,COLOR,"+
                                 "JAMDESC1,JAMDESC2,JAMDESC3,WARRTYPE,RECDATE,ZIP,RECITEMNO,REMARK,OTHERJAMDESC,SWAPIMEI,SOFTWAREVER,WORKTIME,"+
                                 "ISTRANSMITTED,ENTRYDATE,ISSWAPIMEI,WARRTYPE2,CSUMITEM,RECCENTERNO,AGENTNO,ISREPLICATE,"+
                                 "DBTEL_FAULT,DBTEL_SYMPT1,DBTEL_SYMPT2,DBTEL_SYMPT3,DBTEL_SYMDESC,TRANSDTIME,SVRTYPENO,RECTYPE,REPLVLNO,UFILENAME,UFILEUSER) "+
                                 "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";   			            
                 PreparedStatement seqstmt=con.prepareStatement(sqlTC); //out.println("Step1.1.2");    
            
                 //seqstmt.setString(1,"886"); out.println("Step1.2");
                 seqstmt.setString(1,IMEI.trim()); //out.println("Step1.2");
                 seqstmt.setString(2,DSN.trim());  // out.println("Step1.3");             
                 seqstmt.setString(3,CMRNAME.trim());
                 seqstmt.setString(4,REPNO.trim()); // 寫五聯單號
                 seqstmt.setString(5,"002"); // RECPERSONID
                 seqstmt.setString(6,seqno); //SVRDOCNO
                 seqstmt.setString(7,"001");  // BUYPLACE
                 seqstmt.setString(8,FINDATE.trim());
                 seqstmt.setString(9,MODEL.trim()); // MODEL
                 seqstmt.setString(10,"N/A"); //COLOR
                 seqstmt.setString(11,FAULTDESC1.trim()); //out.println("Step1.2");
                 seqstmt.setString(12,FAULTDESC2.trim());  // out.println("Step1.3");             
                 seqstmt.setString(13,FAULTDESC3.trim());
				  // 若IMEI已於維修主檔內屬相同IMEI且服務類型為DOA/DAP則表已後送回當成DOA/DAP
                 String sqlF4 = "select count(*) from RPREPAIR where IMEI='"+IMEI+"' and SVRTYPENO in ('002','003') ";                         
                 Statement stateF4=con.createStatement();
                 ResultSet rsF4=stateF4.executeQuery(sqlF4);  
                 if (rsF4.next() && rsF4.getInt(1)>0)   
                 {  WARRTYPE = "新品"; }
                 rsF4.close();                  
				 
                 seqstmt.setString(14,WARRTYPE.trim()); // out.println("Step1.4");
                 seqstmt.setString(15,RECDATE.trim());// out.println("Step1.5");
                 seqstmt.setString(16,"ZIP"); //out.println("Step1.6");
                 seqstmt.setString(17,"001");  // RECITEMNO1
                 seqstmt.setString(18,RPMETHOD.trim());  // RPMETHOD
                 seqstmt.setString(19,RPMETHODDESC.trim()); // // RPMETHODDESC
                 seqstmt.setString(20,""); // SWAPIMEI
                 seqstmt.setString(21,SENDSOFTWARE.trim()); //out.println("Step1.2");
                 seqstmt.setInt(22,0);  // WORKTIME 
				 
                 // 若IMEI已於 維修主檔內屬相同IMEI且收件項目為PCBA則表已後送回三級維修中心
                 sqlF4 = "select count(*) from RPREPAIR where IMEI='"+IMEI+"' and RECITEMNO='008' ";                         
                 rsF4=stateF4.executeQuery(sqlF4);  
                 if (rsF4.next() && rsF4.getInt(1)>0)   
                 {  isTransMitted = "Y"; } else { isTransMitted = "N"; }
                 rsF4.close();
                 stateF4.close();         
				 
                 // 若IMEI已於 維修主檔內屬相同IMEI且收件項目為PCBA則表已後送回三級維修中心  
                 seqstmt.setString(23,isTransMitted); //ISTRANSMITTED
                 seqstmt.setString(24,dateBean.getYearMonthDay()); // ENTRYDATE
                 seqstmt.setString(25,"N");// out.println("Step1.5");
                 seqstmt.setString(26,WARRTYPE.trim()); // WARRTYPE2
                 seqstmt.setString(27,CONSUMEITEM.trim());  // 寫Consume Item
                 seqstmt.setString(28,"010"); //RECCENTERNO
                 seqstmt.setString(29,AgentNo.trim()); //AGENTNO
                 seqstmt.setString(30,"Y"); // DBTEL_FAULT;
                 seqstmt.setString(31,DBFAULT1.trim()); //DBTEL_SYMPT1
                 seqstmt.setString(32,DBSYMPTOM1.trim());  // DBTEL_SYMPT2;             
                 seqstmt.setString(33,DBSYMPTOM2.trim()); //DBTEL_SYMPT2; 
                 seqstmt.setString(34,DBSYMPTOM3.trim()); // DBTEL_SYMPT3; 
                 seqstmt.setString(35,DBSYMDESC.trim());// DBTEL_SYMDESC;
                 seqstmt.setString(36,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //TRANSDTIME;
                 seqstmt.setString(37,"KEY ACC");  // SVRTYPENO
                 seqstmt.setString(38,"005"); //RECTYPE
                 seqstmt.setString(39,"1"); // REPLVLNO 
                 seqstmt.setString(40,uploadFile_name); //out.println("Step1.6");   
                 seqstmt.setString(41,userID);  // out.println("Step1.7");                                
                 seqstmt.executeUpdate();
                 //seqno=seqkey+"-001";
                 seqstmt.close(); 
			 }// End of if      
         /*       

              int getDateIndx = getDate.indexOf("/");
              int getDateIndx2 = getDate.indexOf(";");    
              out.println("getDate="+getDate);	out.println("getDateIndx="+getDateIndx); out.println("getDateIndx2="+getDateIndx2);
              String getMon = "0";
              String getDay = "0";
			  if(getDateIndx>0) { getMon = getDate.substring(0,getDateIndx); }
              if(getDateIndx2>0){ getDay = getDate.substring(getDateIndx+1,getDateIndx2);  } 
              //if (getDateIndx==1)  {  getMon =  getDate.substring(0,) }  
              out.println("getMon="+getMon); out.println("getDay="+getDay); 

              if (Integer.parseInt(getMon) < 10 && Integer.parseInt(getDay) < 10) { getDate = dateBean.getYearString()+"0"+getMon+"0"+getDay; }
              else if (Integer.parseInt(getMon) < 10 && Integer.parseInt(getDay) > 9) { getDate = dateBean.getYearString()+"0"+getMon+getDay; }  
              else if (Integer.parseInt(getMon) > 9 && Integer.parseInt(getDay) < 10) { getDate = dateBean.getYearString()+getMon+"0"+getDay; } 
              else if (Integer.parseInt(getMon) > 9 && Integer.parseInt(getDay) > 9) { getDate = dateBean.getYearString()+getMon+getDay; } 
              out.println("getDate2="+getDate);    		            
                    
              int t = 2;
              int u = 0;  
              while (u<5)
              {
               jxl.Cell wcLine = sht.getCell(1, lastBase+t);    //ws.getWritableCell(int column, int row);  // 讀線別    
               String lineName = wcLine.getContents(); 
               out.println("lineName="+lineName); 
    
               jxl.Cell wcModel = sht.getCell(2, lastBase+t);    //ws.getWritableCell(int column, int row);  // 讀機種    
               String modelName = wcModel.getContents(); 
               out.println("modelName="+modelName);  
 
               int q = 0;       
               while (q < 3)
               {
                jxl.Cell wcStatName = sht.getCell(3, lastBase+t+q);    //ws.getWritableCell(int column, int row);  // 讀站名1    
                String statName = wcStatName.getContents(); 
                out.println("statName="+statName);                           

                jxl.Cell wcDefQty = sht.getCell(4, lastBase+t+q);    //ws.getWritableCell(int column, int row);  // 讀不良數    
                String DefQty = wcDefQty.getContents(); 
                out.println("DefQty="+DefQty);  

                int DefQtyLength = 0; 
				float DefQtyFlt = 0;
				if (DefQty!=null && DefQty!="")
				{
				  //DefQtyLength = DefQty.length();
				  //DefQty = DefQty.substring(0,DefQtyLength-1);
				  DefQtyFlt = Float.parseFloat(DefQty);
				}
                
                jxl.Cell wcDefRate = sht.getCell(5, lastBase+t+q);    //ws.getWritableCell(int column, int row);  // 讀不良率    
                String DefRate = wcDefRate.getContents(); 
                out.println("DefRate="+DefRate); 

                int DefRateLength = 0; 
				float DefRateFlt = 0;
				if (DefRate!=null && DefRate!="")
				{ 
				  DefRateLength = DefRate.length();
				  DefRate = DefRate.substring(0,DefRateLength-1);
				  DefRateFlt = Float.parseFloat(DefRate);
				} 

                jxl.Cell wcDefSts = sht.getCell(6, lastBase+t+q);    //ws.getWritableCell(int column, int row);  // 讀不良現象    
                String DefSts = wcDefSts.getContents(); 
                out.println("DefSts="+DefSts); 

                jxl.Cell wcDefResn = sht.getCell(7, lastBase+t+q);    //ws.getWritableCell(int column, int row);  // 讀原因分析    
                String DefResn = wcDefResn.getContents(); 
                out.println("DefResn="+DefResn);  
                
                int DefResnLngth = DefResn.length();
                if (DefResnLngth>=300) { DefResn = DefResn.substring(0,299); }
                else { DefResn = DefResn.substring(0,DefResnLngth); }  
    
                jxl.Cell wcDefWay = sht.getCell(8, lastBase+t+q);    //ws.getWritableCell(int column, int row);  // 讀改善對策    
                String DefWay = wcDefWay.getContents(); 
                out.println("DefWay="+DefWay);
               
                int DefWayLngth = DefWay.length();
                if (DefWayLngth>=500) { DefWay = DefWay.substring(0,499); }
                else { DefWay = DefWay.substring(0,DefWayLngth); }  

                jxl.Cell wcPerson = sht.getCell(9, lastBase+t+q);    //ws.getWritableCell(int column, int row);  // 讀負責人    
                String Person = wcPerson.getContents(); 
                out.println("Person="+Person);

                jxl.Cell wcConFirm = sht.getCell(10, lastBase+t+q);    //ws.getWritableCell(int column, int row);  // 讀狀態    
                String ConFirm = wcConFirm.getContents(); 
                out.println("ConFirm="+ConFirm+"<BR>");                         

                q++;  
        
                if (modelName !=null && modelName != "" && DefQty!=null && DefQty!="0")
				{
				 String sqlTC =  "insert into DMADMIN.QCPROD(MODELNO,LINENUM,STANUM,GENDATE,NGQTY,DRATE,NGPHE,NGREA,NGWAY,NGPER,SDATE,ADATE,STAT) "+
                                 "values(?,?,?,?,?,?,?,?,?,?,?,?,?)";   			            
                 PreparedStatement seqstmt=dmcon.prepareStatement(sqlTC); //out.println("Step1.1.2");    
            
                 //seqstmt.setString(1,"886"); out.println("Step1.2");
                 seqstmt.setString(1,modelName); //out.println("Step1.2");
                 seqstmt.setString(2,lineName);  // out.println("Step1.3");             
                 seqstmt.setString(3,statName);
                 seqstmt.setString(4,getDate); // out.println("Step1.4");
                 seqstmt.setFloat(5,DefQtyFlt);// out.println("Step1.5");
                 seqstmt.setFloat(6,DefRateFlt); //out.println("Step1.6");
                 seqstmt.setString(7,DefSts);  // out.println("Step1.7");
                 seqstmt.setString(8,DefResn);
                 seqstmt.setString(9,DefWay); // out.println("Step1.8"); 
                 seqstmt.setString(10,Person); //out.println("Step1.6");
                 seqstmt.setString(11,"");  // out.println("Step1.7");
                 seqstmt.setString(12,"");
                 seqstmt.setString(13,ConFirm); // out.println("Step1.8");               
                 seqstmt.executeUpdate();
                 //seqno=seqkey+"-001";
                 seqstmt.close(); 
				}// End of if           
                     
               }   // End of While for  (q < 3)                 
   
               u++;
               t = 3*u+2;
                     
               //if ( i==1 && u==4) {  lastBase = t-1;  out.println("<font color='#FF0099'>"+"lastBase="+lastBase+"</font>");}   
               //else if (i>1 && u==5) {  lastBase = lastBase + (t-1); out.println("<font color='#FF0099'>"+"lastBase="+lastBase+"</font>");} 
               if (i>0 && u==5) {  lastBase = lastBase + (t-1); out.println("<font color='#FF0099'>"+"lastBase="+lastBase+"</font>");}                       
            } // End of While for  (u<5)    
		
		    
		   j=i*(15 + 1); 
           i++;  	
         */	   
		}   // End of While (i<rowCount)
        out.println("</table>"); 
        wb.close(); 
                           
    }  // End of If (sht.getName().substring(1,5)=="DBTEL" || sht.getName().substring(1,5).equals("DBTEL"))
  } else {
    out.println("The file has been missing!! Please try it again!!<BR>"); 
  } // End of if filemissing 
 }
 else {  out.println("There is not exist other specification file except SENAO KEY ACCOUNT !!<BR>");   }  // End of AgentNo == "002-999"
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch

%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->

