package bean;

import lotus.domino.*;

public class CorbaApp implements Runnable
{
        // N&A Server record -
        // Net Address for TCPIP Port (or IP address)
    String host      = null;
    String dbName    = null;
    // N&A Person record ¡X Short name and/or Internet address
    String userName = "";
    // N&A Person record ¡X Internet password
    String password = "";

    public CorbaApp(String argv[])
    {
        host                           = argv[0];
        if (argv.length >= 2) dbName   = argv[1];
        if (argv.length >= 3) userName = argv[2];
        if (argv.length >= 4) password = argv[3];
    }

    public static void main(String argv[])
    {
        if(argv.length < 1)
        {
            System.out.println("ERROR: You must supply server TCPIP Net (or IP) Address.");
            return;
        }
        if(argv.length < 2)
        {
         System.out.println("ERROR: You must supply database filename.");
            return;
        }
        CorbaApp CA = new CorbaApp(argv);
        Thread nt = new Thread((Runnable)CA);
        nt.start();
    }

    public void run()
    {
    try
    {
     Session s = NotesFactory.createSession(host, userName, password);
     Name serverName = s.createName(s.getServerName());
     System.out.print("Connected to server "+serverName.getAbbreviated() + " as ");
     System.out.println(s.getCommonUserName());
     Database db = s.getDatabase(s.getServerName(), dbName);
     System.out.print  ("Title of database " + db.getFilePath() + " is ");
     System.out.println(db.getTitle());
    }
    catch (NotesException e)
    {
     System.err.println
      (e.getClass().getName() + ": " + e.text);
     e.printStackTrace();
    }
    }
}
