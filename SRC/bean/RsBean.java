package bean;

//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

public class RsBean implements Serializable {
    ResultSet rs = null;
    String rsString = "";

    public RsBean() {
    }

    public void setRs(ResultSet var1) {
        this.rs = var1;
    }

    public ResultSet getRs() {
        return this.rs;
    }

    public void setRsString(String var1) {
        this.rsString = new String(var1);
    }

    public String getRsString() throws Exception {
        ResultSetMetaData var1 = this.rs.getMetaData();
        int var2 = var1.getColumnCount();
        String[] var3 = new String[var2 + 1];
        StringBuffer var4 = new StringBuffer();
        var4.append("<TABLE BORDER=1>");
        var4.append("<TR>");

        for(int var5 = 1; var5 <= var2; ++var5) {
            var3[var5] = var1.getColumnLabel(var5);
            var4.append("<TD>" + var3[var5] + "</TD>");
        }

        var4.append("</TR>");

        while(this.rs.next()) {
            var4.append("<TR>");

            for(int var6 = 1; var6 <= var2; ++var6) {
                String var7 = this.rs.getString(var6);
                var4.append("<TD>" + var7 + "</TD>");
            }

            var4.append("<TR>");
        }

        var4.append("</TABLE>");
        return var4.toString();
    }
}
