package com.control;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
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
import org.apache.ibatis.annotations.ResultMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.AccountFlow.Account;
import com.BankCard.Card;
import com.ajax.ajaxDAO;
import com.fenye.Fenye;
import com.service.CardService;
import com.service.Service;
import com.user.User;


@Controller	//这里的注入写法固定,SpringMVC会自动根据注入找到Control类
@RequestMapping("/card")//这里就比较有意思,SpringMVC中这个注解是获取前端的url地址片,根据url地址找到相应的类和方法进行相应的操作
public class cardControl extends control{
	
	@Autowired	//这个注解程序会自动找到相关的类,进行自动的初始化,这样就不需要用set方法进行初始化,这里可以结合Service层的@Component
	private Service service;
	
	@Autowired
	private CardService cardservice;
	
	@RequestMapping("/down")
	public void down(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		// TODO Auto-generated method stub
		javax.servlet.http.HttpSession session = req.getSession(); 
		User user=(User) session.getAttribute("user");
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		String password=req.getParameter("password");
		Card cad=service.Get(number, password);
		String filename = number + ".csv";
		resp.setContentType("application/octet-stream");  
		resp.setHeader("Content-Disposition", "attachment;filename="+ filename);  
		
		try (BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(resp.getOutputStream()))) {
			int currentPage = 1;
			String header = "卡号,金额,备注,时间";
			bw.write(header);
			bw.newLine();
			bw.flush();
			while (true) {
				Fenye list = service.List(number, password, currentPage);
				System.out.println(currentPage);
				 ArrayList<Account>account=(ArrayList<Account>) list.getObject();
				if(null==account) {
					break;
				}
				if(account.isEmpty()) {//这里特别注意不然不能下载完成
					break;
				}
				for(Account i:account) {
					StringBuilder text = new StringBuilder();
					text.append(i.getNumber()).append(",")
					.append(i.getMoney()).append(",")
					.append(i.getDescription()).append(",")
					.append(i.getCreatetime()).append(",");
					bw.write(text.toString());
					bw.newLine();
					bw.flush();
					}
				System.out.println(111);
				currentPage++;
			}
		}
	}

	
	@RequestMapping("/toDelete")
	public String toDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		req.setAttribute("number", number);
		return "delete";
	}
	
	@RequestMapping("/delete")
	public String delete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		javax.servlet.http.HttpSession session = req.getSession();
		User user=(User)session.getAttribute("user");
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		String password=req.getParameter("password");
		Card cad=service.Get(number,password);
		if(cad==null) {
			return "failure";
		}
		else {
			service.delete(number);
			session.setAttribute("user",user);
			return toUsercenter(req, resp);
		}
	}
	
	@RequestMapping("/openAccount")
	public String openAccount(HttpServletRequest req, HttpServletResponse resp,HttpSession session) throws ServletException, IOException {
		User user=(User) session.getAttribute("user");
		String username=user.getUsername();
		String password=req.getParameter("password");
		Card card=service.open(username,password);
		req.setAttribute("card", card);//这里是通过键值对的形式存储相关的数值,对于Attribute属性有set方法也有get方法这里可以和Parameter参数区别
		return "success";
	}
	/*
	 * 注意这里的参数session,以前都是在方法中用request获取但是现在用Spring-MVC就简化了,可以在参数栏直接传入
	 */
	
	@RequestMapping("/toOpenAccount")
	public String toOpenAccount(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		javax.servlet.http.HttpSession session = req.getSession();
		return "OpenAccount";
	}
	
	@RequestMapping("/save")
	public String save(HttpServletRequest req, HttpServletResponse resp,HttpSession session) throws ServletException, IOException {
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		String password=req.getParameter("password");
		String b=req.getParameter("money");
		double money=Double.parseDouble(b);
		Card cad=service.Get(number,password);
		if(cad==null) {
			return "failure";
		}
		else {
			User user=(User)session.getAttribute("user");
			service.save(number, password, money,user.getUsername());
			Card card=service.Get(number,password);
			req.setAttribute("card", card);
			return "success";
		}
	}
	
	@RequestMapping("/toSave")
	public String  toSave(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		req.setAttribute("number", number);
		return "save";
	}
	
	@RequestMapping("/transfer")
	public String transfer(HttpServletRequest req, HttpServletResponse resp,HttpSession session) throws ServletException, IOException {
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		String password=req.getParameter("password");
		String b=req.getParameter("money");
		double money=Double.parseDouble(b);
		Card cad=service.Get(number,password);
		String c=req.getParameter("InNumber");
		int InNumber=Integer.parseInt(c);
		User user=(User)session.getAttribute("user");
		service.transfer(number, password, money, InNumber,user.getUsername());
		Card card1=service.GetCard(number);
		Card card2=service.GetCard(InNumber);
		if((card1==null)||(card2==null)) {
			return "failure";
		}
		else {
			req.setAttribute("card1", card1);
			req.setAttribute("card2", card2);
			return "success2";
		}
	}
	
	@RequestMapping("/toTransfer")
	public String toTransfer(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		req.setAttribute("number", number);
		return "transfer";
	}
	
	@RequestMapping("/check")
	public String  check(HttpServletRequest req, HttpServletResponse resp,HttpSession session) throws ServletException, IOException {
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		String password=req.getParameter("password");
		String b=req.getParameter("money");
		double money=Double.parseDouble(b);
		Card cad=service.Get(number,password);
		User user=(User)session.getAttribute("user");
		service.draw(number, password, money,user.getUsername());
		Card card=service.GetCard(number);
		if(card==null) {
			return "failure";
		}
		else {
			req.setAttribute("card", card);
			return "success";
		}
	}
	
	@RequestMapping("/toCheck")
	public String toCheck(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		req.setAttribute("number", number);
		return "check";
	}
	
	@RequestMapping("/list")
	@ResponseBody
	public ajaxDAO list(HttpServletRequest req, HttpServletResponse resp,String currentPage,String number,String password) throws ServletException, IOException {
				int num=Integer.parseInt(number);
				System.out.println("number"+num);
				System.out.println("password"+password);
				System.out.println("currentPage"+currentPage);
				/*resp.setContentType("text/html;charset=utf-8");
				resp.setCharacterEncoding("utf-8");*/
				currentPage=currentPage ==null ? "1" : currentPage;
				Fenye list = service.List(num, password, Integer.parseInt(currentPage));//获取记录
				return ajaxDAO.success(list);
		}
	
	@RequestMapping("/toList")
	public String toList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		req.setAttribute("number", number);
		return "list";
	
	}
	
	@RequestMapping("/toChangePassword")
	public String toChangePassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		req.setAttribute("number", number);
		return "password";
	}
	
	@RequestMapping("/password")
	public String  password(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		String oldPassword= req.getParameter("oldPassword");
		Card cad=service.Get(number,oldPassword);
		if(cad==null) {
			return "failure";
		}
		else {
			String newPassword= req.getParameter("newPassword");
			Card card=service.ChangePassword(number, oldPassword, newPassword);
			req.setAttribute("card", card);
			return "success";
		}
	}
	
	@RequestMapping("/toUsercenter")
	public String toUsercenter(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("--------");
		javax.servlet.http.HttpSession session = req.getSession();
		String username= (String) session.getAttribute("username");
		System.out.println(username);
		String currentPage = req.getParameter("currentPage");
		currentPage=currentPage ==null ? "1" : currentPage;//注意这里的分页后台实现
		Fenye list=cardservice.list(username, Integer.parseInt(currentPage));
		System.out.println("\\\\\\"+list);
		req.setAttribute("fenye", list);
		req.setAttribute("currentPage", Integer.parseInt(currentPage));
		req.setAttribute("username", username);
		return "usercenter";
	}
	
	@RequestMapping("/toInformation")
	public String toInformation	(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		String a=req.getParameter("number");
		int number=Integer.parseInt(a);
		req.setAttribute("number", number);
		return "information";
	}
	
	@RequestMapping("/information")
	public String information(HttpServletRequest req,String number,String password)throws ServletException, IOException {
		Card card=service.Get(Integer.parseInt(number),password);
		if(card==null) {
			return "failure";
		}
		else {
			req.setAttribute("card",card);
		}
		return "success3";
	}

	/*
	 * 注意这里的方法参数,其中的number和password必须和前端的name一样,
	 * 必须和前端的要取的数据名相同,但是因为都是从前端获取的所以必须都定义为String类型
	 * 这里可以结合information。jsp页面看就懂了,这也是Spring-MVC的用法特色,获取前端的数据
	 * 不需要用request获取,可以直接获取但是参数必须和前端的name相同
	 */
}
