<%
 try
 {
  if (con != null && !con.isClosed()) {
   // 只有在 AutoCommit 為 false 的情況下，才執行 commit
   if (!con.getAutoCommit()) {
    con.commit();
    con.setAutoCommit(true);
   }

   // 將連線釋放回連線池 (oraddspoolBean 來自 ConnectionPoolPage.jsp)
   if (oraddspoolBean != null) {
    oraddspoolBean.releaseConnection(con);
   }
  }
 }
 catch (Exception e)
 {
  out.println("ReleaseConn Error: " + e.getMessage());
 }
%>