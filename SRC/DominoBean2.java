import java.io.Serializable;
import lotus.domino.*;

public class DominoBean2 implements java.io.Serializable
{
 private String serverName;
 private String userName;
 private String password;
 private String fileName;
 private String filePath;
 private String dbTitle;
 private String dbSize;
 private String commonUserName;
 private String platform;
 private String version;


 public DominoBean2() 
 {}

 public String getServerName() 
 {
    return serverName;
 }

 public String getFileName() 
 {
  return fileName;
 }

 public String getCommonUserName() 
 {
   return commonUserName;
 }

 public String getUserName() 
 {
   return userName;
 }

 public String getPlatform() 
 {
   return platform;
 }

 public String getVersion() 
 {
  return version;
 }

 public String getFilePath() 
 {
   return filePath;
 }

 public String getDbTitle() 
 {
   return dbTitle;
 }

 public String getDbSize() 
 {
  return dbSize;
 }

 public void setServerName(String para)  
 {
   this.serverName = para;
 }


 public void setUserName(String para) 
 {
   this.userName = para;
 }

 public void setPassword(String para) 
 {
   this.password = para;
 }

 public void setFileName(String para) 
 {
   this.fileName = para;
 }

 public void setCommonUserName(String para) 
 {
   this.commonUserName = para;
 }

 public void setPlatform(String para) 
 {
   this.platform = para;
 }

 public void setVersion(String para) 
 {
  this.version = para;
 }

 public void setFilePath(String para) 
 {
   this.filePath = para;
 }

 public void setDbTitle(String para) 
 {
   this.dbTitle = para;
 }

 public void setDbSize(String para) 
 {
  this.dbSize = para;
 }

 public void connectDomino()  
 {       
  try {
	NotesThread.sinitThread();
        Session s = NotesFactory.createSession(serverName,userName,password);            
        Database db = s.getDatabase(s.getServerName(),fileName);
        this.serverName = db.getServer();
        this.fileName = db.getFileName();
        this.filePath = db.getFilePath();
        Double dbl = new Double(db.getSize());
        this.dbSize = dbl.toString();
        this.dbTitle = db.getTitle();
        this.platform = s.getPlatform();
        this.version = s.getNotesVersion();
        this.commonUserName = s.getCommonUserName();      
       } catch (NotesException n) {
            System.out.println("Error: " + n.id);
            n.printStackTrace();
       } catch (Exception e) {
            e.printStackTrace();
       } finally {
            NotesThread.stermThread();
       } 
 }     
} //end of this Bean

