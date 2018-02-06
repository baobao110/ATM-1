<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>

<jsp:include page="common/head.jsp"></jsp:include>

<body>
<h1>流水页面</h1>
<form id="List" name="form"  method="post">
卡号；${number}
<input type="hidden" id="number" name="number" value="${number}"> <br>		<!--注意这里的name和value,name是用于参数的名称,value为当前文本的值  -->
密码：<input type="text" id="password" name="password" value="${password}">	<br>
<!-- <input type="hidden" id="currentPage" name="currentPage" value="1"> -->
<input type="button" value="查询流水" onclick="flow()"><br>	<!-- 注意这里用button,不能用submit  -->
</form>
		<button onclick="Flow()">"打印"</button>
		<button onclick="first()">首页</button>
		<button onclick="pre()">上一页</button>
		<button onclick="next()">下一页</button>
		<button onclick="last()">尾页</button>
		<span id="pag">1/0</span>
<table id="table">
	
</table>
<jsp:include page="common/foot.jsp"></jsp:include>
</body>

<script type="text/javascript" src="/js/jquery-3.2.1.js"></script>
<script type="text/javascript" src="/js/json2.js"></script>
<script type="text/javascript">

	var currentPage = 1;
	
	var totalPage=0;
	
	function Flow(){
		 document.forms['form'].action= "/card/down.do";
		 document.getElementById("List").submit();
	}
	function next() {
		if (currentPage == totalPageNum) {
			return false;
		}
		
		currentPage=parseInt(currentPage) + 1;
		flow();
	}
	
	function pre() {
		
		if (currentPage == 1) {
			return false;
		}
		
		currentPage = parseInt(currentPage) - 1;
		flow();
	}
	
	function first() {
		currentPage = 1;
		flow();
	}
	
	function last() {
		currentPage = totalPageNum;
		flow();
	}
	
	function getNowFormatDate(day)
	{
	//var day = new Date();
	var Year = 0;
	var Month = 0;
	var Day = 0;
	var CurrentDate = "";
	//初始化时间
	//Year= day.getYear();//有火狐下2008年显示108的bug
	Year= day.getFullYear();//ie火狐下都可以
	Month= day.getMonth()+1;
	Day = day.getDate();
	//Hour = day.getHours();
	// Minute = day.getMinutes();
	// Second = day.getSeconds();
	CurrentDate += Year + "-";
	if (Month >= 10 )
	{
	CurrentDate += Month + "-";
	}
	else
	{
	CurrentDate += "0" + Month + "-";
	}
	if (Day >= 10 )
	{
	CurrentDate += Day ;
	}
	else
	{
	CurrentDate += "0" + Day ;
	}
	return CurrentDate;
	} /* 注意该方法是对JSON时间格式转换 */

	
	function flow(){
		var param={
			currentPage:currentPage,
			number:$('#number').val(),
			password:$('#password').val()/*注意这里的根据id获取值*/
		};
		$.post('/card/list.do',param,callback);
	}
	
	function callback(data,status){
		alert("点击");
		/* var ajaxDAO=JSON.parse(data); */
		var ajaxDAO=data;
		alert(ajaxDAO);
		var result=ajaxDAO.data.object;
		var msg='<tr><td>卡号</td><td>金额</td><td>备注</td><td>时间</td></tr>';
		for (var i=0; i<result.length;i++) {
			msg+='<tr>';
			msg+='<td>'+result[i].number+'</td>';
			msg+='<td>'+result[i].money+'</td>';
			msg+='<td>'+result[i].description+'</td>';
			msg+='<td>'+getNowFormatDate(new Date(result[i].createtime))+'</td>';
		}
		totalPage = ajaxDAO.data.totalPage;
		$('#table').html(msg);
		$('#pag').html(currentPage+ '/' + totalPage);
	}
	
	flow();
	
</script>

</html>

</html>
