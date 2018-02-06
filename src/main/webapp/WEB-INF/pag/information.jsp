<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<jsp:include page="common/head.jsp"></jsp:include>	<!-- 这里需要注意的公共部分可以做成模版 -->

<body>
<h1>ATM系统-查询余额</h1>

<form action="/card/information.do" method="post">	
	卡号 ${number}
	<input type="hidden" name="number" value="${number}"> <br>
	密码：<input type="password" name="password">	<br>
	<input type="submit" value="查询">
</form>

</body>

<a href="/card/toUsercenter.do">返回个人中心</a>

<jsp:include page="common/foot.jsp"></jsp:include>

</html>