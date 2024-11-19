<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.text.*" %>
<%@ page import="javax.xml.parsers.*" %>

<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>

<html>
<head>
<title>XML Parser Test Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM NAME="MYFORM" METHOD="post">
<%
//get a new document builder
DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
DocumentBuilder builder=factory.newDocumentBuilder();

StringBuffer requestURL=HttpUtils.getRequestURL(request);
URL jspURL=new URL(requestURL.toString());
URL url=new URL(jspURL,"../xml/PackingList_Flextronics.xml");
InputSource is=new InputSource(url.openStream());

//load the document
Document document=builder.parse(is);
Element root=document.getDocumentElement();
root.normalize();
String tagName="";

for (Node node=root.getFirstChild();node!=null;node=node.getNextSibling())
{
   if (node.getNodeType()!=Node.ELEMENT_NODE)  //判斷若取到的下一個node已經不是element型態時,則抓下一個element
   {
       continue;
   }	  
   
   Element elm=(Element)node;
   tagName=elm.getTagName();   
   out.println("<BR>"+tagName);
   
   if (elm.getChildNodes().getLength()==1) //如果沒有次元素的話且有值的話,直接印出其內容
   {
     out.println(":<font color=blue>"+elm.getFirstChild().getNodeValue()+"</font>");
   } else {
     //以下為若有次元素的話,則載入其內含資訊
     for (Node elementNode=elm.getFirstChild();elementNode!=null;elementNode=elementNode.getNextSibling())
     {      
        if (elementNode.getNodeType()!=Node.ELEMENT_NODE)
	    {
	      continue;
	    }
	    out.println("<BR>&nbsp;&nbsp;"+elementNode.getNodeName());	  	    
		
		if (elementNode.getChildNodes().getLength()==1) //如果沒有次元素的話且有值的話,直接印出其內容
        {
          out.println(":<font color=blue>"+elementNode.getFirstChild().getNodeValue()+"</font>");
        } else {
		   //因還有再次一層的元素,故繼續解析之
		    for (Node subNode=elementNode.getFirstChild();subNode!=null;subNode=subNode.getNextSibling())
		    {
		         if (subNode.getNodeType()!=Node.ELEMENT_NODE)
	             {
	               continue;
	             }
				 out.println("<BR>&nbsp;&nbsp;&nbsp;&nbsp;"+subNode.getNodeName());	
				 if (subNode.getChildNodes().getLength()==1) //如果沒有次元素的話且有值的話,直接印出其內容
                 {
                   out.println(":<font color=blue>"+subNode.getFirstChild().getNodeValue()+"</font>");
                 }
		    }
		
		} //end of if elementNode.getChildNodes().getLength()==1
		    	  	  	    	  	
     }  //end of for  Node elementNode=elm.getFirstChild();  
   } //end of if elm.getChildNodes().getLength()=1	        
       
}

%>
</FORM>
</body>
</html>
