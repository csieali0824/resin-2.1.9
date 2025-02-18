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
<%@ page import="modelN.dto.DetailDto" %>
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
    <jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
    <link rel="stylesheet" href="../jsp/css/modelN.css"> <!-- 引用外部 CSS -->
</head>
<script>
    let detailObj = {
        column: '',
        value: '',
        index: '',
        rowCnt: '',
        requestObj: {
            index: '',
            salesNo: '',
            custId: '',
            custNo: '',
            custName: '',
            custPo: '',
            shipToOrgId: '',
            tempId: '',
            orderTypeId: '',
            rfqType: '',
            groupByType: '',
            uploadBy: '',
            insertFlag: ''
        }
    };

    function delData(url) {
        if (confirm("您確定要刪除此筆資料?")) {
            document.form1.action = url;
            document.form1.submit();
        }
    }

    function setSalesNo(url) {
        const selectElement = document.getElementById('options');
        const selectedValue = selectElement.value;
        document.form1.action = url + "?requestSalesNo=" + selectedValue;
        document.form1.submit();
    }

    function renderDetail(detailObj) {
        let detail = detailObj;
        let request = detail.requestObj;
        let trRow = document.getElementById('trRow' + request.index);
        let newCell = document.createElement('td');
        let columnColor = request.groupByType == 'byCustNo' ? 'Customer Name': 'Customer PO';
        let bgColor =  request.groupByType == 'byCustNo' ? '#66e2ece2': '#f5db4b87';
        newCell.id = detail.column + request.index;

        newCell.addEventListener('mouseover', function () {
            if (['Customer Name', 'RFQ Type', 'Ship to ID'].includes(detail.column)) {
                document.getElementById(columnColor + request.index).style.backgroundColor = bgColor;
                document.getElementById('RFQ Type' + request.index).style.backgroundColor = bgColor;
                if (request.salesNo == '002') {
                    document.getElementById('Ship to ID' + request.index).style.backgroundColor = bgColor;
                }
            }
        });
        newCell.addEventListener('mouseout', function () {
            if (['Customer Name', 'RFQ Type', 'Ship to ID'].includes(detail.column)) {
                document.getElementById(columnColor + request.index).style.backgroundColor = '#ffffff';
                // document.getElementById('Customer Name' + request.index).style.backgroundColor = '#ffffff';
                document.getElementById('RFQ Type' + request.index).style.backgroundColor = '#ffffff';
                if (request.salesNo == '002') {
                    document.getElementById('Ship to ID' + request.index).style.backgroundColor = '#ffffff';
                }
            }
        });

        if ("Delete All" != detail.column) {
            newCell.addEventListener('click', function () {
                window.location.href = 'TSCModelNDetail.jsp?' +
                    'rowIndex=' + request.index +
                    '&salesNo=' + request.salesNo +
                    '&customerId=' + request.custId +
                    '&customerNo=' + request.custNo +
                    '&customerName=' + request.custName +
                    '&customerPo=' + request.custPo +
                    '&shipToOrgId=' + request.shipToOrgId +
                    '&tempId=' + request.tempId +
                    '&orderType=' + request.orderTypeId +
                    '&rfqType=' + request.rfqType +
                    '&groupByType=' + request.groupByType +
                    '&uploadBy=' + request.uploadBy +
                    '&insertFlag=' + request.insertFlag;
            });
        }

        if (['Delete All', 'Customer Name', 'RFQ Type'].includes(detail.column)) {
            if ('Delete All' == detail.column) {
                let buttonElement = document.createElement("input");
                buttonElement.type = "button";
                buttonElement.value = "Delete"; // 設定按鈕文字
                buttonElement.name = "btn" + detail.index;
                buttonElement.title = "刪除資料";
                buttonElement.onclick = function () {
                    delData('../jsp/TSCModelNDetail.jsp?deleteFlag=Y' +
                        '&rowIndex=' + request.index +
                        '&salesNo=' + request.salesNo +
                        '&customerId=' + request.custId +
                        '&customerPo=' + request.custPo +
                        '&shipToOrgId=' + request.shipToOrgId +
                        '&groupByType=' + request.groupByType +
                        '&uploadBy=' + request.uploadBy);
                };
                newCell.appendChild(buttonElement)
            } else {
                newCell.textContent = ("Customer Name" == detail.column) ? "(" + request.custNo + ")" + detail.value : detail.value;
            }
        } else {
            newCell.textContent = detail.value;
        }
        trRow.appendChild(newCell);
    }
</script>
<body>
<%
    List salesList = modelNCommonUtils.getSalesArea(con, UserRoles, UserName);
    String salesNo = StringUtils.isNullOrEmpty((String) session.getAttribute("salesNo")) ? "" : (String) session.getAttribute("salesNo");
    String requestSalesNo = StringUtils.isNullOrEmpty(request.getParameter("requestSalesNo")) ? "" : request.getParameter("requestSalesNo");
    salesNo = salesNo.equals("") ? requestSalesNo : salesNo;
    String customerId = StringUtils.isNullOrEmpty(request.getParameter("customerId")) ? "" : request.getParameter("customerId");
    String customerNo = StringUtils.isNullOrEmpty(request.getParameter("customerNo")) ? "" : request.getParameter("customerNo");
    String customerName = StringUtils.isNullOrEmpty(request.getParameter("customerName")) ? "" : request.getParameter("customerName");
    String customerPo = StringUtils.isNullOrEmpty(request.getParameter("customerPo")) ? "" : request.getParameter("customerPo");
    String shipToOrgId = StringUtils.isNullOrEmpty(request.getParameter("shipToOrgId")) ? "" : request.getParameter("shipToOrgId");
//    String strRemark = "Order Import from file";
    String deleteAll = StringUtils.isNullOrEmpty(request.getParameter("deleteAll")) ? "" : request.getParameter("deleteAll");
    String deleteFlag = StringUtils.isNullOrEmpty(request.getParameter("deleteFlag")) ? "" : request.getParameter("deleteFlag");
    String insertFlag = StringUtils.isNullOrEmpty(request.getParameter("insertFlag")) ? "" : request.getParameter("insertFlag");
    String uploadBy = StringUtils.isNullOrEmpty(request.getParameter("uploadBy")) ? UserName : request.getParameter("uploadBy");
    String orderType = request.getParameter("orderType");
    String rfqType = request.getParameter("rfqType");
    String tempId = request.getParameter("tempId");
    String groupByType = request.getParameter("groupByType");
    String rowIndex = request.getParameter("rowIndex");
    salesNo = !StringUtils.isNullOrEmpty(request.getParameter("salesNo")) ? request.getParameter("salesNo") : salesNo;
    arrayRFQDocumentInputBean.setArray2DString(null);
    final String hiddenGroupByType = "Group By";
    int uploadRowCnt = 0, ErrCnt = 0, insert_cnt = 0;
    List list = new LinkedList();
    if (insertFlag.equals("Y")) {
        modelNCommonUtils.readTscRfqUploadTemp(salesNo, uploadBy, customerNo, customerPo, groupByType, shipToOrgId);
        Map drqCreateArg = new HashMap();
        drqCreateArg.put("customerId", customerId);
        drqCreateArg.put("customerNo", customerNo);
        drqCreateArg.put("customerName", SalesArea.TSCA.getSalesNo().equals(salesNo) ? "TSC America, Inc." : customerName);
        drqCreateArg.put("salesNo", salesNo);
        drqCreateArg.put("customerPo", customerPo);
        drqCreateArg.put("shipToOrgId", shipToOrgId);
        drqCreateArg.put("tempId", tempId);
        drqCreateArg.put("orderType", orderType);
        drqCreateArg.put("rfqType", rfqType);
        drqCreateArg.put("groupByType", groupByType);
        drqCreateArg.put("curr", SalesArea.TSCA.getSalesNo().equals(salesNo) ? "USD" : "");
        drqCreateArg.put("remark", "Order Import from file");
        String[][] strArray = modelNCommonUtils.sendRedirect2DRQCreate(session, response, drqCreateArg);
        if (!SalesArea.TSCA.getSalesNo().equals(salesNo)) {
            arrayRFQDocumentInputBean.setArray2DString(strArray);
        } else {
            // 依據TSCA舊有的邏輯，需新增一個值為""的陣列，不然到D1-001會少一筆
            String[][] newArray = new String[strArray.length + 1][strArray[0].length];
            // 複製原陣列内容到新陣列
            for (int i = 0; i < strArray.length; i++) {
                for (int j = 0; j < strArray[i].length; j++) {
                    newArray[i][j] = strArray[i][j];
                }
            }
            // 新增新的一行，内容為""
            for (int j = 0; j < strArray[0].length; j++) {
                if (j == 0) {
                    newArray[strArray.length][j] = String.valueOf(strArray.length + 1);
                } else {
                    newArray[strArray.length][j] = "";
                }
            }
            arrayRFQDocumentInputBean.setArray2DString(newArray);
        }
    } else if (deleteFlag.equals("Y")) {
        modelNCommonUtils.deteleTscRfqUploadTemp(salesNo, uploadBy, customerId, customerPo, groupByType, shipToOrgId);
        response.sendRedirect("TSCModelNDetail.jsp?requestSalesNo=" + salesNo + "");
    } else if (deleteAll.equals("Y")) {
        modelNCommonUtils.deteleAllTscRfqUploadTemp(salesNo, uploadBy);
        response.sendRedirect("TSCModelNDetail.jsp");
    }
%>
<form name="form1" method="post" accept-charset="utf-8">
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
                <table align="center" width="100%" cellspacing="0" cellpadding="0" style="margin-left: -4px;"
                       bordercolordark="#990000">
                    <tr>
                        <td width="90%">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td bgcolor="#C6D1E6" width="15%" height="20" align="center"
                                        style="border-color:#CAE1CF;border:insert;font-size:13px">
                                        <a href="../jsp/TSCModelNDetail.jsp"
                                           style="font-size:13px;text-decoration:none;">Pending Detail
                                        </a>
                                    </td>
                                    <td bgcolor="#CAE1CF" width="15%" align="center">
                                        <a href="../jsp/TSCModelN.jsp"
                                           style="color:888888;font-size:13px;text-decoration:none;">Excel Upload
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
                </table>
            <td width="5%">&nbsp;</td>
        </tr>
    </table>
    <div id="salesAreaRow"
         style="display: flex; justify-content: space-between; padding-left: 4px; padding-right: 80px;">
    </div>
<%--    <%--%>
<%--        Map getSalesAreaMap = modelNCommonUtils.getSalesArea(con, UserRoles, UserName);--%>
<%--        if (getSalesAreaMap.size() > 1) {--%>
<%--            out.println("<select name='salesNo' id='options' class='detailSelect' tabindex='1'" +--%>
<%--                        "onChange='setSalesNo(" + '"' + "../jsp/TSCModelNDetail.jsp" + '"' + ")'>");--%>
<%--            out.println("<option value=All>請選擇</option>");--%>
<%--        }--%>
<%--        for (Iterator it = getSalesAreaMap.entrySet().iterator(); it.hasNext(); ) {--%>
<%--            Map.Entry entry = (Map.Entry) it.next();--%>
<%--            String s1 = (String) entry.getKey();--%>
<%--            String s2 = (String) entry.getValue();--%>
<%--            if (getSalesAreaMap.size() > 1) {--%>
<%--                if (s1.equals(salesNo)) {--%>
<%--                    out.println("<option value='" + s1 + "' selected>" + s2);--%>
<%--                } else {--%>
<%--                    out.println("<option value='" + s1 + "'>" + s2);--%>
<%--                }--%>
<%--            } else {--%>
<%--                out.println("<td name='salesNo' value ='" + s1 + "'>" +--%>
<%--                                "<input type='text' class='detailSelect detailSelectedOne' value='" + s2 + "' readonly>" +--%>
<%--                            "</td>");--%>
<%--                salesNo = StringUtils.isNullOrEmpty(salesNo) ? s1 : salesNo;--%>
<%--            }--%>
<%--        }--%>
<%--        if (getSalesAreaMap.size() > 1) {--%>
<%--            out.println("</select>");--%>
<%--        }--%>

<%--        if (!StringUtils.isNullOrEmpty(salesNo) && !salesNo.equals("All")) {--%>
<%--            modelNCommonUtils.setDetailHtmlColumns(salesNo);--%>
<%--            modelNCommonUtils.readTscRfqUploadTemp(salesNo, uploadBy, customerNo, customerPo, groupByType, shipToOrgId);--%>
<%--    %>--%>
<%--        <div style="display: flex; gap: 5px;">--%>
<%--            <div class="roundedByNo">CustNo</div>--%>
<%--            <div class="roundedByPo">CustPo</div>--%>
<%--        </div>--%>
<%--    </div>--%>
    <%
        if (!StringUtils.isNullOrEmpty(salesNo) && !salesNo.equals("All")) {
            modelNCommonUtils.setDetailHtmlColumns(salesNo);
            modelNCommonUtils.readTscRfqUploadTemp(salesNo, uploadBy, customerNo, customerPo, groupByType, shipToOrgId);
    %>
            <table id="dataTable" align="center" border="1" width="90%" cellspacing="0" cellpadding="1"
                   bordercolorlight="#DFD9DD"
                   bordercolordark="#4A598A">
                <tr style="background-color:#C6D1E6;font-size:10px;text-wrap-mode: nowrap;">
                <%
                    String[] columns = modelNCommonUtils.getDetailHeaderColumns();
                    for (int i = 0, n = columns.length; i < n; i++) {
                        int width = ((Integer) modelNCommonUtils.getDetailHeaderHtmlWidthMap().get(columns[i])).intValue();
                        if (columns[i].equals("Delete All")) { %>
                            <td width="<%=width%>%" align="center">
                                <input type="button" name="btnAll" value="Delete All" title="刪除全部資料" style="font-size:12px;font-family: Tahoma,Georgia;"
                                       onClick="delData('../jsp/TSCModelNDetail.jsp?deleteAll=Y')">
                            </td>
                <%      } else if (!hiddenGroupByType.equals(columns[i])){ %>
                            <td width="<%=width%>%" align="center"><%=columns[i]%></td>
                <%      } %>

                <%
                    }
                %>
                </tr>
                <%
                    try {
                        DetailDto detailDto = new DetailDto();
                        HashMap map = new LinkedHashMap();
                        for (Iterator it = modelNCommonUtils.getDetailMap().entrySet().iterator(); it.hasNext();) {
                            Map.Entry entry = (Map.Entry) it.next();
                            int index = ((Integer) entry.getKey()).intValue();
                            List objectList = (LinkedList) entry.getValue();
                            for (int i = 0, n = objectList.size(); i < n; i++) {
                                if (objectList.get(i) instanceof DetailDto) {
                                    detailDto = (DetailDto) objectList.get(i);
                %>
                                    <script>
                                        var params = {
                                                index: "<%=index%>",
                                                salesNo: "<%=detailDto.getSalesNo()%>",
                                                custId: "<%=detailDto.getCustomerId()%>",
                                                custNo: "<%=detailDto.getCustomerNo()%>",
                                                custName: "<%=detailDto.getCustomerName()%>",
                                                custPo: "<%=detailDto.getCustomerPo()%>",
                                                shipToOrgId: "<%=detailDto.getShipToOrgId()%>",
                                                tempId: "<%=detailDto.getTempId()%>",
                                                orderTypeId: "<%=detailDto.getOrderTypeId()%>",
                                                rfqType: "<%=detailDto.getRfqType()%>",
                                                groupByType: "<%=detailDto.getGroupByType()%>",
                                                uploadBy: "<%=detailDto.getUploadBy()%>",
                                                insertFlag: 'Y'
                                        };
                                    </script>
                <tr id="trRow<%=index%>" title="按下滑鼠左鍵,進入TSC 業務交期詢問單畫面" class="detailContent">
                            <% } else if (objectList.get(i) instanceof HashMap) {
                                    map = (HashMap) objectList.get(i);
                                    for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
                                        Map.Entry en = (Map.Entry) iterator.next();
                                        String column = (String) en.getKey();
                                        String value = (String) en.getValue() == null ? "" : (String) en.getValue();
                            %>
                                        <script>
                                            detailObj = {
                                                column: "<%=column%>",
                                                value: "<%=value%>",
                                                rowCnt: "<%=detailDto.getRowCount()%>",
                                                requestObj: params
                                            };
                                            renderDetail(detailObj)
                                        </script>
                <%
                                    }
                                }
                            }
                %>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='9'>Exception:" + e.getMessage() + "</td></tr>");
                    }
                %>
            </table>
    <%
        }
    %>
    <!--=============以下區段為釋放連結池==========-->
    <%@ include file="/jsp/include/ReleaseConnPage.jsp" %>
</form>
<script>
    function createSalesDropdown(salesOptions, salesNo) {
        const div = document.getElementById("salesAreaRow");
        const select = document.createElement("select");
        select.name = "salesNo";
        select.id = "options";
        select.classList.add('detailSelect');
        select.onchange = () => setSalesNo("../jsp/TSCModelNDetail.jsp");
        const urlParams = new URLSearchParams(window.location.search) ;
        salesOptions.push({value: 'All', text: '請選擇'});
        // 使用 sort() 方法， 將 "All" 排到第一位
        salesOptions.sort((a, b) => (a.value === 'All' ? -1 : b.value === 'All' ? 1 : 0));

        salesOptions.forEach(optionData => {
            const option = document.createElement("option");
            option.value = optionData.value;
            option.textContent = optionData.text;
            if (optionData.value === (urlParams.get("requestSalesNo") || salesNo)) {
                option.selected = true;
            }
            select.appendChild(option);
            select.appendChild(option);
        });
        div.appendChild(select);
        createCustNoAndPo(div);
    }

    function createSalesInput(salesOptions) {
        const div = document.getElementById("salesAreaRow");
        const input = document.createElement("input");
        input.id = "options";
        input.value = salesOptions[0].text;
        input.classList.add('detailSelect');
        input.classList.add('detailSelectedOne');
        input.readOnly = true;
        div.appendChild(input);
        createCustNoAndPo(div);
    }

    function createCustNoAndPo(div) {
        // 內層 div
        const innerDiv = document.createElement("div");
        innerDiv.setAttribute("style", "display: flex; gap: 5px;");
        const divCustNo = document.createElement("div");
        const divCustPo = document.createElement("div");
        divCustNo.classList.add('roundedByNo');
        divCustNo.textContent = 'CustNo';
        divCustPo.classList.add('roundedByPo');
        divCustPo.textContent = 'CustPo';
        innerDiv.appendChild(divCustNo);
        innerDiv.appendChild(divCustPo);
        div.appendChild(innerDiv);
    }

    if (<%=salesList.size() > 1 %>) {
        createSalesDropdown(<%=modelNCommonUtils.writeValueToString(salesList)%>,  '<%=salesNo%>')
    } else {
        createSalesInput(<%=modelNCommonUtils.writeValueToString(salesList)%>)
    }
    <%--createSalesDropdown(<%=modelNCommonUtils.getSalesDropdown(con, UserRoles, UserName)%>, '<%=salesNo%>')--%>

    function mergeColumns(salesNo, columnLength) {
        if ( !['All', ''].includes(salesNo)) {
            const table = document.getElementById('dataTable');
            const rows = table.rows;
            let previousDelete = null;
            let previousCustomerName = null;
            let previousRFQType = null;
            let previousCustomerPo = null;
            let previousShipToOrgId = null;
            let rowspanCount = 1;

            for (let i = 1; i < rows.length; i++) { // 從第一行資料開始（跳過標題）
                const currentDelete = rows[i].cells[0];
                const currentCustomerName = rows[i].cells[1];
                const currentShipToOrgId = salesNo == '002' ? rows[i].cells[2] : null;
                const currentRFQType = salesNo == '002' ? rows[i].cells[3] : rows[i].cells[2];
                const currentCustomerPo = salesNo == '002' ? rows[i].cells[5] : rows[i].cells[3];
                const groupBy = rows[i].cells[columnLength-1];
                groupBy.style.display = 'none';
                let groupedConditon = '';
                if ('byCustNo' == groupBy.innerText) {
                    groupedConditon = previousCustomerName?.innerText == currentCustomerName.innerText;
                } else {
                    groupedConditon = previousCustomerPo?.innerText == currentCustomerPo.innerText;
                }
                if (
                    (previousDelete &&
                    previousDelete.innerText == currentDelete.innerText &&
                    groupedConditon &&
                    previousRFQType.innerText == currentRFQType.innerText)
                ) {
                    // 合併欄位
                    rowspanCount++;

                    previousDelete.rowSpan = rowspanCount;
                    previousRFQType.rowSpan = rowspanCount;
                    if (salesNo == '002') {
                        previousShipToOrgId.rowSpan = rowspanCount;
                    }
                    if ('byCustNo' == groupBy.innerText) {
                        previousCustomerName.rowSpan = rowspanCount;
                    } else {
                        previousCustomerPo.rowSpan = rowspanCount;
                    }

                    currentDelete.style.display = 'none';
                    currentRFQType.style.display = 'none';
                    if (salesNo == '002') {
                        currentShipToOrgId.style.display = 'none';
                    }
                    if ('byCustNo' == groupBy.innerText) {
                        currentCustomerName.style.display = 'none';
                    } else {
                        currentCustomerPo.style.display = 'none';
                    }
                } else {
                    // 重置計數
                    previousDelete = currentDelete;
                    previousRFQType = currentRFQType;
                    previousShipToOrgId = currentShipToOrgId;
                    if (salesNo == '002') {
                        previousShipToOrgId = currentShipToOrgId;
                    }
                    if ('byCustNo' == groupBy.innerText) {
                        previousCustomerName = currentCustomerName;
                    } else {
                        previousCustomerPo = currentCustomerPo;
                    }

                    rowspanCount = 1;
                }
            }
        }
    }
    mergeColumns('<%=salesNo%>', <%=modelNCommonUtils.getDetailHeaderColumns().length%>);
</script>
</body>
</html>
