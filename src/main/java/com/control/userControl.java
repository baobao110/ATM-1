package com.control;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.WebUtils;

import com.AccountFlow.Account;
import com.ajax.ajaxDAO;
import com.fenye.Fenye;
import com.flow.flow;
import com.service.CardService;
import com.service.Service;
import com.service.UserService;
import com.user.User;


@Controller
@RequestMapping("/user")
public class userControl extends control {
	
	@Autowired
	private Service service;
	
	@Autowired
	private UserService userservice;
	
	@Autowired
	private CardService cardservice;
	
	@RequestMapping("/back")
	public String back(HttpSession session) {
		session.invalidate();
		return "login";
	}//这里之所以要加一个退出方法是为了使会话失效,不然推出根据url地址依旧可以跳过登录步骤进入
	
	@RequestMapping("/load")
	public void load( MultipartFile file,HttpSession session,HttpServletRequest req, HttpServletResponse resp) throws Exception, IOException { 
		User user = (User)session.getAttribute("user");
		String username=user.getUsername();
		req.setAttribute("username", username);
		try {
			if (!file.isEmpty()) {
	            String filePath = WebUtils.getRealPath(session.getServletContext(), "/load/" +username);
	            File uploadedFile = new File(filePath);
	            file.transferTo(uploadedFile);
	            
	            OutputStream os = resp.getOutputStream();
	            os.write("<script type=\"text/javascript\">parent.loadAvatar();</script>".getBytes());//这里以数据流的形式传js代码,这里注意parent.loadAvatar();
	            os.flush();
	            os.close();
	        }
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	/*@RequestMapping("/load")
	public String load( String name, MultipartFile file,HttpSession session,HttpServletRequest req, HttpServletResponse resp) throws Exception, IOException { 
		User user = (User)session.getAttribute("user");
		String username=user.getUsername();
		req.setAttribute("username", username);
		if (!file.isEmpty()) {
		            byte[] bytes = file.getBytes();
		        	String src = req.getServletContext().getRealPath("/");
		    		
		    		String path=null;
		    		
		    		if(src.endsWith(File.separator)) {
		    			path="WEB-INF";
		    		}
		    		else {
		    			path="/WEB-INF";
		    		}
		    		
			     String fileName = "" + user.getUsername();
		    	 File loadedFile = new File(src+"/load/" +  fileName);//这里创建文件保存的是上传文件的实际存放地址
		    	 file.transferTo(loadedFile);//transferTo(上传文件的存放路径)
		    	 System.out.println("vvvvvvvv");
		    	 return toUsercenter(req, resp);
		    	 return "redirect:/user/toUsercenter.do";
			}
			return toUsercenter(req, resp);
		return "redirect:/user/toUsercenter.do";
	}*/
	/*
	 * 这里的上传程序格式固定只需要根据要求创建不同的文件存在地址就可以了,
	 * 这里要特别注意的一点就是在改变文件的路径时需要注意loadedFile的路径需要改变不然的话浏览器加载时会出现找不到路径的情况
	 * 因此这里如果改变图片的路径,前端和后台以及spring-MVC。xml文件的相关的图片路径都要改变
	 * 同时注意这里的Spring-MVC的重定向 redirect:url,之所以使用重定向是为了重新给它指定地址
	 */
	
	@RequestMapping("/toUpload")
	public String toUpload(HttpSession session) {
		return "load";
	}

	
	/* @RequestMapping("/showPicture")
	public void showPicture(HttpServletRequest req, HttpServletResponse resp) throws FileNotFoundException, IOException {
		// TODO Auto-generated method stub
		String src=req.getServletContext().getRealPath("/");
		System.out.println(">>>>>>>"+src);
		HttpSession session=req.getSession();//这里的一个知识点就是session和request的区别一个是全局变量一个是局部变量
		User user=(User)session.getAttribute("user");

		String path=null;
		
		if(src.endsWith(File.separator)) {
			path="WEB-INF";
		}
		else {
			path="/WEB-INF";
		}
		try (FileInputStream in = new FileInputStream(src+path+"/load/" + user.getUsername());
				OutputStream out = resp.getOutputStream()) {
			byte[] data = new byte[1024];
			int length = -1;
			while((length=in.read(data))!=-1) {
				out.write(data, 0, length);
				out.flush();
			}
		}
	}*/
	
	@RequestMapping("/toRegister")
	public String  toRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		javax.servlet.http.HttpSession session = req.getSession();//如果有进行赋值就是原来的Session，如果没有创建新的Session
		System.out.println("ddddddd");
		System.out.println("session"+session);
		return "register";
	
	}
	
	@RequestMapping("/Register")
	@ResponseBody
	public ajaxDAO Register(String username, String password,HttpSession session) throws ServletException, IOException {
		User user= userservice.register(username,password);
		session.setAttribute("user",user);
		System.out.println("user"+user);
		if(user==null) {
			return ajaxDAO.failure("注册失败");
		}
		else {
			session.setAttribute("user",user);
			return ajaxDAO.success();
		}
	}
	
	
	@RequestMapping("/toLogin")
	public String toLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("zzzzzzz");
		javax.servlet.http.HttpSession session = req.getSession();
		System.out.println("session1"+session);
		return "login";																																								
	}
	
	@RequestMapping("/login")
	@ResponseBody
	public ajaxDAO  login(String username, String password,HttpSession session) throws ServletException, IOException {
		System.out.println("ccccccc");
		User user=userservice.login(username, password);
		session.setAttribute("user", user);
		if(null==user) {
			return ajaxDAO.failure("登录失败");
		}
		else {
			return ajaxDAO.success();
		}
	}
	
	@RequestMapping("/ten")
	@ResponseBody
	public ajaxDAO ten(HttpSession session,HttpServletRequest req) throws ServletException, IOException {
		System.out.println("ccccccc");
		User user=(User)session.getAttribute("user");
		System.out.println("user------"+user);
		String username=user.getUsername();
		req.setAttribute("username", username);
		System.out.println(username);
		ArrayList<flow> account=service.ten(username);
		if(null==account) {
			return ajaxDAO.failure("无记录");
		}
		else {
			System.out.println("success");
			return ajaxDAO.success(account);
		}
		
	}
	
	@RequestMapping("/toUsercenter")
	public String toUsercenter(HttpServletRequest req,HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session=req.getSession();
		User user=(User)session.getAttribute("user");
		System.out.println("user------"+user);
		String username=user.getUsername();
		req.setAttribute("username", username);
		System.out.println(username);
		return "usercenter";
	}//这里需要从session中取user,不然无法通过过滤器
	
	@RequestMapping("/toFlow")
	@ResponseBody
	public ajaxDAO toFlow(HttpServletRequest req,HttpServletResponse resp, String currentPage)throws ServletException, IOException{
		javax.servlet.http.HttpSession session = req.getSession();
		User user= (User) session.getAttribute("user");//这里必须要用session获取user不然用户中心页面无法加载表单
		String username=user.getUsername();
		System.out.println("-----username----"+username);
		/*resp.setContentType("text/html;charset=utf-8");
		resp.setCharacterEncoding("utf-8");//这里注意resp这两句必须加
*/		currentPage=currentPage ==null ? "1" : currentPage;//注意这里的分页后台实现
		Fenye list=cardservice.list(username, Integer.parseInt(currentPage));
		return ajaxDAO.success(list);
		
	}
	

}
