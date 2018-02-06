<%-- <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>


<jsp:include page="common/head.jsp"></jsp:include>

<body>
<h1>ATM系统-登录</h1>

<form  method="post">	
	用户；<input type="text" id="username" name="username"> <br>
	密码：<input type="text" id="password" name="password">	<br>
	<input type="button" value="登录" onclick="login();">
</form>

<a href="/user/toRegister.do" target="_blank">注册</a>
</body>

<jsp:include page="common/foot.jsp"></jsp:include> --%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Amaze UI Admin index Examples</title>
    <meta name="description" content="这是一个 index 页面">
    <meta name="keywords" content="index">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <link rel="icon" type="image/png" href="/i/favicon.png">
    <meta name="apple-mobile-web-app-title" content="Amaze UI" />
    <link rel="stylesheet" href="/css/amazeui.min.css" />
    <link rel="stylesheet" href="/css/amazeui.datatables.min.css" />
    <link rel="stylesheet" href="/css/app.css">
    <script src="/js/jquery-3.2.1.js"></script>

</head>



<body data-type="login" class="theme-white">
    <script src="/js/theme.js"></script>
    <div class="am-g tpl-g">
        <!-- 风格切换 -->
     
        <div class="tpl-login">
            <div class="tpl-login-content">
                <div class="tpl-login-logo">

                </div>



                <form class="am-form tpl-form-line-form">
                    <div class="am-form-group">
                        <input type="text" class="tpl-form-input" id="username" placeholder="请输入账号">

                    </div>

                    <div class="am-form-group">
                        <input type="password" class="tpl-form-input" id="password" placeholder="请输入密码">

                    </div>
                  

                    <div class="am-form-group">

                        <button type="button" class="am-btn am-btn-primary  am-btn-block tpl-btn-bg-color-success  tpl-login-btn" onclick="login();">登录</button>

                    </div>
                    
                    <a href="/user/toRegister.do">注册</a>
                </form>
            </div>
        </div>
    </div>
    <script src="/js/amazeui.min.js"></script>
    <script src="/js/app.js"></script>
     <script type="text/javascript" src="/js/jquery.js"></script>
	<script type="text/javascript" src="/js/json2.js"></script>
	<script type="text/javascript">
    function login(){
    	var param={
			username:$('#username').val(),
			password:$('#password').val()
		};
			$.post('/user/login.do',param,callback);
	}
    
	function callback(data,status){
		alert("确认");
		var ajaxDAO=data;
		if(ajaxDAO.success){
			alert(username);
			alert(password);
			window.location.href='/user/toUsercenter.do';
			alert("成功");
		}
		else{
			alert(ajaxDAO.message);
			return false;
			}
		}
	
	
	</script>


	</html>