<%-- <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>

<jsp:include page="common/head.jsp"></jsp:include>

<body>
<h1>个人中心页面</h1>
<!-- <img src="/user/showPicture.do" width="66px" height="66px" onerror="javascript:this.src='/images/dayuan.jpg';" ><br> -->
<!--这里的图片展示用spring-MVC的方法,从这里也可以知道spring-MVC的整个执行流程,先到web.xml文件中根据配置文件找到spring-MVC.xml文件路径,进入spring-MVC。xml文件后再根据ur地址执行相关的操作  -->
<a href="/user/toUpload.do"><img src="/resources/show/${username}" width="66px" height="66px" onerror="javascript:this.src='/images/dayuan.jpg';" id='picture'></a><br>
用户名：${user.username}
<input type="hidden" id="username" value="${user.username}">
<a href="/card/toOpenAccount.do" target="_blank">开户</a><br>
<a href="/user/back.do" target="_blank">退出</a><br>
</body>
		<button onclick="ten()">十条记录</button><br>
		<button onclick="first()">首页</button>
		<button onclick="pre()">上一页</button>
		<button onclick="next()">下一页</button>
		<button onclick="last()">尾页</button>
		<span id="pag">1/0</span>
<table id="table">
	
</table>

<table id="list">

</table>

<jsp:include page="common/foot.jsp"></jsp:include>
</body>

<script type="text/javascript" src="/js/jquery-3.2.1.js"></script>
<script type="text/javascript" src="/js/json2.js"></script>
<script type="text/javascript">

	var currentPage = 1;
	
	var totalPage = 0;
	/* 这里需要注意分页技术的前端实现 ，注意false返回 */
	
	function next() {
		if (currentPage == totalPage) {
			return false;
		}
		
		currentPage = parseInt(currentPage) + 1;
		flow();
		/* window.location.href='/user/toUsercenter.do?currentPage=' + currentPage; */
	}

	function pre() {
		
		if (currentPage == 1) {
			return false;
		}
		
		currentPage = parseInt(currentPage) - 1;
		flow();
		/* window.location.href='/user/toUsercenter.do?currentPage=' + currentPage; */
	}

	function first() {
		currentPage = 1;
		flow();
	/* 	window.location.href='/user/toUsercenter.do?currentPage=' + currentPage; */
	}

	function last() {
		currentPage = totalPage;
		flow();
		/* window.location.href='/user/toUsercenter.do?currentPage=' + currentPage; */
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
		}
	/* 注意该方法是对JSON时间格式转换 ,这个方法其实就是js中的日期操作,这里就是获取后台的日期将它转换为Date,之后用js的相关的时间函数获取时间进行字符窜的拼接*/
	
	function flow(){
		var param={
			currentPage:currentPage
		};
		$.post('/user/toFlow.do',param,callback);
	}
	
	function callback(data,status){
		alert("点击");
		/* var ajaxDAO=JSON.parse(data); */
		var ajaxDAO=data;
		alert(ajaxDAO);
		var result=ajaxDAO.data.object;
		var msg='<tr><td>卡号</td><td>时间</td><td>手续</td></tr>';
		for (var i=0; i<result.length;i++) {
			msg+='<tr>';
			msg+='<td>'+result[i].number+'</td>';
			msg+='<td>'+ getNowFormatDate(new Date(result[i].createtime))+'</td>';
			msg+='<td>';
			msg+='<a href="/card/toSave.do?number='+result[i].number+'" target="_blank">存钱</a>';	
			msg+='<a href="/card/toCheck.do?number='+result[i].number+'" target="_blank">取钱</a>';	
			msg+='<a href="/card/toTransfer.do?number='+result[i].number+'" target="_blank">汇款</a>';	
			msg+='<a href="/card/toList.do?number='+result[i].number+'" target="_blank">交易</a>';	
			msg+='<a href="/card/toChangePassword.do?number='+result[i].number+'" target="_blank">修改密码</a>';	
			msg+='<a href="/card/toDelete.do?number='+result[i].number+'" target="_blank">销户</a>';
			msg+='<a href="/card/toInformation.do?number='+result[i].number+'" target="_blank">查询余额</a>';
			msg+='</td></tr>';
		}
		totalPage = ajaxDAO.data.totalPage;
		$('#table').html(msg);
		$('#pag').html(currentPage+ '/' + totalPage);
	}
	
	function ten(){
		var param={
			};
			$.post('/user/ten.do',param,call);
	}
	
	function call(data,status){
		alert("点击");
		/* var ajaxDAO=JSON.parse(data); */
		var ajaxDAO=data;
		alert(ajaxDAO);
		var result=ajaxDAO.data.object;
		var msg='<tr><td>卡号</td><td>时间</td><td>金额</td></tr>';
		for (var i=0; i<result.length; i++) {
			msg+='<tr>';
			msg+='<td>'+result[i].number+'</td>';
			msg+='<td>'+ getNowFormatDate(new Date(result[i].createtime))+'</td>';
			msg+='<td>'+result[i].money+'</td>';
			msg+='</tr>';
		}
		$('#list').html(msg);
	}
		
	
	$(document).ready(function(){
		flow();
		$('#picture').attr('src',"/resources/show/${username}?"+new Date().getTime());	
	});
	/* 注意这里可以避免前端页面图片改变后需要重新加载的问题,因为服务器缓存的问题所以如果用强制刷新其实就是再次刷新,这里在url地址上传递参数就可以标示图片 */
	
	
</script>


</html>

<!-- 这里需要理解的就是$.post 先通过url地址将参数返回到后台后台再将数据返回单callback函数进行处理 --> --%>


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
    <link rel="apple-touch-icon-precomposed" href="/i/app-icon72x72@2x.png">
    <meta name="apple-mobile-web-app-title" content="Amaze UI" />
    <script src="/js/echarts.min.js"></script>
    <link rel="stylesheet" href="/css/amazeui.min.css" />
    <link rel="stylesheet" href="/css/amazeui.datatables.min.css" />
    <link rel="stylesheet" href="/css/app.css">

</head>

<body data-type="index" class="theme-white">
    
    <div class="am-g tpl-g">
        <!-- 头部 -->
        <header>
            <!-- logo -->
            <div class="am-fl tpl-header-logo">
                <a href="javascript:;"><img src="/img/logo.png" alt=""></a>
            </div>
            <!-- 右侧内容 -->
            <div class="tpl-header-fluid">
                <!-- 侧边切换 -->
               
                <!-- 搜索 -->
                
                <!-- 其它功能-->
                <div class="am-fr tpl-header-navbar">
                    <ul>
                        <!-- 欢迎语 -->
                        <li class="am-text-sm tpl-header-navbar-welcome">
                            <a href="javascript:;">欢迎你, <span>Amaze UI</span> </a>
                        </li>

                        <!-- 新邮件 -->

                        <!-- 新提示 -->

                        <!-- 退出 -->
                        <li class="am-text-sm">
                            <a href="javascript:;">
                                <span class="am-icon-sign-out"></span> 退出
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

        </header>
        <!-- 风格切换 -->
        
        <!-- 侧边导航栏 -->
        <div class="left-sidebar">
            <!-- 用户信息 -->
            <div class="tpl-sidebar-user-panel">
                <div class="tpl-user-panel-slide-toggleable">
                    

                    <div class="am-form-group am-form-file">
                        <div class="tpl-user-panel-profile-picture">
	                       <img src="/resources/show/${username}" width="66px" height="66px" onerror="javascript:this.src='/images/dayuan.jpg';" id='picture'><!--6 图片显示  -->
	                    </div>
                         <form id="avatarForm" method="POST" enctype="multipart/form-data" action="/user/load.do" target="avatarFrame"><!--3 到后台,注意target打开子窗口-->
                        	<input id="doc-form-file" type="file" name="file" onchange="upload();"><!-- 1 这里注意name的值要和后台一致 -->
                        </form>
                    </div>
                    
                    <a href="javascript:;" class="tpl-user-panel-action-link"> <span class="am-icon-pencil"></span> 账号设置</a>
                </div>
            </div>

            <!-- 菜单 -->
            <ul class="sidebar-nav">
                
                <li class="sidebar-nav-link">
                    <a href="index.html" class="active">
                        <i class="am-icon-home sidebar-nav-link-logo"></i> 首页
                    </a>
                </li>
                <li class="sidebar-nav-link">
                    <a href="openaccount.html">
                        <i class="am-icon-wpforms sidebar-nav-link-logo"></i> 开户
                    </a>
                </li>
                <li class="sidebar-nav-link">
                    <a href="draw.html">
                        <i class="am-icon-wpforms sidebar-nav-link-logo"></i> 取款
                    </a>
                </li>
                <li class="sidebar-nav-link">
                    <a href="deposit.html">
                        <i class="am-icon-wpforms sidebar-nav-link-logo"></i> 存款

                    </a>
                </li>
                <li class="sidebar-nav-link">
                    <a href="transfer.html">
                        <i class="am-icon-wpforms sidebar-nav-link-logo"></i> 转账

                    </a>
                </li>

                <li class="sidebar-nav-link">
                    <a href="flow.html">
                        <i class="am-icon-bar-chart sidebar-nav-link-logo"></i> 流水

                    </a>
                </li>

            </ul>
        </div>


        <!-- 内容区域 -->
        <div class="tpl-content-wrapper">

            <div class="row-content am-cf">
                <div class="row  am-cf" id="cardData">
                    
                    <div class="am-u-sm-12 am-u-md-6 am-u-lg-4">
                        <div class="widget widget-primary am-cf">
                            <div class="widget-statistic-header">
                                6222*****196
                            </div>
                            <div class="widget-statistic-body">
                                <div class="widget-statistic-value">
                                    ￥27,294
                                </div>
                                <div class="widget-statistic-description">
                                    
                                </div>
                                <span class="widget-statistic-icon am-icon-credit-card-alt"></span>
                            </div>
                        </div>
                    </div>

                    
                </div>

               

 <div class="am-u-sm-12 am-u-md-12 am-u-lg-6">
                        <div class="widget am-cf">
                            <div class="widget-head am-cf">
                                <div class="widget-title am-fl">最近十笔流水</div>
                                <div class="widget-function am-fr">
                                    
                                </div>
                            </div>
                            <div class="widget-body  widget-body-lg am-fr">

                                <table width="100%" class="am-table am-table-compact am-table-bordered am-table-radius am-table-striped tpl-table-black " id="example-r">
                                    <thead>
                                        <tr>
                                            <th>卡号</th>
                                            <th>时间</th>
                                            <th>金额</th>
                                            
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="gradeX">
                                            <td>Amaze UI 模式窗口</td>
                                            <td>张鹏飞</td>
                                            <td>2016-09-26</td>
                                            
                                        </tr>
                                        <tr class="even gradeC">
                                            <td>有适配微信小程序的计划吗</td>
                                            <td>天纵之人</td>
                                            <td>2016-09-26</td>
                                            
                                        </tr>
                                        <tr class="gradeX">
                                            <td>请问有没有amazeui 分享插件</td>
                                            <td>王宽师</td>
                                            <td>2016-09-26</td>
                                            
                                        </tr>
                                        
                                        <!-- more data -->
                                    </tbody>
                                </table>

                            </div>
                        </div>
                    </div>
                </div>



            </div>
        </div>
    </div>
    </div>
    
    <script src="/js/jquery.js"></script>
    <script src="/js/theme.js"></script>
    <script src="/js/amazeui.min.js"></script>
    <script src="/js/amazeui.datatables.min.js"></script>
    <script src="/js/dataTables.responsive.min.js"></script>
    <script src="/js/app.js"></script>
    <script type="text/javascript" src="/js/dayuanit.js"></script>
    
      <script type="text/javascript">
      
      function upload() {
  		$('#avatarForm').submit();
  		}/* 2 */
      
		var currentPage = 1;
		var totalPage = 0;
		
		/* function getNowFormatDate(day)
		{
		var day = new Date();
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
		}
	/* 注意该方法是对JSON时间格式转换 ,这个方法其实就是js中的日期操作,这里就是获取后台的日期将它转换为Date,之后用js的相关的时间函数获取时间进行字符窜的拼接*/
		function flow(){
			var param={
				/* currentPage:currentPage */
			};
			$.post('/user/toFlow.do',param,callback);
		}
		
		function callback(data,status){
			alert("点击");
			/* var ajaxDAO=JSON.parse(data); */
			var ajaxDAO=data;
			alert(ajaxDAO);
			var msg="";
			var result=ajaxDAO.data.object;
			for (var i=0; i<result.length;i++) {
				msg += '<div class="am-u-sm-12 am-u-md-6 am-u-lg-4">';
	        	msg += '<div class="widget widget-primary am-cf">';
	        	msg += '<div class="widget-statistic-header">';
	        	msg += result[i].number;
	        	msg += '</div>';
	        	msg += '<div class="widget-statistic-body">';
	        	msg += '<div class="widget-statistic-value">';
	        	msg += '￥' + result[i].money;
	        	msg += '</div>';
	        	msg += '<div class="widget-statistic-description">';
	        	msg += '</div>';
	        	msg += '<span class="widget-statistic-icon am-icon-credit-card-alt"></span>';
	        	msg += '</div>';
	        	msg += '</div>';
	        	msg += '</div>';
	        }
	        	
				/* msg+='<tr>';
				msg+='<td>'+result[i].number+'</td>';
				msg+='<td>'+ getNowFormatDate(new Date(result[i].createtime))+'</td>';
				msg+='<td>';
				msg+='<a href="/card/toSave.do?number='+result[i].number+'" target="_blank">存钱</a>';	
				msg+='<a href="/card/toCheck.do?number='+result[i].number+'" target="_blank">取钱</a>';	
				msg+='<a href="/card/toTransfer.do?number='+result[i].number+'" target="_blank">汇款</a>';	
				msg+='<a href="/card/toList.do?number='+result[i].number+'" target="_blank">交易</a>';	
				msg+='<a href="/card/toChangePassword.do?number='+result[i].number+'" target="_blank">修改密码</a>';	
				msg+='<a href="/card/toDelete.do?number='+result[i].number+'" target="_blank">销户</a>';
				msg+='<a href="/card/toInformation.do?number='+result[i].number+'" target="_blank">查询余额</a>';
				msg+='</td></tr>'; */
	    	$('#cardData').html(msg);
		}
		
		function ten(){
			var param={
				};
				$.post('/user/ten.do',param,call);
		}
		
		function call(data,status){
			alert("点击");
			/* var ajaxDAO=JSON.parse(data); */
			var ajaxDAO=data;
			alert(ajaxDAO);
			var result=ajaxDAO.data;
			var msg="<thead><tr> <th>卡号</th> <th>时间</th> <th>金额</th> <th>备注</th></tr>  </thead>";
			for (var i=0; i<result.length; i++) {
                 msg+='<tr class="gradeX">';
				msg+=' <td>'+result[i].number+'</td>';
				msg+='<td>'+ result[i].createtime+'</td>';
				msg+='<td>'+result[i].money+'</td>';
				msg+='<td>'+result[i].description+'</td>';
				msg+='</tr>';
			}
			$('#example-r').html(msg);
		}
		
		flow();
		ten();
		function loadAvatar() {
			$('#picture').attr('src',"/resources/show/${username}?"+new Date().getTime());	/* 5   对应的图片显示的src传参数 注意后面的时间戳  */
    	}
    	
    </script>
    
</body>

<iframe name="avatarFrame" width="100px" height="100px"><!-- 4 这里的子窗口注意和第三步target的对应 -->
</iframe>

</html>