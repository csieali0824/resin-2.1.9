import java.io.Serializable;
import lotus.domino.*;

public class DominoPoolBean implements java.io.Serializable
{
 private String serverName=null;
 private String secondaryServerName=null;
 private String userName;
 private String password; 
 private String commonUserName;
 private String platform;
 private String version; 
 private String token=null;  
 private Session s=null;


 public DominoPoolBean() 
 {} 
 
 public Session getSession() 
 {
    return s;
 } 

 public boolean isSessionAlive()//判斷Notes/Domino的session是否仍存在
 {
   try
   {
      DateTime dt=s.createDateTime("2000/01/01"); //2000/01/01僅代表測試用日期,無其他意義              	 
      return true;     
   }
   catch (Exception e)
   {      	
      e.printStackTrace();        
      return false; 	
   }    	 	    
 } 

 public String getServerName() 
 {
    return serverName;
 }  
 
 public String getSecondaryServerName() 
 {
    return secondaryServerName;
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
 
 public String getToken() 
 {
  return token;
 } 
 
 public void setToken(String para) 
 {
  this.token = para;
 } 

 public void setServerName(String para)  
 {
   this.serverName = para;
 }
 
 public void setSecondaryServerName(String para)  
 {
   this.secondaryServerName = para;
 }

 public void setUserName(String para) 
 {
   this.userName = para;
 }

 public void setPassword(String para) 
 {
   this.password = para;
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

 public synchronized Session connectDomino()  
 {                
      try 
      {	
        this.s = NotesFactory.createSession(serverName,userName,password);                  
        setPlatform(s.getPlatform());
        setVersion(s.getNotesVersion());
        setCommonUserName(s.getCommonUserName());        
        setToken(s.getSessionToken());//若有設定SSO,則取得其TOKEN         
        System.out.println(this.commonUserName+" has been authenticated succefully by Domino");                          
       } catch (NotesException n) {
       	    if (n.id==4457 || n.id==4062) //4457 means Connection Error,4062 means CORBA Error Connection Refuse
       	    {
       	      try 
              {		
       	        this.s = NotesFactory.createSession(secondaryServerName,userName,password);                  
                setPlatform(s.getPlatform());
                setVersion(s.getNotesVersion());
                setCommonUserName(s.getCommonUserName());
                setToken(s.getSessionToken());//若有設定SSO,則取得其TOKEN        	      	
       	        System.err.println("Alert!!The Primary Domino Server is error , now switching to secondary!");
       	        System.out.println(this.commonUserName+" has been authenticated succefully by Domino");
       	      } catch (NotesException nn) {
       	      	 System.out.println("Error: " + nn.id+",can't login to Domino Sever for Authentication by <"+userName+">");
       	      } catch (Exception ee) {
                    ee.printStackTrace();
              }  	  
       	    } else {	
               System.out.println("Error: " + n.id+",can't login to Domino Sever for Authentication by <"+userName+">");
            }   
              //n.printStackTrace();
       } catch (Exception e) {
            e.printStackTrace();
       }          
        
  return s;
 } //end of connectDomino
 
 public synchronized Session connectDominoByToken(String checkToken)  
 {                 
      try 
      {	
        this.s = NotesFactory.createSession(serverName,checkToken);                  
        setPlatform(s.getPlatform());
        setVersion(s.getNotesVersion());
        setCommonUserName(s.getCommonUserName()); 
        setToken(s.getSessionToken());//若有設定SSO,則取得其TOKEN               
        //setToken(null);
        System.out.println(getCommonUserName()+" has been login through SSO");                                
       } catch (NotesException n) {
       	    if (n.id==4457 || n.id==4062) //4457 means Connection Error,4062 means CORBA Error Connection Refuse
       	    {
       	      try 
              {	 	
       	         this.s = NotesFactory.createSession(secondaryServerName,checkToken);                  
                 setPlatform(s.getPlatform());
                 setVersion(s.getNotesVersion());
                 setCommonUserName(s.getCommonUserName());         
                 setToken(s.getSessionToken());//若有設定SSO,則取得其TOKEN                     
                 //setToken(null);	      	
       	         System.err.println("Alert!!The Primary Domino Server is error , now switching to secondary!");
       	         System.out.println(getCommonUserName()+" has been login through SSO");
       	      } catch (NotesException nn) {
       	      	 System.out.println("Error: " + nn.id+",can't login to Domino Sever for Authentication by <"+getCommonUserName()+">");
       	      } catch (Exception ee) {
                    ee.printStackTrace();
              }     
       	    } else {	
              System.out.println("Error: " + n.id+",can't login to Domino Sever for Authentication by <"+getCommonUserName()+">");
            }  
            //n.printStackTrace();
       } catch (Exception e) {
            e.printStackTrace();
       }          
        
  return s;
 } //end of connectDomino by token 
 
 
 public void setDisconnect() 
 {      
   try 
   {	
      this.s.recycle();//中斷與notes之session ;                         
   } catch (NotesException n) {
            System.out.println("Error: " + n.id+",can't disconnect with Domino Sever!!!");
            //n.printStackTrace();
   } catch (Exception e) {
            e.printStackTrace();
   }        
 } //end of setDisconnect
} //end of this Bean

