<%-- <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>

<jsp:include page="common/head.jsp"></jsp:include>

<body>
<h1>注册页面</h1>
<%-- <form  method="post">
用户名:<input type="text" id="username" name="username"><br>
密码:<input type="text" id="password" name="password"><br>
<input type="button" value="注册" onclick="regist()">
</form>

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

</head>

<body data-type="login" class="theme-white">
    <script src="/js/theme.js"></script>
    <div class="am-g tpl-g">
        风格切换
        <div class="tpl-skiner">
            <div class="tpl-skiner-toggle am-icon-cog">
            </div>
            <div class="tpl-skiner-content">
                <div class="tpl-skiner-content-title">
                    选择主题
                </div>
                <div class="tpl-skiner-content-bar">
                    <span class="skiner-color skiner-white" data-color="theme-white"></span>
                    <span class="skiner-color skiner-black" data-color="theme-black"></span>
                </div>
            </div>
        </div>
        <div class="tpl-login">
            <div class="tpl-login-content">
                <div class="tpl-login-title">注册用户</div>
                <span class="tpl-login-content-info">
                  创建一个新的用户
              </span>


                <form class="am-form tpl-form-line-form">
                   

                    <div class="am-form-group">
                        <input type="text" class="tpl-form-input" id="username" name="username" placeholder="用户名">
                    </div>

                    <div class="am-form-group">
                        <input type="password" class="tpl-form-input" id="password" name="password" placeholder="请输入密码">
                    </div>

                    <div class="am-form-group tpl-login-remember-me">
                        <input id="remember-me" type="checkbox">
                        <label for="remember-me">
       
                        我已阅读并同意 <a href="javascript:;">《用户注册协议》</a> 
                         </label>

                    </div>


                    <div class="am-form-group">

                        <button type="button" class="am-btn am-btn-primary  am-btn-block tpl-btn-bg-color-success  tpl-login-btn" onclick="regist();">注册</button>

                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="/js/amazeui.min.js"></script>
    <script src="/js/app.js"></script>
    <script type="text/javascript" src="/js/jquery.js"></script>
	<script type="text/javascript" src="/js/json2.js"></script>
	<script type="text/javascript">
    function regist(){
    	var param={
			username:$('#username').val(),
			password:$('#password').val()
		};
			$.post('/user/Register.do',param,callback);
	}
    
	function callback(data,status){
		alert("确认");
		var ajaxDAO=data;
		if(ajaxDAO.success){
			window.location.href='/user/toLogin.do';
		}
		else{
			alert(ajaxDAO.message);
			return false;
			}
		}
	
	
	</script>


	</html>
		