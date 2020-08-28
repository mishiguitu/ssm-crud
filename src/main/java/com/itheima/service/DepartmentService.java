package com.itheima.service;

import com.itheima.bean.Department;
import com.itheima.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 19798
 * @version 1.0
 * @ClassName DepartmentService
 * @description TODO
 * @date 2020/7/22 11:34
 */
@Service
public class DepartmentService {
    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department>  getDepts(){
        return departmentMapper.selectByExample(null);
    }
}
