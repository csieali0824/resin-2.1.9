<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.sql.*,com.lowagie.text.Document,com.lowagie.text.DocumentException,com.lowagie.text.Paragraph,com.lowagie.text.rtf.RtfWriter2"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Java RTF Generator</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
</head>
<body>
<%
      //System.out.println("Hello World example in RTF");

      // step 1: creation of a document-object
	  
	  try {
          com.lowagie.text.Document document = new com.lowagie.text.Document();
      // step 2:
            // we create a writer that listens to the document
            // and directs a RTF-stream to a file
            
            com.lowagie.text.rtf.RtfWriter2.getInstance(document, new FileOutputStream("HelloWorld.rtf"));
						
            // step 3: we open the document
			document.open();
			// step 4: we add a paragraph to the document
			document.add(new Paragraph("Hello World"));
			document.add(new Paragraph("This is Java(JSP) Generate RTF File Test !!!"));

		  } catch (DocumentException de) {
			      System.err.println(de.getMessage());
		  } catch (IOException ioe) {
			      System.err.println(ioe.getMessage());
	      }
          // step 5: we close the document
		  document.close();

%>
<!--=============以下區段為釋放連結池==========--> 
<!--%@ include file="/jsp/include/ReleaseConnPage.jsp"%-->
<!--=================================-->
</body>
</html>
