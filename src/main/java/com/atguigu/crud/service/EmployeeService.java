package com.atguigu.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.EmployeeExample;
import com.atguigu.crud.bean.EmployeeExample.Criteria;
import com.atguigu.crud.dao.EmployeeMapper;
@Service
public class EmployeeService {
	@Autowired
	EmployeeMapper employeeMapper;

	public List<Employee> getAll() {
		//指定排序的列
		EmployeeExample example=new EmployeeExample();
		example.setOrderByClause("emp_id");
		return employeeMapper.selectByExampleWithDept(example);
	}
	
	public int saveEmp(Employee employee) {
		return employeeMapper.insertSelective(employee);
	}

	public Boolean checkUser(String empName) {
		EmployeeExample example = new EmployeeExample();
		Criteria createCriteria = example.createCriteria();
		createCriteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		return count==0;
	}

	public Employee getEmp(Integer id) {
		return employeeMapper.selectByPrimaryKey(id);
	}

	public void updateEmp(Employee employee) {
		 employeeMapper.updateByPrimaryKeySelective(employee);
	}

	public void delEmp(Integer id) {
		System.out.println(id);
		employeeMapper.deleteByPrimaryKey(id);
	}

	public void delBatch(List<Integer> ids) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpIdIn(ids);
		employeeMapper.deleteByExample(example);
	}
}
