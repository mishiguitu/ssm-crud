import com.github.pagehelper.PageInfo;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.net.SocketTimeoutException;

/**
 * @author 19798
 * @version 1.0
 * @ClassName MVCTest
 * @description TODO
 * @date 2020/7/21 15:02
 */
//这里的配置文件要使用spring-mvc.xml和spring-service.xml
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MVCTest {
//    下面的context是传入springmvc的ioc,@WebAppConfiguration能使用创建web的容器
    @Autowired
    WebApplicationContext context;
// MockMvc表示一个虚假的MVC,获取处理结果
   MockMvc  mockMvc;

   @Before
   public void initMocMvc(){
     mockMvc=  MockMvcBuilders.webAppContextSetup(context).build();
   }
   @Test
   public void testPage() throws  Exception{
//       模拟请求并拿到返回值
       MvcResult result=mockMvc.perform(MockMvcRequestBuilders.get("/emps")
                        .param("pn","4")).andReturn();
       //请求成功后，获取请求域，请求域中有pageInfo
       MockHttpServletRequest request=result.getRequest();
       PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");
       System.out.println(pageInfo.getPageNum());
       System.out.println("总页面"+pageInfo.getPages());

   }

}
