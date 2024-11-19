<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>無標題文件</title>
</head>

<body>
<form name="doublecombo">
<p><select name="example" size="1" onChange="redirect(this.options.selectedIndex)">
<option>搜尋</option>
<option>政府機關</option>
<option>教育</option>
</select>
<select name="stage2" size="1">
<option value="http://www.kimo.com.tw">奇摩站</option>
<option value="http://www.yam.com.tw">蕃薯藤</option>
<option value="http://www.yahoo.com.tw">雅虎台灣</option>
</select>
<input type="button" name="test" value="前往!!!"
onClick="go()">
</p>

<script>
<!--

var groups=document.doublecombo.example.options.length
var group=new Array(groups)
for (i=0; i<groups; i++)
group[i]=new Array()

group[0][0]=new Option("奇摩站","http://www.kimo.com.tw")
group[0][1]=new Option("蕃薯藤","http://www.yam.com.tw")
group[0][2]=new Option("雅虎台灣","http://www.yahoo.com.tw")

group[1][0]=new Option("立法院","http://www.ly.gov.tw")
group[1][1]=new Option("人事行政局","http://www.cpa.gov.tw")

group[2][0]=new Option("教育部","http://www.edu.tw")
group[2][1]=new Option("中等教育處","http://www.edu.tw/high-school")
group[2][2]=new Option("國立編譯館","http://www.nict.gov.tw")
group[2][3]=new Option("國際文教處","http://www.edu.tw/bicer")

var temp=document.doublecombo.stage2

function redirect(x){
for (m=temp.options.length-1;m>0;m--)
temp.options[m]=null
for (i=0;i<group[x].length;i++){
temp.options[i]=new Option(group[x][i].text,group[x][i].value)
}
temp.options[0].selected=true
}

function go(){
location=temp.options[temp.selectedIndex].value
}
//-->
</script>

</form>
</body>
</html>
