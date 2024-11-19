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
<%//@ include file="/jsp/include/ConnBPCSMicroPoolPage.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="BpcsMisAssest.jsp" METHOD="post" NAME="MYFORM"><%
/*dateBean.setAdjDate(-1);
String sDate=dateBean.getMonthString()+dateBean.getDayString()+dateBean.getYearString(); 
String sGFilename=sDate+".txt"; 
out.println(sGFilename); 

File url1= new File("I://Tw9900//TEXTLOG//"+sGFilename);

//File url2= new File("d:/ftp/DBTEL_Daily_Tmp.txt");
File url2= new File("D://resin-2.1.9/webapps/wins/ftp/DBTEL_Daily_Tmp.txt");
jCopy.copyFile(url1,url2); */


        String inputFileName  = "D://resin-2.1.9/webapps/wins/ftp/asset.txt";
        int       insertResults = 0;      
		
        
       try
	    {

            Statement stmt = bpcscon.createStatement ();
            FileReader inputFileReader = new FileReader(inputFileName);
            BufferedReader inputStream   = new BufferedReader(inputFileReader);
	         String inLine = null;
            while ((inLine = inputStream.readLine()) != null )			 
			{   			
				 //out.println(inLine);              
				String dbtelsSql="INSERT INTO  misasset VALUES ('"+inLine+"')"; 
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
      <td width="20%"><div align="center"><font color="#0000FF" size="2">財產編號 
          </font></div></td>
      <td width="18%"><div align="center"><font color="#0000FF" size="2">資產序號</font></div></td>
      <td width="21%"><div align="center"><font color="#0000FF" size="2">改良序號</font></div></td>
      <td width="17%"><div align="center"><font color="#0000FF" size="2">購買日期 
          </font></div></td>
      <td width="14%"><div align="center"><font color="#0000FF" size="2">購買金額 
          </font></div></td>
      <td width="10%"><div align="center"><font color="#0000FF" size="2">殘值</font></div></td>
    </tr>
    <%
try
 {       
  Statement statement=bpcscon.createStatement();
  String sSql="select distinct ASTNO from misasset order by astno "; 
  //out.println(sSql); 
  ResultSet rs=statement.executeQuery(sSql);
  
   while (rs.next())
  {  
   Statement stmt=bpcscon.createStatement();  
   String assetSql="select  ASTNO,ASTSEQ,IMPSEQ,USEDATE,ORGPRICE,ORGPRICE-FINADEPR  as  SURPLUS from asset where astno='"+rs.getString("ASTNO")+"' order by usedate ";  
   ResultSet rsTC=stmt.executeQuery(assetSql); 
   //out.println(assetSql); 
    while (rsTC.next())
   {  
  %>
    <tr bgcolor="#FFFFCC"> 
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("ASTNO")!=null ) { out.println(rsTC.getString("ASTNO")); } 
                      else { out.println("&nbsp;"); }
          %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("ASTSEQ")!=null ) { out.println(rsTC.getString("ASTSEQ")); } 
                      else { out.println("&nbsp;"); }
          %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("IMPSEQ")!=null ) { out.println(rsTC.getString("IMPSEQ")); } 
                      else { out.println("&nbsp;"); }
          %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("USEDATE")!=null ) { out.println(rsTC.getString("USEDATE")); } 
                      else { out.println("&nbsp;"); }
          %>
        </font></td>
      <td><div align="right"><font size="2" color="#000099"> 
          <% 
                      if (rsTC.getString("ORGPRICE")!=null ) { out.println(rsTC.getString("ORGPRICE")); } 
                      else { out.println("&nbsp;"); }
          %>
          </font></div></td>
      <td><div align="right"><font size="2" color="#000099"> 
          <% 
                      if (rsTC.getString("SURPLUS")!=null ) { out.println(rsTC.getString("SURPLUS")); } 
                      else { out.println("&nbsp;"); }
          %>
          </font></div></td>
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
<%//@ include file="/jsp/include/ReleaseConnBPCSMicroPage.jsp"%>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%//@ include file="/jsp/include/ReleaseConnPage.jsp"%>
