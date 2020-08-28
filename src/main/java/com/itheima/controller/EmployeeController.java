package com.itheima.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.itheima.bean.Department;
import com.itheima.bean.Employee;
import com.itheima.bean.Msg;
import com.itheima.service.DepartmentService;
import com.itheima.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author 19798
 * @version 1.0
 * @ClassName EmployeeController
 * @description TODO
 * @date 2020/7/21 14:21
 */
@Controller
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private DepartmentService departmentService;


//    一次查询1000条数据,一个页面展示不下，所以需要分页处理,前端返回一个页面，没有默认1
//    @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn, Model model){
//        引入PageHelper分页插件,下面方法是从第几页开始查，每页查多少
        PageHelper.startPage(pn,5);
//   startPage后面紧跟的查询会被认为一个分页查询
        List<Employee> employees=employeeService.getAll();
//使用PageInfo包装查询后的总结果,只需要将PageInfo交给页面,第二个构造参数是要展示的页数
        PageInfo page=new PageInfo(employees,5);

        model.addAttribute("pageInfo",page);
        return "list";

    }

//@ResponseBody 注解表示页面发出请求时，我们返回一个PageInfo的对象
//@ResponseBody要能正常工作，需要导入jackSon包，
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1" )Integer pn) {
        PageHelper.startPage(pn,5);
        List<Employee> employees=employeeService.getAll();
        PageInfo page=new PageInfo(employees,5);
        return Msg.success().add("pageInfo",page);
    }

    @RequestMapping("/depts")
    @ResponseBody
    public Msg getDepts(){
        List<Department> departments=departmentService.getDepts();
        return Msg.success().add("depts",departments);
    }


//    定义员工保存，使用POST请求
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
        //校验失败，要在前端模态框显示信息,BindingResult是返回的错误信息
            //获取所有失败的信息
            Map<String,Object> map=new HashMap<>();
            List<FieldError> errors=result.getFieldErrors();
            for (FieldError error : errors) {
                //遍历errors，显示所有错误的字段
                System.out.println("错误字段名"+error.getField());
                System.out.println("错误信息"+error.getDefaultMessage());
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else{

            employeeService.saveEmp(employee);
            return Msg.success();
        }

    }


    @RequestMapping(value = "/checkuser")
    @ResponseBody
    public Msg checkUser(@RequestParam("empName") String empName){
        boolean b=employeeService.checkUser(empName);
        if(b){
            return Msg.success();
        }else{
            return Msg.fail();
        }
    }

//  @PathVariable表示这个id变量是从路径中取出id占位符的值
    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    public Msg getEmployeeById(@PathVariable(value = "id") int id){
        Employee employee=employeeService.getEmployeeById(id);
       return  Msg.success().add("emp",employee);
    }


    /**
     * @description:如果直接使用ajax发送put请求，问题，请求体中有数据，Employee对象封装不了，sql语句中没有set的数据
     * sql 语句变成这个样子 update tbl_emp set  where emp_id=#{empId}
     * 原因：Tomcat，
     * 1.将所有请求数据封装一个Map
     * 2.request.getParameter("empName")就从Map中获取
     * 3. springMVC封装pojo对象时，会把pojo对象的每个属性值使用request.getParameter获取
     * Ajax发送put请求，Tomcat看到是put请求就不封装请求体中的数据
     *
     * 解决方法
     *
     * 配置上HttpPutFormContentFilter；
     * 他的作用；将请求体中的数据解析包装成一个map。
     * request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据
     */
    //根据id更新员工，更新需要提交一个Employee对象Rest风格,提交的信息中没有员工id，所以在提交的连接中加上员工id，否则无法用id更新
    //保存员工的表单中也没有id属性，传进来的employee对象中id=null，但是插入可以不用id
    //{empId}必须与实体类id数属性名相同，否则无法赋值
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg updateEmp(Employee employee){
        System.out.println(employee.toString());
        employeeService.updateEmp(employee);
        return Msg.success();

    }
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    //@PathVariable 将路径中id变量值赋给函数参数id
    public Msg deleteEmpById(@PathVariable("ids") String ids){
       String[] str_ids =ids.split("-");
        System.out.println(str_ids);
       if(str_ids.length==1){
           employeeService.deleteEmpById(Integer.parseInt(str_ids[0]));
       }else if(str_ids.length>1){
           List<Integer> id_list=new ArrayList<>();
           for (String str_id : str_ids) {
               id_list.add(Integer.parseInt(str_id));

           }
           employeeService.deleteBatch(id_list);
       }

        return Msg.success();

    }


}
