<script language="JavaScript" type="text/JavaScript">
function init() {
        block = blockDiv.style
        block.xpos = parseInt(block.left)
}
function slide() {
        if (block.xpos <= 270) {
                block.xpos += 10
                block.left = block.xpos
                setTimeout("slide()",100)
				}
		else
		{
			restart()
        }
}

function restart() {
        block.xpos = 50;
        block.left = block.xpos;
		slide()
}
function rstart(){
	showimage.style.visibility = '';
	blockDiv.style.display = '';
	init();
	slide();	
}
function rsStop(){	
    showimage.style.visibility = 'hidden';
	blockDiv.style.display ='none';		
}
</script>
<html>
<div id="showimage" style="position:absolute; visibility:visiable; z-index:65535; top: 160px; left: 200px; width: 370px; height: 90px;"> 
  <br>
  <table width="320" height="70" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"> <font color="#336633">搜尋處理中,請稍後...</font> <BR>
      <DIV ID="blockDiv" STYLE="position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>	
<script language="JavaScript" type="text/JavaScript">
showimage.style.visibility = '';
blockDiv.style.display = '';
init();	
slide();
</script>
</html>
