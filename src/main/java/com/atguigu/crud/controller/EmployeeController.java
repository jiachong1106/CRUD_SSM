package com.atguigu.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.service.EmployeeService;
import com.atguigu.crud.utils.Msg;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class EmployeeController {
	@Autowired
	EmployeeService employeeService;
	
	/**
	 * 批量删除员工
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value ="/emp/{ids}",method=RequestMethod.DELETE)
	public Msg delEmp(@PathVariable("ids")String ids) {
		if(ids.contains("-")) {
			List<Integer> del_ids = new ArrayList<Integer>();
			String[] str_ids=ids.split("-");
			for (String string : str_ids) {
				del_ids.add(Integer.parseInt(string));
			}
			employeeService.delBatch(del_ids);
		}else {
			Integer id=Integer.parseInt(ids);
			employeeService.delEmp(id);
		}
		return Msg.success();
	}
	
		/**
		 * 根据id单个删除员工
		 * @param id
		 * @return
		 */
//		@ResponseBody
//		@RequestMapping(value ="/emp/{id}",method=RequestMethod.DELETE)
//		public Msg delEmp(@PathVariable("id")Integer id) {
//			System.out.println(id);
//			employeeservice.delEmp(id);
//			return Msg.success();
//		}
		
		/**
		 * 如果直接发送ajax=PUT形式的请求，封装的数据
		 * 		Employee [empId=1014, empName=null, gender=null, email=null, dId=null]
		 * 
		 * 问题：
		 * 请求体中有数据；但是Employee对象封装不上；
		 * 		update tbl_emp  where emp_id = 1014;
		 * 
		 * 原因：
		 * Tomcat：
		 * 		1、将请求体中的数据，封装一个map。
		 * 		2、request.getParameter("empName")就会从这个map中取值。
		 * 		3、SpringMVC封装POJO对象的时候。
		 * 				会把POJO中每个属性的值，request.getParamter("email");
		 * AJAX发送PUT请求引发的血案：
		 * 		PUT请求，请求体中的数据，request.getParameter("empName")拿不到
		 * 		Tomcat一看是PUT不会封装请求体中的数据为map，只有POST形式的请求才封装请求体为map
		 * org.apache.catalina.connector.Request--parseParameters() (3111);
		 * 
		 * protected String parseBodyMethods = "POST";
		 * if( !getConnector().isParseBodyMethod(getMethod()) ) {
		            success = true;
		            return;
		        }
		 * 
		 * 
		 * 解决方案；
		 * 我们要能支持直接发送PUT之类的请求还要封装请求体中的数据
		 * 1、配置上HttpPutFormContentFilter；
		 * 2、他的作用；将请求体中的数据解析包装成一个map。
		 * 3、request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据
		 * 更新员工信息
		 * @param id
		 * @return
		 */
		@ResponseBody
		@RequestMapping(value ="/emp/{empId}",method=RequestMethod.PUT)
		public Msg updateEmp(Employee employee) {
			System.out.println(employee);
			employeeService.updateEmp(employee);
			return Msg.success();
		}
		
		/**
		 * 获取员工信息
		 * @param id
		 * @return
		 */
		@ResponseBody
		@RequestMapping(value ="/emp/{id}",method=RequestMethod.GET)
		public Msg getEmp(@PathVariable("id")Integer id) {
			Employee emp=employeeService.getEmp(id);
			return Msg.success().add("emp", emp);
		}
		
		
		/**
		 * 员工名字是否重复校验
		 * @param empName
		 * @return
		 */
		@ResponseBody
		@RequestMapping("/checkuser")
		public Msg checkUser(@RequestParam("empName")String empName) {
			String regx="^[a-zA-Z0-9_-]{6,16}$|^([\\u2E80-\\u9FFF]{2,5})$";
			if(!empName.matches(regx)) {
				return Msg.fail().add("va_msg", "用户名需要是6-16位英文或2-5位中文");
			}
			Boolean b = employeeService.checkUser(empName);
			if(b) {
				return Msg.success();
			}else {
				return Msg.fail().add("va_msg", "用户名重复");
			}
		}
		/**
		 * 新增员工
		 * @param employee
		 * @return
		 */
		@ResponseBody
		@RequestMapping(value ="/emp",method=RequestMethod.POST)
		public Msg saveEmp(@Valid Employee employee,BindingResult result) {
			if(result.hasErrors()) {
				//校验失败，应该返回失败，在模态框中显示校验失败的错误信息
				Map<String, Object> map = new HashMap<>();
				List<FieldError> errors = result.getFieldErrors();
				for (FieldError fieldError : errors) {
					System.out.println("错误的字段名："+fieldError.getField());
					System.out.println("错误信息："+fieldError.getDefaultMessage());
					map.put(fieldError.getField(), fieldError.getDefaultMessage());
				}
				return Msg.fail().add("errorFields", map);
			}else {
				employeeService.saveEmp(employee);
				return Msg.success();
			}
		}
		/**
		 * 查询员工，分页展示
		 * @param pn
		 * @return
		 */
		@ResponseBody
		@RequestMapping("/emps")
		public Msg getEmpJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
			//引入PageHelper插件
			//传入起始页码及每页的记录数
			PageHelper.startPage(pn, 5);
			//startPage后紧跟的查询就是分页查询
			List<Employee> emps = employeeService.getAll();
			//用PageInfo对结果进行包装,同时传入要连续显示的页数
			PageInfo page = new PageInfo(emps, 5);
			return Msg.success().add("pageInfo", page);
		}

	//@RequestMapping("/emps")
	public String getEmp(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
		//引入PageHelper插件
		//传入起始页码及每页的记录数
		PageHelper.startPage(pn, 5);
		//startPage后紧跟的查询就是分页查询
		List<Employee> emps = employeeService.getAll();
		//用PageInfo对结果进行包装,同时传入要连续显示的页数
		PageInfo page = new PageInfo(emps, 5);
		//将page里的信息传回给页面
		model.addAttribute("pageInfo", page);
		return "list";
	}
}
