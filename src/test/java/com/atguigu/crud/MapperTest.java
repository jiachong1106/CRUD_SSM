package com.atguigu.crud;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.atguigu.crud.bean.Department;
import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.dao.EmployeeMapper;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
	@Autowired
	DepartmentMapper departmentMapper;
	@Autowired
	EmployeeMapper employeeMapper;
	@Autowired
	SqlSession sqlsession;
	@Test
	 public void testCRUD() {
         System.out.println(departmentMapper);
         departmentMapper.selectByPrimaryKey(1);
		/*
		departmentMapper.insertSelective(new Department(null, "开发部") );
		departmentMapper.insertSelective(new Department(null, "测试部") );*/
    //     employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@163.com", 1));
        
         //批量插入员工
         //方法1：效率较低
		/*  for() {
			 employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@163.com", 1)); 
		 }*/
         //方法2：使用可以批量操作的sqlsession
		/*   EmployeeMapper mapper = sqlsession.getMapper(EmployeeMapper.class);
		 for(int i=0;i<10;i++) {
			 String uuid = UUID.randomUUID().toString().substring(0, 5)+i;
			 mapper.insertSelective(new Employee(null, uuid, "M", uuid+"@163.com", 1));
		 }
		 System.out.println("插入成功");*/
	}
}
