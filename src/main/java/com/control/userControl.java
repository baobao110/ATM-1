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
	}//����֮����Ҫ��һ���˳�������Ϊ��ʹ�ỰʧЧ,��Ȼ�Ƴ�����url��ַ���ɿ���������¼�������
	
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
	            os.write("<script type=\"text/javascript\">parent.loadAvatar();</script>".getBytes());//����������������ʽ��js����,����ע��parent.loadAvatar();
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
		    	 File loadedFile = new File(src+"/load/" +  fileName);//���ﴴ���ļ���������ϴ��ļ���ʵ�ʴ�ŵ�ַ
		    	 file.transferTo(loadedFile);//transferTo(�ϴ��ļ��Ĵ��·��)
		    	 System.out.println("vvvvvvvv");
		    	 return toUsercenter(req, resp);
		    	 return "redirect:/user/toUsercenter.do";
			}
			return toUsercenter(req, resp);
		return "redirect:/user/toUsercenter.do";
	}*/
	/*
	 * ������ϴ������ʽ�̶�ֻ��Ҫ����Ҫ�󴴽���ͬ���ļ����ڵ�ַ�Ϳ�����,
	 * ����Ҫ�ر�ע���һ������ڸı��ļ���·��ʱ��Ҫע��loadedFile��·����Ҫ�ı䲻Ȼ�Ļ����������ʱ������Ҳ���·�������
	 * �����������ı�ͼƬ��·��,ǰ�˺ͺ�̨�Լ�spring-MVC��xml�ļ�����ص�ͼƬ·����Ҫ�ı�
	 * ͬʱע�������Spring-MVC���ض��� redirect:url,֮����ʹ���ض�����Ϊ�����¸���ָ����ַ
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
		HttpSession session=req.getSession();//�����һ��֪ʶ�����session��request������һ����ȫ�ֱ���һ���Ǿֲ�����
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
		javax.servlet.http.HttpSession session = req.getSession();//����н��и�ֵ����ԭ����Session�����û�д����µ�Session
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
			return ajaxDAO.failure("ע��ʧ��");
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
			return ajaxDAO.failure("��¼ʧ��");
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
			return ajaxDAO.failure("�޼�¼");
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
	}//������Ҫ��session��ȡuser,��Ȼ�޷�ͨ��������
	
	@RequestMapping("/toFlow")
	@ResponseBody
	public ajaxDAO toFlow(HttpServletRequest req,HttpServletResponse resp, String currentPage)throws ServletException, IOException{
		javax.servlet.http.HttpSession session = req.getSession();
		User user= (User) session.getAttribute("user");//�������Ҫ��session��ȡuser��Ȼ�û�����ҳ���޷����ر�
		String username=user.getUsername();
		System.out.println("-----username----"+username);
		/*resp.setContentType("text/html;charset=utf-8");
		resp.setCharacterEncoding("utf-8");//����ע��resp����������
*/		currentPage=currentPage ==null ? "1" : currentPage;//ע������ķ�ҳ��̨ʵ��
		Fenye list=cardservice.list(username, Integer.parseInt(currentPage));
		return ajaxDAO.success(list);
		
	}
	

}
