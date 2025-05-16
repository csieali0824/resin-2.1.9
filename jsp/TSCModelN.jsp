<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jxl.*" %>
<%@ page import="WorkingDateBean" %>
<%@ page import="java.lang.Math.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="modelN.ModelNCommonUtils" %>
<%@ page import="com.jspsmart.upload.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page import="java.util.Date" %>
<%@ page import="modelN.dto.ModelNDto" %>
<%@ page import="modelN.SalesArea" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp" %>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
    <title>Excel Upload</title>
    <jsp:useBean id="dateBean" scope="page" class="DateBean"/>
    <jsp:useBean id="modelNCommonUtils" scope="session" class="modelN.ModelNCommonUtils"/>
    <jsp:useBean id="smartUpload" scope="page" class="com.jspsmart.upload.SmartUpload"/>
    <jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
    <link rel="stylesheet" href="../jsp/css/modelN.css"> <!-- 引用外部 CSS -->
</head>
<body>
<%
    String action = StringUtils.isNullOrEmpty(request.getParameter("action")) ? "" : request.getParameter("action");
    String salesNo = StringUtils.isNullOrEmpty(request.getParameter("salesNo")) ? "" : request.getParameter("salesNo");
    String groupByType = StringUtils.isNullOrEmpty(request.getParameter("groupByType")) ? "" : request.getParameter("groupByType");
    String rfqType = request.getParameter("rfqType");
    int uploadRowCnt = 0, ErrCnt = 0, insert_cnt = 0;
    String byCustNo = "byCustNo", byCustPo = "byCustPo", strCurr = "";
    session.setAttribute("salesNo", StringUtils.isNullOrEmpty(salesNo) ? modelNCommonUtils.salesNo : salesNo);
    List salesList = modelNCommonUtils.getSalesArea(con, UserRoles, UserName);
%>

<% if (salesList.isEmpty()) { %>
<script language="JavaScript" type="text/JavaScript">
    alert("您沒有該區域使用權限,無法使用此功能,謝謝!");
    location.href="../ORAddsMainMenu.jsp";
</script>
<% } %>

<form name="form1" method="post" ENCTYPE="multipart/form-data" accept-charset="utf-8">
    <div id="showimage" class="showImage">
        <br>
        <table width="350" class="image-table">
            <tr>
                <td height="70" bgcolor="#CCCC99" align="center"><font color="#003399" face="標楷體" size="+2">資料正在處理中,請稍候.....</font>
                    <br>
                    <div id="blockDiv" class="blockDiv"></div>
                </td>
            </tr>
        </table>
    </div>
    <div id='alpha' class='hidden'
         style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'>
    </div>
    <table width="100%" align="center" border="0">
        <tr>
            <td width="5%">&nbsp;</td>
            <td width="90%">
                <table width="100%" cellspacing="0" cellpadding="0" bordercolordark="#009933">
                    <tr>
                        <td height="50" align="center">
                            <font color="#000000" size="+2"> <strong> Excel Upload</strong></font>
                        </td>
                    </tr>
                </table>
            </td>
            <td width="5%">&nbsp;</td>
        </tr>
        <tr>
            <td width="5%">&nbsp;</td>
            <td width="90%">
                <table align="center" width="100%" cellspacing="0" cellpadding="0"
                       bordercolordark="#990000">
                    <tr>
                        <td width="90%">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td bgcolor="#C6D1E6" width="15%" height="20" align="center"
                                        style="border-color:#66CC66;border:insert;font-size:13px">Excel Upload
                                    </td>
                                    <td bgcolor="#CAE1CF" width="15%" align="center">
                                        <a href="../jsp/TSCModelNDetail.jsp"
                                           style="color:888888;font-size:13px;text-decoration:none;">Pending Detail
                                        </a>
                                    </td>
                                    <td width="70%" style="border-color:ffffff;">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                        <td align="right" width="10%" title="回首頁!">
                            <a href="../ORAddsMainMenu.jsp"
                               style="font-size:13px;font-family:標楷體;text-decoration:none;color:#0000FF">
                                <strong>回首頁</strong>
                            </a>
                        </td>
                    </tr>
                    <tr>
                        <td height="10" colspan="2" bgcolor="#C6D1E6"></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table bordercolordark="#000033" cellspacing="0" cellpadding="0"
                                   width="100%" align="left"
                                   bordercolorlight="ffffff" border="1">
                                <tr id="salesAreaRow">
                                    <td width="15%" class="column-backGround">Sales Area：</td>
                                </tr>
                                <%
                                    String normal = modelNCommonUtils.getRFQType(salesNo)[0];
                                    String forecast = modelNCommonUtils.getRFQType(salesNo)[1];
                                %>

                                <tr>
                                    <td class="column-backGround">RFQ Type：</td>
                                    <td class="radio-group">
                                        <input type="radio" name="rfqType" value="<%=normal%>"><%=normal%>
                                        <input type="radio" name="rfqType" value="<%=forecast%>"><%=forecast%>
                                    </td>
                                </tr>
                                <%
                                    String custNo = modelNCommonUtils.getGroupBy(salesNo)[0];
                                    String custPo = modelNCommonUtils.getGroupBy(salesNo)[1];
                                %>
                                        <tr>
                                            <td class="column-backGround">Group By：</td>
                                            <td class="check-group">
                                                <input type="checkbox" name="checkbox1" value="<%=byCustNo%>"
                                                <%
                                                    if (groupByType.equals(byCustNo)) {
                                                        out.println("checked");
                                                }%>
                                                        onClick="setGroupBy('<%=byCustNo%>');"><%=custNo%>

                                                <input type="checkbox" name="checkbox1" value="<%=byCustPo%>"
                                                <%
                                                    if (groupByType.equals(byCustPo)) {
                                                        out.println("checked");
                                                }%>
                                                        onClick="setGroupBy('<%=byCustPo%>');"><%=custPo%>
                                            </td>
                                        </tr>
                                <tr>
                                    <td class="column-backGround">Upload File：</td>
                                    <td width="85%">
                                        <%
                                            String uploadDisabled = salesNo.equals("All") || salesNo.equals("") ? "disabled" : "";
                                        %>
                                             <input type="file" class="uploadFile" NAME="UPLOADFILE">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="column-backGround">Sample File：</td>
                                    <td width="85%">
                                        <a href="../jsp/samplefiles/ModelN_Sample.xls">
                                            <font style="font-size: 12px; margin-left: 5px;">Download Sample File</font>
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2" title="請按我，謝謝!" align="center">
                            <input type="button" style="font-size:13px;font-family: Tahoma,Georgia;" name="submit1"
                                   value='Upload'
                                   onClick="setCreate('../jsp/TSCModelN.jsp?action=UPLOAD')">
                        </td>
                    </tr>
                </table>
            </td>
            <td width="5%">&nbsp;</td>
        </tr>
    </table>
    <%
        if (action.equals("UPLOAD")) {
            smartUpload.initialize(pageContext);
            smartUpload.upload();
            String startDate = dateBean.getYearMonthDay();
            String startDateTime = startDate + dateBean.getHourMinuteSecond();
            if (!SalesArea.TSCA.getSalesNo().equals(salesNo)) {
                dateBean.setAdjDate(!SalesArea.TSCR.getSalesNo().equals(salesNo) ? 7 : 6);
                dateBean.setAdjDate(!SalesArea.TSCR.getSalesNo().equals(salesNo) ? -7 : -6);
            }
            com.jspsmart.upload.File upload_file = smartUpload.getFiles().getFile(0);
            String uploadFile_name = upload_file.getFileName();
            if (uploadFile_name == null || uploadFile_name.equals("")) {
                out.println(
                        "<script language=javascript>alert('請先按瀏覽鍵選擇欲上傳的office 2003 excel檔，謝謝!')</script>");
            } else if (!(uploadFile_name.toLowerCase()).endsWith("xls")) {
                out.println(
                        "<script language=javascript>alert('上傳檔案必須為office 2003 excel檔!')</script>");
            } else {
                String uploadFilePath = modelNCommonUtils.getUploadFilePath(salesNo, startDateTime, rfqType, groupByType, uploadFile_name, startDate);
                upload_file.saveAs(uploadFilePath);
                modelNCommonUtils.writeExcel();
                for (Iterator it = modelNCommonUtils.excelMap.entrySet().iterator(); it.hasNext(); ) {
                    Map.Entry entry = (Map.Entry) it.next();
                    ModelNDto modelNDto = (ModelNDto) entry.getValue();
                    if (modelNDto.getErrorList().size() > 0) {
                        if (ErrCnt == 0) {
    %>
                            <table cellspacing="0" bordercolordark="#ffffff" cellpadding="1" width="90%" align="center"
                                   bordercolorlight="#ffffff" border="1">
                                <tr bgcolor="#96AEBC" style="color:#ffffff;font-size:11px;">
                                    <td width='4%'>Customer No</td>
                                    <td width='10%'>Customer Name</td>
                                    <td width='4%'>RFQ Type</td>
                                    <td width='8%'>Customer PO</td>
                                    <td width='4%'>Order Type</td>
                                    <td width='8%'>TSC P/N</td>
                                    <td width='8%'>Customer P/N</td>
                                    <td width='5%'>Qty(KPCS)</td>
                                    <td width='5%'>Selling Price</td>
                                    <td width='4%'>SSD</td>
                                    <td width='7%'>Remarks</td>
                                    <td width='4%'>End Cust Number</td>
                                    <td width='6%'>End Customer</td>
                                    <td width='10%'>Error Message</td>
                                </tr>
                    <%
                        }
                    %>
                                <tr bgcolor="#CCFFAC" style="color:#000000;font-size:11px;">
                                    <td><%=modelNDto.getCustNo()%></td>
                                    <td><%=modelNDto.getCustName()%></td>
                                    <td><%=modelNCommonUtils.rfqType%></td>
                                    <td><%=modelNDto.getCustPo()%></td>
                                    <td><%=modelNDto.getOrderType()%></td>
                                    <td><%=modelNDto.getTscItemDesc()%></td>
                                    <td><%=modelNDto.getCustItem()%></td>
                                    <td><%=modelNDto.getQty()%></td>
                                    <td><%=modelNDto.getSellingPrice()%></td>
                                    <td><%=modelNDto.getSsd()%></td>
                                    <td><%=modelNDto.getRemarks()%></td>
                                    <td><%=(modelNDto.getEndCustNo() == null || modelNDto.getEndCustNo().equals("") ? "" : modelNDto.getEndCustNo())%></td>
                                    <td><%=(modelNDto.getEndCustNamePhonetic() == null || modelNDto.getEndCustNamePhonetic().equals("") ? "" : modelNDto.getEndCustNamePhonetic())%></td>
                                    <td style="color:#FF0000"><%=modelNCommonUtils.errList2String(modelNDto.getErrorList())%></td>
                                </tr>
        <%
                        ErrCnt++;
                    }
                }
                uploadRowCnt++;
//                modelNCommonUtils.wb.close();
                if (uploadRowCnt == 0) {
                    throw new Exception("上傳內容錯誤!");
                }
            }
            if (ErrCnt > 0) {
        %>
                </table>
                <table width='90%' align='center'>
                    <tr>
                        <td align='center'>
                            <font style='color:#ff0000;font-family:標楷體;font-size:16px'>上傳動作失敗，請洽系統管理員，謝謝!</font>
                        </td>
                    </tr>
                </table>
        <%
            } else {
                modelNCommonUtils.insertIntoTscRfqUploadTmp();
                insert_cnt++;
                if (insert_cnt > 0) {
                    response.sendRedirect("TSCModelNDetail.jsp");
                }
            }
        }
        %>
<%--    </table>--%>
    <!--=============以下區段為釋放連結池==========-->
    <%@ include file="/jsp/include/ReleaseConnPage.jsp" %>
</form>
<script>
    document.addEventListener('keydown', function (event) {
        if (event.key === 'F5') {
            // 清空參數
            window.history.replaceState(null, "", window.location.pathname);
            // 重新整理
            window.location.reload();
        }
    });

    function setSalesNo(url) {
        const selectElement = document.getElementById('options');
        const selectedValue = selectElement.value;
        document.form1.action = url + "?salesNo=" + selectedValue;
        document.form1.submit();
    }

    function setGroupBy(svalue) {
        var checkbox1 = document.form1.checkbox1;
        for (var i = 0; i <= checkbox1.length; i++) {
            if (checkbox1[i] != undefined) {
                if (checkbox1[i].value != svalue) {
                    checkbox1[i].checked = false;
                }
            }
        }
    }

    function setCreate(url) {
        if (document.form1.UPLOADFILE.value == "") {
            alert("請選擇上傳檔案!");
            document.form1.UPLOADFILE.focus();
            return false;
        }
        let filename = document.form1.UPLOADFILE.value;
        filename = filename.substr(filename.length - 4);
        if (filename.toUpperCase() != ".XLS") {
            alert('上傳檔案必須為office 2003 excel檔!');
            document.form1.UPLOADFILE.focus();
            return false;
        }

        let rfqType = "";
        let radioLength = document.form1.rfqType.length;
        if (radioLength == undefined) {
            return;
        }
        for (let i = 0; i < radioLength; i++) {
            if (document.form1.rfqType[i].checked) {
                rfqType = document.form1.rfqType[i].value;
            }
        }
        if (rfqType == false) {
            alert("請選擇RFQ類型!");
            return false;
        }
        const element = document.getElementById('options');
        const selectedValue = element.getAttribute("value") ? element.getAttribute("value") : element.value;
        let groupByType = "";
        let checkbox1 = document.form1.checkbox1;
        for (let i = 0; i < checkbox1.length; i++) {
            if (checkbox1[i].checked) {
                groupByType = checkbox1[i].value;
            }
        }
        if (groupByType == "") {
            alert("請選擇Group Type!");
            return false;
        }
        document.form1.submit1.disabled = true;
        document.getElementById("alpha").style.width = "100" + "%";
        document.getElementById("alpha").style.height = document.body.scrollHeight + "px";
        document.getElementById("showimage").style.visibility = "visible";
        document.getElementById("blockDiv").style.visibility = "visible";
        document.form1.action = url + "&rfqType=" + rfqType + "&groupByType=" + groupByType + "&salesNo=" + selectedValue;
        document.form1.submit();
    }

    function createSalesDropdown(salesOptions) {
        const tr = document.getElementById("salesAreaRow");
        const td = document.createElement("td");
        const select = document.createElement("select");
        select.name = "salesNo";
        select.id = "options";
        select.style.fontSize = "12px";
        select.tabIndex = 1;
        select.onchange = () => setSalesNo("../jsp/TSCModelN.jsp");
        const urlParams = new URLSearchParams(window.location.search);
        salesOptions.push({value: 'All', text: '請選擇'})
        // 使用 sort() 方法， 將 "All" 排到第一位
        salesOptions.sort((a, b) => (a.value === 'All' ? -1 : b.value === 'All' ? 1 : 0));

        salesOptions.forEach(optionData => {
            const option = document.createElement("option");
            option.value = optionData.value;
            option.textContent = optionData.text;
            if (optionData.value === urlParams.get("salesNo")) {
                option.selected = true;
            }
            select.appendChild(option);
            select.appendChild(option);
        });
        td.appendChild(select);
        tr.appendChild(td);
    }

    function createSalesInput(salesOptions) {
        const tr = document.getElementById("salesAreaRow");
        const td = document.createElement("td");
        const input = document.createElement("input");
        td.value = salesOptions[0].value;
        td.name = "salesNo";
        td.id = "options";
        input.value = salesOptions[0].text;
        input.classList.add('selected');
        input.readOnly = true;
        td.appendChild(input);
        tr.appendChild(td);
    }

    if (<%=salesList.size() > 1 %>) {
        createSalesDropdown(<%=modelNCommonUtils.writeValueToString(salesList)%>)
    } else {
        createSalesInput(<%=modelNCommonUtils.writeValueToString(salesList)%>)
    }

</script>
</body>
</html>
