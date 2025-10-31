package bean;

import java.io.Serializable;

public class ArrayCheckBox2DBean implements Serializable {
    private String fieldName = "";
    private String[] arrayString;
    private String[][] array2DString;
    private String selection = "";

    public ArrayCheckBox2DBean() {
    }

    public String getSelection() {
        return this.selection;
    }

    public void setSelection(String var1) {
        this.selection = var1;
    }

    public String getFieldName() {
        return this.fieldName;
    }

    public void setFieldName(String var1) {
        this.fieldName = var1;
    }

    public String[] getArrayContent() {
        return this.arrayString;
    }

    public String[][] getArray2DContent() {
        return this.array2DString;
    }

    public void setArrayString(String[] var1) {
        this.arrayString = var1;
    }

    public void setArray2DString(String[][] var1) {
        this.array2DString = var1;
    }

    public String getArrayString() throws Exception {
        StringBuffer var1 = new StringBuffer();
        boolean var2 = true;
        var1.append("<TABLE>");

        for(int var3 = 0; var3 < this.arrayString.length; ++var3) {
            String var4 = this.arrayString[var3];
            var1.append("<TR BGCOLOR=E3E3CF>");
            if (var4.equals(this.selection)) {
                var1.append("<TD><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + var4 + "' CHECKED></TD><TD><FONT SIZE=1>" + var4 + "</TD>");
            } else {
                var1.append("<TD><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + var4 + "'></TD><TD><FONT SIZE=1>" + var4 + "</TD>");
            }

            var1.append("</TR>");
        }

        var1.append("</TABLE>");
        this.selection = "";
        return var1.toString();
    }

    public String getArray2DString() throws Exception {
        StringBuffer var1 = new StringBuffer();
        boolean var2 = true;
        boolean var3 = true;
        var1.append("<TABLE>");

        for(int var4 = 0; var4 < this.array2DString.length; ++var4) {
            var1.append("<TR BGCOLOR=E3E3CF>");
            String var5 = this.array2DString[var4][0];
            if (var5.equals(this.selection)) {
                var1.append("<TD><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + var5 + "' CHECKED></TD><TD><FONT SIZE=1>" + var5 + "</TD>");
            } else {
                var1.append("<TD><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + var5 + "'></TD><TD><FONT SIZE=1>" + var5 + "</TD>");
            }

            for(int var6 = 1; var6 < this.array2DString[var4].length; ++var6) {
                String var7 = this.array2DString[var4][var6];
                var1.append("<TD><FONT SIZE=1>" + var7 + "</TD>");
            }

            var1.append("</TR>");
        }

        var1.append("</TABLE>");
        this.selection = "";
        return var1.toString();
    }
}
