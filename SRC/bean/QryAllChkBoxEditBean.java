package bean;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

public class QryAllChkBoxEditBean implements Serializable {
    ResultSet rs = null;
    ResultSet rsPO = null;
    private String[] headerArray;
    private String fieldName = "";
    private String rsString = "";
    private String searchKey = "";
    private String[] searchKeyArray;
    private String tableWrapAttr = "";
    private String tdTipCh = "";
    private String tdMouseMoveAttr = "";
    private String pageURL = "";
    private String pageURL2 = "";
    private int scrollRowNumber = 0;
    int rowNumber = 0;
    private String rowColor1 = "";
    private String rowColor2 = "";
    private String headColor = null;
    private String headFontColor = null;
    private int subSearchStrIndx = 0;
    private String hideURL = "";
    private String onClickJS = "";
    private int[] keyColumn;
    private String onSortingJS = "";
    private boolean colSortingFlag = false;
    private String colSorting = "";
    private String colSortingType = "";

    public QryAllChkBoxEditBean() {
    }

    public void setHeaderArray(String[] var1) {
        this.headerArray = var1;
    }

    public String getHeadColor() {
        return this.headColor;
    }

    public void setHeadColor(String var1) {
        this.headColor = var1;
    }

    public String getHeadFontColor() {
        return this.headFontColor;
    }

    public void setHeadFontColor(String var1) {
        this.headFontColor = var1;
    }

    public String getRowColor1() {
        return this.rowColor1;
    }

    public void setRowColor1(String var1) {
        this.rowColor1 = var1;
    }

    public String getRowColor2() {
        return this.rowColor2;
    }

    public void setRowColor2(String var1) {
        this.rowColor2 = var1;
    }

    public int getScrollRowNumber() {
        return this.scrollRowNumber;
    }

    public void setScrollRowNumber(int var1) {
        this.scrollRowNumber = var1;
    }

    public int getRowNumber() {
        return this.rowNumber;
    }

    public void setRowNumber(int var1) {
        this.rowNumber = var1;
    }

    public String getPageURL() {
        return this.pageURL;
    }

    public void setPageURL(String var1) {
        this.pageURL = var1;
    }

    public String getPageURL2() {
        return this.pageURL2;
    }

    public void setPageURL2(String var1) {
        this.pageURL2 = var1;
    }

    public String getSearchKey() {
        return this.searchKey;
    }

    public void setSearchKey(String var1) {
        this.searchKey = var1;
    }

    public String[] getSearchKeyArray() {
        return this.searchKeyArray;
    }

    public void setSearchKeyArray(String[] var1) {
        this.searchKeyArray = var1;
    }

    public String getFieldName() {
        return this.fieldName;
    }

    public void setFieldName(String var1) {
        this.fieldName = var1;
    }

    public void setRs(ResultSet var1) {
        this.rs = var1;
    }

    public void setRsPO(ResultSet var1) {
        this.rsPO = var1;
    }

    public ResultSet getRs() {
        return this.rs;
    }

    public ResultSet getRsPO() {
        return this.rsPO;
    }

    public void setRsString(String var1) {
        this.rsString = new String(var1);
    }

    public int getSubSearchStrIndx() {
        return this.subSearchStrIndx;
    }

    public void setSubSearchStrIndx(int var1) {
        this.subSearchStrIndx = var1;
    }

    public String getTableWrapAttr() {
        return this.tableWrapAttr;
    }

    public void setTableWrapAttr(String var1) {
        this.tableWrapAttr = var1;
    }

    public String getTDMouseMoveAttr() {
        return this.tdMouseMoveAttr;
    }

    public void setTDMouseMoveAttr(String var1) {
        this.tdMouseMoveAttr = var1;
    }

    public String getTDTipCh() {
        return this.tdTipCh;
    }

    public void setTDTipCh(String var1) {
        this.tdTipCh = var1;
    }

    public String getHideURL() {
        return this.hideURL;
    }

    public void setHideURL(String var1) {
        this.hideURL = var1;
    }

    public String getOnClickJS() {
        return this.onClickJS;
    }

    public void setOnClickJS(String var1) {
        this.onClickJS = var1;
    }

    public void setKeyColumn(int[] var1) {
        this.keyColumn = var1;
    }

    public int[] getKeyColumn() {
        return this.keyColumn;
    }

    public String getOnSortingJS() {
        return this.onSortingJS;
    }

    public void setOnSortingJS(String var1) {
        this.onSortingJS = var1;
    }

    public boolean getColSortingFlag() {
        return this.colSortingFlag;
    }

    public void setColSortingFlag(boolean var1) {
        this.colSortingFlag = var1;
    }

    public String getColSorting() {
        return this.colSorting;
    }

    public void setColSorting(String var1) {
        this.colSorting = var1;
    }

    public String getColSortingType() {
        return this.colSortingType;
    }

    public void setColSortingType(String var1) {
        this.colSortingType = var1;
    }

    public String getRsString() throws Exception {
        ResultSetMetaData var1 = this.rs.getMetaData();
        int var2 = var1.getColumnCount();
        String[] var3 = new String[var2 + 1];
        StringBuffer var4 = new StringBuffer();
        String var5 = "";
        String var6 = "BLACK";
        if (this.headColor != null) {
            var6 = this.headColor;
        }

        String var7 = "WHITE";
        if (this.headFontColor != null) {
            var7 = this.headFontColor;
        }

        if (this.tableWrapAttr != null && !this.tableWrapAttr.equals("")) {
            this.tableWrapAttr = "nowrap";
        }

        if (this.rowColor1.equals("")) {
            var5 = "E3E3CF";
        } else {
            var5 = this.rowColor1;
        }

        var4.append("<TABLE cellSpacing='1' bordercolordark='#99CC99' cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='0'>");
        var4.append("<TR>");
        int var8;
        String var9;
        if (this.headerArray != null && this.headerArray.length > 0) {
            for(var8 = 0; var8 < this.headerArray.length; ++var8) {
                var9 = this.headerArray[var8];
                var4.append("<TH BGCOLOR='" + var6 + "'><FONT COLOR='" + var7 + "' SIZE=2>" + var9 + "</FONT></TH>");
            }
        } else {
            var4.append("<TH BGCOLOR='" + var6 + "'><FONT COLOR='" + var7 + "' SIZE=2>&nbsp;</FONT></TH><TH BGCOLOR='" + var6 + "'><FONT COLOR='" + var7 + "' SIZE=2>&nbsp;</FONT></TH>");
            if (!this.pageURL2.equals("")) {
                var4.append("<TH BGCOLOR='" + var6 + "'><FONT COLOR='" + var7 + "' SIZE=2>&nbsp;</FONT></TH>");
            }

            for(var8 = 1; var8 <= var2; ++var8) {
                var3[var8] = var1.getColumnLabel(var8);
                if (this.colSortingFlag) {
                    if (("" + var8).equals(this.colSorting)) {
                        if (this.colSortingType.equals("DESC")) {
                            var4.append("<TH BGCOLOR='" + var6 + "' " + this.tableWrapAttr + "><FONT COLOR='" + var7 + "' SIZE=2 FACE='ARIAL'>" + var3[var8] + "</FONT><a href='javascript:void(0)' onClick='" + this.onSortingJS + "(" + '"' + var8 + '"' + "," + '"' + "ASC" + '"' + ")'><img src='../image/sort_desc.png' width='15' height='15' border='0'></a></TH>");
                        } else {
                            var4.append("<TH BGCOLOR='" + var6 + "' " + this.tableWrapAttr + "><FONT COLOR='" + var7 + "' SIZE=2 FACE='ARIAL'>" + var3[var8] + "</FONT><a href='javascript:void(0)' onClick='" + this.onSortingJS + "(" + '"' + var8 + '"' + "," + '"' + "DESC" + '"' + ")'><img src='../image/sort_asc.png' width='15' height='15' border='0'></a></TH>");
                        }
                    } else {
                        var4.append("<TH BGCOLOR='" + var6 + "' " + this.tableWrapAttr + "><FONT COLOR='" + var7 + "' SIZE=2 FACE='ARIAL'>" + var3[var8] + "</FONT><a href='javascript:void(0)' onClick='" + this.onSortingJS + "(" + '"' + var8 + '"' + "," + '"' + "DESC" + '"' + ")'><img src='../image/sort_asc.png' width='15' height='15' border='0'></a></TH>");
                    }
                } else {
                    var4.append("<TH BGCOLOR='" + var6 + "' " + this.tableWrapAttr + "><FONT COLOR='" + var7 + "' SIZE=2 FACE='ARIAL'>" + var3[var8] + "</FONT></TH>");
                }
            }
        }

        var4.append("</TR>");
        var8 = 0;
        var9 = "";
        String var10 = "";

        while(this.rs.next() && (var8 != this.scrollRowNumber || this.scrollRowNumber <= 0)) {
            ++var8;
            var9 = "";
            int var11;
            int var12;
            if (this.searchKeyArray != null && this.searchKeyArray.length >= 1) {
                for(var11 = 0; var11 < this.searchKeyArray.length; ++var11) {
                    if (var11 < 1) {
                        if (this.subSearchStrIndx == 0) {
                            if (this.keyColumn != null) {
                                for(var12 = 0; var12 < this.keyColumn.length; ++var12) {
                                    if (var12 != 0) {
                                        var9 = var9 + "&";
                                    }

                                    var9 = var9 + "keycol" + (var12 + 1) + "=" + this.rs.getString(this.keyColumn[var12]);
                                }
                            } else {
                                var9 = this.searchKeyArray[var11] + "=" + this.rs.getString(this.searchKeyArray[var11]);
                            }

                            var10 = this.rs.getString(this.searchKeyArray[var11]);
                        } else {
                            var12 = this.rs.getString(this.searchKeyArray[var11]).length();
                            if (this.keyColumn != null) {
                                for(int var13 = 0; var13 < this.keyColumn.length; ++var13) {
                                    if (var13 != 0) {
                                        var9 = var9 + "&";
                                    }

                                    var9 = var9 + "keycol" + (var13 + 1) + "=" + this.rs.getString(this.keyColumn[var13]);
                                }
                            } else {
                                var9 = this.searchKeyArray[var11] + "=" + this.rs.getString(this.searchKeyArray[var11]).substring(0, var12 - this.subSearchStrIndx);
                            }

                            var10 = this.rs.getString(this.searchKeyArray[var11]).substring(0, var12 - this.subSearchStrIndx);
                        }
                    } else {
                        if (this.keyColumn != null) {
                            for(var12 = 0; var12 < this.keyColumn.length; ++var12) {
                                if (var12 != 0) {
                                    var9 = var9 + "&";
                                }

                                var9 = var9 + "keycol" + (var12 + 1) + "=" + this.rs.getString(this.keyColumn[var12]);
                            }
                        } else {
                            var9 = var9 + "&" + this.searchKeyArray[var11] + "=" + this.rs.getString(this.searchKeyArray[var11]);
                        }

                        var10 = var10 + "|" + this.rs.getString(this.searchKeyArray[var11]);
                    }
                }

                if (this.onClickJS.equals("")) {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + var10 + "'></TD>");
                } else {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + var10 + "' onClick='" + this.onClickJS + "(" + var8 + ")'></TD>");
                }
            } else if (this.subSearchStrIndx == 0) {
                if (this.keyColumn != null) {
                    for(var11 = 0; var11 < this.keyColumn.length; ++var11) {
                        if (var11 != 0) {
                            var9 = var9 + "&";
                        }

                        var9 = var9 + "keycol" + (var11 + 1) + "=" + this.rs.getString(this.keyColumn[var11]);
                    }
                } else {
                    var9 = this.searchKey + "=" + this.rs.getString(this.searchKey);
                }

                if (this.onClickJS.equals("")) {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + this.rs.getString(this.searchKey) + "'></TD>");
                } else {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + this.rs.getString(this.searchKey) + "' onClick='" + this.onClickJS + "(" + var8 + ")'></TD>");
                }
            } else {
                var11 = this.rs.getString(this.searchKey).length();
                if (this.keyColumn != null) {
                    for(var12 = 0; var12 < this.keyColumn.length; ++var12) {
                        if (var12 != 0) {
                            var9 = var9 + "&";
                        }

                        var9 = var9 + "keycol" + (var12 + 1) + "=" + this.rs.getString(this.keyColumn[var12]);
                    }
                } else {
                    var9 = this.searchKey + "=" + this.rs.getString(this.searchKey).substring(0, var11 - this.subSearchStrIndx);
                }

                if (this.onClickJS.equals("")) {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + this.rs.getString(this.searchKey).substring(0, var11 - this.subSearchStrIndx) + "'></TD>");
                } else {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + this.rs.getString(this.searchKey).substring(0, var11 - this.subSearchStrIndx) + "' onClick='" + this.onClickJS + "(" + var8 + ")'></TD>");
                }
            }

            var4.append("<TD><A HREF='" + this.pageURL + (this.pageURL.indexOf("?") < 0 ? "?" : "&") + var9 + "'><img src='../image/docLink.gif' style='border-bottom-color:#CC0000' border='0' hspace='0' vspace='0'></A></TD>");
            if (!this.pageURL2.equals("")) {
                var4.append("<TD><A HREF='" + this.pageURL2 + (this.pageURL.indexOf("?") < 0 ? "?" : "&") + var9 + "'><img src='../image/questionmarkicon.gif' border='0'></A></TD>");
            }

            for(var11 = 1; var11 <= var2; ++var11) {
                String var14 = this.rs.getString(var11);
                if (var14 == null || var14.equals("null")) {
                    var14 = "&nbsp;";
                }

                if (var11 == 1) {
                    if (this.tdTipCh != null && !this.tdTipCh.equals("")) {
                        if (this.tdTipCh.equals("1")) {
                            var4.append("<TD " + this.tableWrapAttr + " " + this.tdMouseMoveAttr + "><FONT SIZE=2 FACE='ARIAL' color='#000099'><A HREF='" + this.pageURL + (this.pageURL.indexOf("?") < 0 ? "?" : "&") + var9 + "'><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var14 + "'>" + var14 + "</A></FONT></TD>");
                        }
                    } else {
                        var4.append("<TD " + this.tableWrapAttr + "><FONT SIZE=2 FACE='ARIAL' color='#000099'><A HREF='" + this.pageURL + (this.pageURL.indexOf("?") < 0 ? "?" : "&") + var9 + "'><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var14 + "'>" + var14 + "</A></FONT></TD>");
                    }
                } else if (this.tdTipCh != null && this.tdTipCh != "") {
                    if (this.tdTipCh.equals(var11)) {
                        var4.append("<TD " + this.tableWrapAttr + " " + this.tdMouseMoveAttr + "><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var14 + "'>" + var14 + "</FONT></TD>");
                    } else {
                        var4.append("<TD " + this.tableWrapAttr + "><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var14 + "'>" + var14 + "</FONT></TD>");
                    }
                } else {
                    var4.append("<TD " + this.tableWrapAttr + "><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var14 + "'>" + var14 + "</FONT></TD>");
                }
            }

            var4.append("</TR>");
            if (this.rowColor2.equals("")) {
                if (var5.equals("E3E3CF")) {
                    var5 = "E3E3B0";
                } else {
                    var5 = "E3E3CF";
                }
            } else if (var5.equals(this.rowColor1)) {
                var5 = this.rowColor2;
            } else {
                var5 = this.rowColor1;
            }
        }

        var4.append("</TABLE>");
        return var4.toString();
    }

    public String getRs2String() throws Exception {
        ResultSetMetaData var1 = this.rs.getMetaData();
        int var2 = var1.getColumnCount();
        String[] var3 = new String[var2 + 1];
        StringBuffer var4 = new StringBuffer();
        String var5 = "";
        String var6 = "BLACK";
        if (this.headColor != null) {
            var6 = this.headColor;
        }

        String var7 = "WHITE";
        if (this.headFontColor != null) {
            var7 = this.headFontColor;
        }

        if (this.tableWrapAttr != null && !this.tableWrapAttr.equals("")) {
            this.tableWrapAttr = "nowrap";
        }

        if (this.rowColor1.equals("")) {
            var5 = "E3E3CF";
        } else {
            var5 = this.rowColor1;
        }

        if (this.hideURL == null) {
            this.hideURL = "N";
        }

        var4.append("<TABLE cellSpacing='1' bordercolordark='#99CC99' cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='0'>");
        var4.append("<TR>");
        int var8;
        String var9;
        if (this.headerArray != null && this.headerArray.length > 0) {
            for(var8 = 0; var8 < this.headerArray.length; ++var8) {
                var9 = this.headerArray[var8];
                var4.append("<TH BGCOLOR='" + var6 + "'><FONT COLOR='" + var7 + "' SIZE=2>" + var9 + "</FONT></TH>");
            }
        } else {
            var4.append("<TH BGCOLOR='" + var6 + "'><FONT COLOR='" + var7 + "' SIZE=2>&nbsp;</FONT></TH><TH BGCOLOR='" + var6 + "'><FONT COLOR='" + var7 + "' SIZE=2>&nbsp;</FONT></TH>");
            if (!this.pageURL2.equals("")) {
                var4.append("<TH BGCOLOR='" + var6 + "'><FONT COLOR='" + var7 + "' SIZE=2>&nbsp;</FONT></TH>");
            }

            for(var8 = 1; var8 <= var2; ++var8) {
                var3[var8] = var1.getColumnLabel(var8);
                var4.append("<TH BGCOLOR='" + var6 + "' " + this.tableWrapAttr + "><FONT COLOR='" + var7 + "' SIZE=2 FACE='ARIAL'>" + var3[var8] + "</FONT></TH>");
            }
        }

        var4.append("</TR>");
        var8 = 0;
        var9 = "";
        String var10 = "";

        while(this.rs.next() && (var8 != this.scrollRowNumber || this.scrollRowNumber <= 0)) {
            ++var8;
            int var11;
            if (this.searchKeyArray != null && this.searchKeyArray.length >= 1) {
                for(var11 = 0; var11 < this.searchKeyArray.length; ++var11) {
                    if (var11 < 1) {
                        if (this.subSearchStrIndx == 0) {
                            var9 = this.searchKeyArray[var11] + "=" + this.rs.getString(this.searchKeyArray[var11]);
                            var10 = this.rs.getString(this.searchKeyArray[var11]);
                        } else {
                            int var12 = this.rs.getString(this.searchKeyArray[var11]).length();
                            var9 = this.searchKeyArray[var11] + "=" + this.rs.getString(this.searchKeyArray[var11]).substring(0, var12 - this.subSearchStrIndx);
                            var10 = this.rs.getString(this.searchKeyArray[var11]).substring(0, var12 - this.subSearchStrIndx);
                        }
                    } else {
                        var9 = var9 + "&" + this.searchKeyArray[var11] + "=" + this.rs.getString(this.searchKeyArray[var11]);
                        var10 = var10 + "|" + this.rs.getString(this.searchKeyArray[var11]);
                    }
                }

                if (this.onClickJS.equals("")) {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + var10 + "'></TD>");
                } else {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + var10 + "' onClick='" + this.onClickJS + "(" + var8 + ")'></TD>");
                }
            } else if (this.subSearchStrIndx == 0) {
                var9 = this.searchKey + "=" + this.rs.getString(this.searchKey);
                if (this.onClickJS.equals("")) {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + this.rs.getString(this.searchKey) + "'></TD>");
                } else {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + this.rs.getString(this.searchKey) + "' onClick='" + this.onClickJS + "(" + var8 + ")'></TD>");
                }
            } else {
                var11 = this.rs.getString(this.searchKey).length();
                var9 = this.searchKey + "=" + this.rs.getString(this.searchKey).substring(0, var11 - this.subSearchStrIndx);
                if (this.onClickJS.equals("")) {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + this.rs.getString(this.searchKey).substring(0, var11 - this.subSearchStrIndx) + "'></TD>");
                } else {
                    var4.append("<TR BGCOLOR='" + var5 + "'><TD " + this.tableWrapAttr + "><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + this.rs.getString(this.searchKey).substring(0, var11 - this.subSearchStrIndx) + "' onClick='" + this.onClickJS + "(" + var8 + ")'></TD>");
                }
            }

            if (this.hideURL == "Y") {
                var4.append("<TD><img src='../image/docLink.gif' style='border-bottom-color:#CC0000' border='0' hspace='0' vspace='0'></TD>");
            } else {
                var4.append("<TD><A HREF='" + this.pageURL + (this.pageURL.indexOf("?") < 0 ? "?" : "&") + var9 + "'><img src='../image/docLink.gif' style='border-bottom-color:#CC0000' border='0' hspace='0' vspace='0'></A></TD>");
            }

            if (!this.pageURL2.equals("") && this.hideURL != "Y") {
                var4.append("<TD><A HREF='" + this.pageURL2 + (this.pageURL.indexOf("?") < 0 ? "?" : "&") + var9 + "'><img src='../image/questionmarkicon.gif' border='0'></A></TD>");
            }

            for(var11 = 1; var11 <= var2; ++var11) {
                String var13 = this.rs.getString(var11);
                if (var13 == null || var13.equals("null")) {
                    var13 = "&nbsp;";
                }

                if (var11 == 1) {
                    if (this.tdTipCh != null && !this.tdTipCh.equals("")) {
                        if (this.tdTipCh.equals("1")) {
                            if (this.hideURL == "Y") {
                                var4.append("<TD " + this.tableWrapAttr + " " + this.tdMouseMoveAttr + "><FONT SIZE=2 FACE='ARIAL' color='#000099'></FONT><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var13 + "'>" + var13 + "</TD>");
                            } else {
                                var4.append("<TD " + this.tableWrapAttr + " " + this.tdMouseMoveAttr + "><FONT SIZE=2 FACE='ARIAL' color='#000099'><A HREF='" + this.pageURL + (this.pageURL.indexOf("?") < 0 ? "?" : "&") + var9 + "'><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var13 + "'>" + var13 + "</A></FONT></TD>");
                            }
                        }
                    } else if (this.hideURL == "Y") {
                        var4.append("<TD " + this.tableWrapAttr + "><FONT SIZE=2 FACE='ARIAL' color='#000099'><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var13 + "'>" + var13 + "</FONT></TD>");
                    } else {
                        var4.append("<TD " + this.tableWrapAttr + "><FONT SIZE=2 FACE='ARIAL' color='#000099'><A HREF='" + this.pageURL + (this.pageURL.indexOf("?") < 0 ? "?" : "&") + var9 + "'><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var13 + "'>" + var13 + "</A></FONT></TD>");
                    }
                } else if (this.tdTipCh != null && this.tdTipCh != "") {
                    if (this.tdTipCh.equals(var11)) {
                        var4.append("<TD " + this.tableWrapAttr + " " + this.tdMouseMoveAttr + "><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var13 + "'>" + var13 + "</FONT></TD>");
                    } else {
                        var4.append("<TD " + this.tableWrapAttr + "><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var13 + "'>" + var13 + "</FONT></TD>");
                    }
                } else {
                    var4.append("<TD " + this.tableWrapAttr + "><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='" + var8 + "_" + var11 + "' value='" + var13 + "'>" + var13 + "</FONT></TD>");
                }
            }

            var4.append("</TR>");
            if (this.rowColor2.equals("")) {
                if (var5.equals("E3E3CF")) {
                    var5 = "E3E3B0";
                } else {
                    var5 = "E3E3CF";
                }
            } else if (var5.equals(this.rowColor1)) {
                var5 = this.rowColor2;
            } else {
                var5 = this.rowColor1;
            }
        }

        var4.append("</TABLE>");
        return var4.toString();
    }
}
