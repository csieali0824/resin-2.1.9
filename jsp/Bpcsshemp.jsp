<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="java.io.*,DateBean,JCopy" %>
<!--=============以下區段為取得連結池==========-->
<%//@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title>Insert UploadFile into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="jCopy" scope="page" class="JCopy"/>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="Bpcsshemp.jsp" METHOD="post" NAME="MYFORM"><%
/*dateBean.setAdjDate(-1);
String sDate=dateBean.getMonthString()+dateBean.getDayString()+dateBean.getYearString(); 
String sGFilename=sDate+".txt"; 
out.println(sGFilename); 

File url1= new File("I://Tw9900//TEXTLOG//"+sGFilename);

//File url2= new File("d:/ftp/DBTEL_Daily_Tmp.txt");
File url2= new File("D://resin-2.1.9/webapps/wins/ftp/DBTEL_Daily_Tmp.txt");
jCopy.copyFile(url1,url2); */


        String inputFileName  = "D://resin-2.1.9/webapps/wins/ftp/shhemp.txt";
        int       insertResults = 0;      
		
        
       try
	    {

            Statement stmt = ifxTestCon.createStatement ();
            FileReader inputFileReader = new FileReader(inputFileName);
            BufferedReader inputStream   = new BufferedReader(inputFileReader);
	         String inLine = null;
            while ((inLine = inputStream.readLine()) != null )			 
			{   			
				 //out.println(inLine);              
				String dbtelsSql="INSERT INTO  empno VALUES ('"+inLine+"')"; 
                insertResults = stmt.executeUpdate(dbtelsSql);
              
			   }
              
            inputStream.close();
            stmt.close();
            
           }	// end try
	      catch (Exception e)
	      {
		     out.println("Exception:"+e.getMessage());				
	       }   
%>
  <table width="50%"  border="1" >
    <tr bgcolor="#FFCCFF"> 
      <td width="20%"><div align="center"><font color="#0000FF" size="2">工號 </font></div></td>
      <td width="18%"><div align="center"><font color="#0000FF" size="2">姓名</font></div></td>
      <td width="21%"><div align="center"><font color="#0000FF" size="2">部門</font></div></td>
      <td width="17%"><div align="center"><font color="#0000FF" size="2">在職狀態</font></div></td>
    </tr>
    <%
try
 {       
  Statement statement=ifxTestCon.createStatement();
  String sSql="select distinct emp_no from empno "; 
  //out.println(sSql); 
  ResultSet rs=statement.executeQuery(sSql);
  
   while (rs.next())
  {  
   Statement stmt=bpcscon.createStatement();  
   String assetSql="select  EMPLOYECD,CHINESENAME,CODENAME,trim(JOBSTATUS) as JOBSTATUS from employee where trim(EMPLOYECD)='"+rs.getString("emp_no")+"'  and COMPANYCD='01' order by 1";  
   ResultSet rsTC=stmt.executeQuery(assetSql); 
   //out.println(assetSql); 
    while (rsTC.next())
   {  
  %>
    <tr bgcolor="#FFFFCC"> 
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("EMPLOYECD")!=null ) { out.println(rsTC.getString("EMPLOYECD")); } 
                      else { out.println("&nbsp;"); }
          %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("CHINESENAME")!=null ) { out.println(rsTC.getString("CHINESENAME")); } 
                      else { out.println("&nbsp;"); }
          %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("CODENAME")!=null ) { out.println(rsTC.getString("CODENAME")); } 
                      else { out.println("&nbsp;"); }
          %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("JOBSTATUS")!=null ) { out.println(rsTC.getString("JOBSTATUS")); } 
                      else { out.println("&nbsp;"); }
          %>
        <%        String jobststus=rsTC.getString("JOBSTATUS"); 
                      if (jobststus!=null ) 
					   { if (jobststus.equals("EMIO2") || jobststus.equals("EMI10") )
					       { out.println("*"); }
						  else { out.println("&nbsp;"); }						   
						} 
                      else { out.println("&nbsp;"); }
          %>
        </font></td>
    </tr>
    <%
   }
	      rsTC.close();
	      stmt.close();
  }
	      rs.close();
	      statement.close();
 }	// end try
	      catch (Exception e)
	      {
		     out.println("Exception:"+e.getMessage());				
	       } 


%>
  </table>
  
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%//@ include file="/jsp/include/ReleaseConnPage.jsp"%>
