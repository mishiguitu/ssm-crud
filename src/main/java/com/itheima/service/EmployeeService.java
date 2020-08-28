package com.itheima.service;

import com.itheima.bean.Employee;
import com.itheima.bean.EmployeeExample;
import com.itheima.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 19798
 * @version 1.0
 * @ClassName EmployeeService
 * @description TODO
 * @date 2020/7/21 14:27
 */
@Service
public class EmployeeService {
    @Autowired
    private EmployeeMapper employeeMapper;


    public List<Employee> getAll(){
        return  employeeMapper.selectByExampleWithDept(null);
    }

    public void saveEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    public boolean checkUser(String empName) {
        EmployeeExample employeeExample=new EmployeeExample();
        //创建一个查询条件
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        //创建于参数相等的条件
        criteria.andEmpNameEqualTo(empName);
        //查询是否有这样的条件，员工姓名与传入的empName相等，有则返回记录数
        long count=employeeMapper.countByExample(employeeExample);
        return count==0 ? true:false;


    }


    public Employee getEmployeeById(int id) {
        return employeeMapper.selectByPrimaryKey(id);
    }

    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    public void deleteEmpById(int id) {
        employeeMapper.deleteByPrimaryKey(id);
    }

    public void deleteBatch(List<Integer> id_list) {
        EmployeeExample employeeExample=new EmployeeExample();
        EmployeeExample.Criteria criteria=employeeExample.createCriteria();
        //andEmpIdIn这个方法判断id是否在一个list中
        //拼装的sql  delete from xxx where emp_id in 集合
        criteria.andEmpIdIn(id_list);
        employeeMapper.deleteByExample(employeeExample);

    }
}
