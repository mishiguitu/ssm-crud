import com.itheima.bean.Department;
import com.itheima.bean.Employee;
import com.itheima.dao.DepartmentMapper;
import com.itheima.dao.EmployeeMapper;
import com.itheima.service.EmployeeService;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.UUID;

/**

 * 1. @ContextConfiguration指定spring配置文件的位置
 * 2. @RunWith是指我们使用谁的单元测试
 * 3. 我们需要什么组件直接使用@autowired
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {


    @Autowired
    EmployeeService employeeService;

    @Autowired
    EmployeeMapper employeeMapper;



    /**
     * 测试department的基本功能
     */
    @Test
    public void testCRUD() {

        List<Employee> employees=employeeService.getAll();
        for (Employee employee : employees) {
            System.out.println(employee.getdId());
        }

    }
}
