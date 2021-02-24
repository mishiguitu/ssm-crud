
---
title: SSM-CRUD 
tags: 
    - ssm
    - spring
    - springmvc
    - mybatis

categories: java框架
aplayer: false
keywords: none
comments: false
---

# SSM-CRUD
#### 技术点
1. 基础框架-ssm
2. 数据库-MySQL
3. 前端框架-bootstrap快速搭建界面
4. 项目管理-maven
5. 分页-pagehelper
6. Mybatis的逆向工程

#### 基础环境搭建
1. 新建一个maven项目，不使用骨架，finish，然后创建web应用，点中项目->右键，add framework support
2. 引入项目依赖jar包
	1. spring（有spring-jdbc，spring-aop）
	2. springmvc（spring-webmvc）
	3. mybatis（mybatis-spring，mybatis）
	4. 数据库连接池（c3p0）, 数据库驱动（mysql-connector-java）
	5. 其他(jstl,servlet-api,junit)
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-webmvc</artifactId>
        <version>5.1.9.RELEASE</version>
    </dependency>

    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-jdbc</artifactId>
        <version>5.1.9.RELEASE</version>
    </dependency>

<!--    面向切片spring aop-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-aop</artifactId>
        <version>5.1.9.RELEASE</version>
    </dependency>

    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis</artifactId>
        <version>3.5.5</version>
    </dependency>
<!--mybatis整合spring的适配包-->
    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis-spring</artifactId>
        <version>2.0.2</version>
    </dependency>
    <dependency>
        <groupId>c3p0</groupId>
        <artifactId>c3p0</artifactId>
        <version>0.9.1.2</version>
    </dependency>

    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.19</version>
    </dependency>
    
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>jstl</artifactId>
        <version>1.2</version>
    </dependency>
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>servlet-api</artifactId>
        <version>2.5</version>
    </dependency>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```
3. 引入bootstrap前端框架，需下载（搜索bootstrap，下载用于生产环境的bootstrap）。在web（最顶层的文件夹）下新建一个static文件夹，然后将解压后的bootstrap文件夹放到static中去
4. 使用bootstrap，只需要引入核心的css文件和js文件，我们修改index.jsp页面如下，引入必备的js和css，然后找到bootstrap的官网，找css全局样式->按钮，根据喜欢的样式复制class内容
5. 有这个https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist  之后我们可以不使用本地的bootstrap，直接引用远程的js和css。下面的一个css和两个js是必备的,index.jsp如下
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>$Title$</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
  </head>
  <body>
    <button class="btn btn-success">按钮</button>
  </body>
</html>
```
#### 配置web.xml
初始化容器，所以要在resources下面新建一个applicationContext.xml
```xml
<!--1.配置servlet，设置初始化xml和启动等级 -->
    <servlet>
        <servlet-name>servlet-mvc</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:applicationContext.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>servlet-mvc</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>
<!--   2. 配置过滤器, / 表示只过滤url，/*表示过滤url和所有jsp
        如果有多个filter过滤器，字符编码过滤器要放到最前面-->
    <filter>
        <filter-name>encodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>utf-8</param-value>
        </init-param>
    </filter>

    <filter-mapping>
        <filter-name>encodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
    
    <!--    3. 使用Rest风格URI
    HiddenHttpMethodFilter将页面普通的post请求转为我们指定的delete或者put请求
    /* 表示拦截所有-->
    <filter>
        <filter-name>HiddenHttpMethodFilter</filter-name>
        <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>HiddenHttpMethodFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
```
#### 配置spring-mvc.xml
1. 在resources下面新建一个spring-mvc.xml，并创建要扫描的包 
com.itheima.controller 
com.itheima.service
com.itheima.dao
com.itheima.bean(实体类)
com.itheima.utils(工具类)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml version="1.0" encoding="UTF-8"?>  
<beans xmlns="http://www.springframework.org/schema/beans"        
    xmlns:mvc="http://www.springframework.org/schema/mvc"     
    xmlns:tx="http://www.springframework.org/schema/tx"  
    xmlns:aop="http://www.springframework.org/schema/aop"  
    xmlns:context="http://www.springframework.org/schema/context"  
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"              
    xsi:schemaLocation="                                               
            http://www.springframework.org/schema/beans    
            http://www.springframework.org/schema/beans/spring-beans.xsd    
            http://www.springframework.org/schema/context     
            http://www.springframework.org/schema/context/spring-context.xsd    
            http://www.springframework.org/schema/mvc    
            http://www.springframework.org/schema/mvc/spring-mvc.xsd  
            http://www.springframework.org/schema/tx   
            http://www.springframework.org/schema/tx/spring-tx.xsd  
            http://www.springframework.org/schema/aop  
            http://www.springframework.org/schema/aop/spring-aop.xsd "  >
            
<!--    1. 添加spring-mvc扫描的controller包(spring-mvc只需要扫描controller)-->
    <context:component-scan base-package="com.itmeima.controller"></context:component-scan>


<!--    2.配置视图解析器-->
    <bean  class="org.springframework.web.servlet.view.InternalResourceViewResolver">
<!--        配置前缀和后缀-->
        <property name="prefix" value="/WEB-INF/views/"></property>
        <property name="suffix" value=".jsp"></property>

    </bean>
<!--    3. 要添加的两个标准配置-->
<!--    将springmvc不能处理的请求交给tomcat,能实现访问动态静态资源-->
    <mvc:default-servlet-handler/>
<!--    支持springmvc的高级功能，比如支持JSR303校验，快捷的ajax请求，开启注解-->
    <mvc:annotation-driven/>

</beans>
```

#### 配置spring.xml
1. 配置数据源时创建一个jdbc.properties,在resources目录下面新建
2. 配置SqlsessionFactory时要指定Mybatis.xml的配置文件
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
            http://www.springframework.org/schema/beans
            http://www.springframework.org/schema/beans/spring-beans.xsd
            http://www.springframework.org/schema/context
            http://www.springframework.org/schema/context/spring-context.xsd
            http://www.springframework.org/schema/mvc
            http://www.springframework.org/schema/mvc/spring-mvc.xsd
            http://www.springframework.org/schema/tx
            http://www.springframework.org/schema/tx/spring-tx.xsd
            http://www.springframework.org/schema/aop
            http://www.springframework.org/schema/aop/spring-aop.xsd "  >

<!--    1. 配置数据源,指定数据库的四个基本要素
        -->
<!--    要引入外部的jdbc.properties文件，使用context标签-->
    <context:property-placeholder location="classpath:jdbc.properties"></context:property-placeholder>
    <bean class="com.mchange.v2.c3p0.ComboPooledDataSource" id="dataSource">
        <property name="driverClass" value="${jdbc.driver}"></property>
        <property name="jdbcUrl" value="${jdbc.url}"></property>
        <property name="user" value="${jdbc.username}"></property>
        <property name="password" value="${jdbc.password}"></property>
    </bean>

<!--   2. spring-service.xml要扫描service层的所有包 -->
    <context:component-scan base-package="com.itheima.service"></context:component-scan>

<!--   3. 配置和Mybatis的整合
        SqlSessionFactoryBean能帮我们创建sqlSessionFactory
        创建sqlSessionFactory需要绑定Mybatis.xml的配置文件
        原来Mybatis.xml要指定数据源，mappers和其他，数据源在这里配置-->
    <bean class="org.mybatis.spring.SqlSessionFactoryBean" id="sqlSessionFactory">
<!--        指定Mybatis.xml的路径-->
        <property name="configLocation" value="classpath:mybatis.xml"></property>
        <property name="dataSource" ref="dataSource"></property>
        <property name="mapperLocations" value="classpath:mapper/*.xml"></property>

  </bean>

<!--    4. 配置扫描器，将Mybatis接口的实现加入到ioc容器中-->
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <property name="basePackage" value="com.itheima.dao"></property>
    </bean>

    
<!--       5. 事务控制,自动帮我们控制数据源-->
    <bean class="org.springframework.jdbc.datasource.DataSourceTransactionManager" id="transactionManager">
        <property name="dataSource" ref="dataSource"></property>
    </bean>

<!--    6.开启基于注解的事务，使用xml形式配置的事务（重要的配置使用注解） -->
    <aop:config>
<!--        一般是service下面类中所有方法有切入 * com.itheima.service.*.*(..)-->
        <aop:pointcut id="txPoint" expression="execution(* com.itheima.service.*.*(..))"/>
<!--        配置事务增强-->
        <aop:advisor advice-ref="txAdvice" pointcut-ref="txPoint"></aop:advisor>
    </aop:config>

    
<!--    7. 配置6中需的事务通知,也就是事务如何切入-->
    <tx:advice id="txAdvice">
        <tx:attributes>
<!--            * 表示所有方法都是事务方法-->
            <tx:method name="*"/>
<!--            以get开始的所有方法,就是查询，设置只读-->
            <tx:method name="get*" read-only="true"/>
        </tx:attributes>
    </tx:advice>

</beans>
```
#### Mybatis的配置文件
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">

<configuration>
<!--    1. 配置settings-->
    <settings>
        <setting name="mapUnderscoreToCamelCase" value="true"/>
    </settings>
    
    <typeAliases>
        <package name="com.itheima.bean"/>
    </typeAliases>
</configuration>
```
#### 使用Mybatis的逆向工程帮助我们生成数据库中的实体类
1. 导入jar包，在maven中搜索 mybatis generator，使用带有core的
```xml
<dependency>
    <groupId>org.mybatis.generator</groupId>
    <artifactId>mybatis-generator-core</artifactId>
    <version>1.3.5</version>
</dependency>
```
2. 找到mybatis generator官网，找到xml configurationreference,复制然后新建一个mbg.xml。然后修改mbg.xml中的内容
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>
<!--    1. 删除原有的classpath-->
<!--    2. 配置数据库连接,就是下面的jdbcConnection-->
    <context id="DB2Tables" targetRuntime="MyBatis3">
        <jdbcConnection driverClass="com.mysql.cj.jdbc.Driver"
                        connectionURL="jdbc:mysql://localhost:3306/spring?useUnicode=true&amp;characterEncoding=utf8&amp;serverTimezone=Asia/Shanghai"
                        userId="root"
                        password="123456">
        </jdbcConnection>

        <javaTypeResolver >
            <property name="forceBigDecimals" value="false" />
        </javaTypeResolver>
<!-- 3.javaModelGenerator指定javabean生成的位置
        targetPackage改成自己bean的包-->
        <javaModelGenerator targetPackage="com.itheima.bean" targetProject=".\src\main\java">
            <property name="enableSubPackages" value="true" />
            <property name="trimStrings" value="true" />
        </javaModelGenerator>
<!--4. sqlMapGenerator指定sql映射文件生成位置-->
        <sqlMapGenerator targetPackage="mapper"  targetProject=".\src\main\resources">
            <property name="enableSubPackages" value="true" />
        </sqlMapGenerator>

<!--     5.    指定dao接口生成的位置,mapper接口生成的位置,targetPackage指文件夹，targetProject指项目路径-->
        <javaClientGenerator type="XMLMAPPER" targetPackage="com.itheima.dao"  targetProject=".\src\main\java">
            <property name="enableSubPackages" value="true" />
        </javaClientGenerator>
<!--    6. table指定每个表的生成策略，删掉现有的，自己重新写
        tableName是数据库中的表名，domainObjectName是生产实体类的名字-->
        <table tableName="emp" domainObjectName="Employee"></table>
        <table tableName="dept" domainObjectName="Department"></table>

    </context>
</generatorConfiguration>
```
3. 新建一个测试类，执行下面代码,注意修改File的路径，如果出现找不到文件错误，使用classLoader或者绝对地址文件
```java
public class MBGTest {
    public static void main(String[] args) throws Exception{
        List<String> warnings = new ArrayList<String>();
        boolean overwrite = true;
        File configFile = new File("F:\\IDEAProject\\ssm-crud\\src\\main\\resources\\mbg.xml");
        ConfigurationParser cp = new ConfigurationParser(warnings);
        Configuration config = cp.parseConfiguration(configFile);
        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
        MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
        myBatisGenerator.generate(null);
    }
}
```
4. 运行上面文件后会自动 生成带有注释的文件，可以删掉重新生成没要注释的文件(dao,bean,mapper三个文件夹中的文件)
```
<!--        这个注释加载mbg.xml的context里面，true生成没有注释的文件-->
        <commentGenerator>
            <property name="suppressAllComments" value="true" />
        </commentGenerator>
```
#### 修改mapper文件
1. EmployeeMapper(dao层的接口文件)中添加两个方法，在查询员工时同时查出员工部门
```java
   List<Employee> selectByExampleWithDept(EmployeeExample example);

    Employee selectByPrimaryKeyWithDept(Integer empId);
```
2. 查询员工时同时查出员工部门实际就是一对一，所以要在员工实例（Employee.java）中加入部门属性，生成getter和setter
3. 然后在EmployeeMapper.xml中添加两个新增的查询方法
```xml
  <sql id="WithDept_Column_List">
    emp_id, emp_name, gender, email, d_id,dept_id,dept_name
  </sql>
  
  
  <resultMap id="WithDeptResultMap" type="com.itheima.bean.Employee">
    <id column="emp_id" jdbcType="INTEGER" property="empId" />
    <result column="emp_name" jdbcType="VARCHAR" property="empName" />
    <result column="gender" jdbcType="CHAR" property="gender" />
    <result column="email" jdbcType="VARCHAR" property="email" />
    <result column="d_id" jdbcType="INTEGER" property="dId" />
    <association property="department" javaType="com.itheima.bean.Department">
      <id property="deptId" column="dept_id"></id>
      <result column="dept_name" property="deptName"></result>
    </association>
  </resultMap>
  
  
  <select id="selectByExampleWithDept" resultMap="WithDeptResultMap">
    select
    <if test="distinct">
      distinct
    </if>
    <include refid="WithDept_Column_List" />
    from tbl_emp e
    left join tbl_dept d
    on e.d_id=d.dept_id
    <if test="_parameter != null">
      <include refid="Example_Where_Clause" />
    </if>
    <if test="orderByClause != null">
      order by ${orderByClause}
    </if>
  </select>

  <select id="selectByPrimaryKeyWithDept" resultMap="WithDeptResultMap">
    select
    <include refid="WithDept_Column_List" />
    from tbl_emp e
    left join tbl_dept d
    on e.d_id=d.dept_id
    where emp_id = #{empId,jdbcType=INTEGER}
  </select>
```
#### 使用Spring的单元测试
Spring的单元测试能自动为我们创建容器
1. 导入springTest的依赖
```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-test</artifactId>
    <version>5.2.3.RELEASE</version>
    <scope>test</scope>
</dependency>
```
2. 首先测试departmeant，给departmean添加构造器（在使用有参数构造器后一定要添加无参数构造器）
3.测试步骤呢内容

```java
/**

 * 1. @ContextConfiguration指定spring配置文件的位置
 * 2. @RunWith是指我们使用谁的单元测试,这里我们使用Spring的单元测试
 * 3. 我们需要什么组件直接使用@autowired
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    /**
     * 测试department的基本功能
     */
    @Test
    public void testCRUD() {
        System.out.println(departmentMapper);

       departmentMapper.insertSelective(new Department(null, "开发部"));
      departmentMapper.insertSelective(new Department(null,"测试部"));

    }
}
```
4. 配额制一个可以执行批量的sqlSession,在spring-service.xml中配置如下
```xml
<!--配额制一个可以执行批量的sqlSession
    点进这个类发现他有有参数构造器-->
    <bean class="org.mybatis.spring.SqlSessionTemplate" id="sessionTemplate">
        <constructor-arg name="sqlSessionFactory" ref="sqlSessionFactory"></constructor-arg>
<!--       executorType是执行类型，BATCH表示批量 -->
        <constructor-arg name="executorType" value="BATCH"></constructor-arg>
    </bean>
```

5. 单元测试中使用SqlSession
```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    @Autowired
    SqlSession sqlSession;

    @Test
    public void testCRUD() {
        EmployeeMapper employeeMapper=sqlSession.getMapper(EmployeeMapper.class);
//        employeeMapper是一次性执行所有的sql，departmentMapper.insertSelective没每插入一次连接一次数据库
        for (int i = 0; i < 1000; i++) {
//            随机生成员工姓名,后面加上编号i
            String uid=UUID.randomUUID().toString().substring(0,5)+i;

            employeeMapper.insertSelective(new Employee(null,uid,"M",uid+"@163.com",1));
        }
        
    }
}
```

#### Spring所有bean的xml所有约束
```xml
<?xml version="1.0" encoding="UTF-8"?>  
<beans xmlns="http://www.springframework.org/schema/beans"        
    xmlns:mvc="http://www.springframework.org/schema/mvc"     
    xmlns:tx="http://www.springframework.org/schema/tx"  
    xmlns:aop="http://www.springframework.org/schema/aop"  
    xmlns:context="http://www.springframework.org/schema/context"  
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"              
    xsi:schemaLocation="                                               
            http://www.springframework.org/schema/beans    
            http://www.springframework.org/schema/beans/spring-beans.xsd    
            http://www.springframework.org/schema/context     
            http://www.springframework.org/schema/context/spring-context.xsd    
            http://www.springframework.org/schema/mvc    
            http://www.springframework.org/schema/mvc/spring-mvc.xsd  
            http://www.springframework.org/schema/tx   
            http://www.springframework.org/schema/tx/spring-tx.xsd  
            http://www.springframework.org/schema/aop  
            http://www.springframework.org/schema/aop/spring-aop.xsd "  >
</beans>
```

#### 项目报错和注意事项
1. mvc:annotation-driven/>,  <mvc:default-servlet-handler/>是自结束标签
2. <tx:attributes>中的<tx:method name="*"/>  是自结束


3. 使用aop  和  tx必须使用aspectjweaver这个jar包
```xml
    <dependency>
        <groupId>org.aspectj</groupId>
        <artifactId>aspectjweaver</artifactId>
        <version>1.8.7</version>
    </dependency>
```
4. 少了这个jar包，会报错
```xml
Cannot resolve reference to bean 'txPoint' while setting bean property 'pointcut';

org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'txPoint':
```

4. 使用spring的单元测试对servlet-api版本有要求,错误如javax/servlet/SessionCookieConfig
```xml

Spring4测试的时候需要servlet3.0的支持，将servlet-api去掉，使用新的servlet

    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>javax.servlet-api</artifactId>
        <version>3.1.0</version>
    </dependency>
```
#### 查询
1. 访问index..jsp页面
2. index.jsp 页面发出查询员工列表请求
3. EmployeeController接受请求，查出员工数据
4. 在list.jsp页面展示

1. index.jsp使用<jsp:forward page="/emps"></jsp:forward>，直接跳转到 /emps的控制器中
2. 在/emps的控制器中查询所有员工, controller层调用服务层，serivice层调用dao层（使用Mapper对象查询）要创建一个service类并注入.controller层代码如下
```java
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    @RequestMapping("/emps")
    public String getEmps(){
        List<Employee> employees=employeeService.getAll();
        
        return "list";

    }
}
```
3. 要实现分页查询，要使用PageHelper分页插件，导入依赖,这个是MyBatis的插件，所以还要在Mybatis的设置文件中配置,Mybatis.xml的配置在第二个(plugins要放到typeAliases下面)
```xml
    <dependency>
        <groupId>com.github.pagehelper</groupId>
        <artifactId>pagehelper</artifactId>
        <version>5.1.11</version>
    </dependency>
```
```xml
    <plugins>
        <plugin interceptor="com.github.pagehelper.PageInterceptor"></plugin>
    </plugins>
```
4. pageHelper的使用如下
```java
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

//    一次查询1000条数据,一个页面展示不下，所以需要分页处理,前端返回一个页面，没有默认1
    @RequestMapping("/emps")
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
}
```

#### 使用单元测试测试分页请求
1. 使用查询时报错,这个错误是用于使用c3p0jar包的问题，把原有的改成新的
```log
java.lang.AbstractMethodError: Receiver class com.mchange.v2.c3p0.impl.NewProxyResultSet does not define or inherit an implementation of the resolved method abstract isClosed()Z of interface java.sql.ResultSet.
```
2. 原有的错误的c3p0依赖
```XML
    <dependency>
      <groupId>c3p0</groupId>
      <artifactId>c3p0</artifactId>
      <version>0.9.1.2</version>
    </dependency>
```
3. 正确的c3p0
```xml
    <dependency>
      <groupId>com.mchange</groupId>
      <artifactId>c3p0</artifactId>
      <version>0.9.5.2</version>
    </dependency>
```
4. 使用虚拟的MVC做测试,执行成功就表明EmployeeController中没有写错
```java
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
                        .param("pn","1")).andReturn();
       //请求成功后，获取请求域，请求域中有pageInfo
       MockHttpServletRequest request=result.getRequest();
       PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");
       System.out.println(pageInfo.getPageNum());
       System.out.println("总页面"+pageInfo.getPages());

   }

}
```


#### 搭建bootstrap分页页面
1. 页面中获取当前项目路径,导入jsp-api的依赖
```xml
<dependency>
    <groupId>javax.servlet.jsp</groupId>
    <artifactId>jsp-api</artifactId>
    <version>2.2</version>
    <scope>provided</scope>
</dependency>
```
2. web中寻找资源的方式和获取当前项目路径
```jsp
<%--   1. 以/ 开始的相对路径是以服务器的路径为标准，服务器路径是http://localhost:3306
        所以后面的资源要以/ 开头，有利于定位资源
       2. 下面是设置一个变量APP_PATH，它的值是request.getContextPath()，也就是服务器路径
       在其他地市使用是引用 ${APP_PATH}
       3. 使用pageContext需要依赖，jsp-api
        --%>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
```
3. Bootstrap中把页面分成一个主页面，类属性=container，然后子标签中只要行属性row。每一行默认分成12列，列标签中可以指定占的列数
4. 从index.jsp页面跳转到指定的url，在html前面加上<jsp:forward page="/emps"></jsp:forward>
5. 启动服务器在调用查询时报错，已经是最新的c3p0版本。放弃c3p0，使用阿里的druid，解决问题。只需要导入druid的依赖并在spring-service中重写配置数据库连接池
```xml
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>druid</artifactId>
        <version>1.1.20</version>
    </dependency>
```


```xml
    <bean class="com.alibaba.druid.pool.DruidDataSource" id="dataSource">
        <property name="driverClassName" value="${jdbc.driver}"></property>
        <property name="url" value="${jdbc.url}"></property>
        <property name="password" value="${jdbc.password}"></property>
        <property name="username" value="${jdbc.username}"></property>
    </bean>
```
6. 引入标签库对获取的数据遍历
引入c 标签遍历，在html前面引入c的命名空间
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>

c的使用
```xml
<%--                 pageInfo.getList()方法会返回一个查询对象的列表,就是list属性的get方法，pageInfo.list就是员工列表   --%>
<c:forEach items="${pageInfo.list}" var="emp">
                        <tr>
                            <th>${emp.empId}</th>
                            <th>${emp.empName}</th>
                            <th>${emp.gender=="M"?"男":"女"}</th>
                            <th>${emp.email}</th>
                            <th>${emp.department.deptName}</th>
                            <th>
                                <button class="btn btn-success btn-sm">
                                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                    编辑
                                </button>
                                <button class="btn btn-danger btn-sm">
                                    <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                    删除
                                </button>
                            </th>
                        </tr>
                    </c:forEach>
```

pageInfo的相关属性
```xml
 <div class="col-md-4">
<%--        pageInfo.getPageNum方法获取页，实际就是属性的getter方法
            pageInfo.pages  获取总页数
            pageInfo.total 获取总记录数(总查询的条目数)   --%>
                当前第${pageInfo.pageNum}页,总共${pageInfo.pages}页,总共${pageInfo.total}记录
            </div>
```

7. 给每个页码添加完整的href
<%--a中的href是完整的请求路径，同时带上参数${APP_PATH}/emps?pn=${page_num}--%>
```xml
<%--       ${pageInfo.navigatepageNums}获取一个数组，  var="pageNum"表示数中的每一项 ，自动根据数组长度做循环次数 --%>
    <c:forEach items="${pageInfo.navigatepageNums} " var="pageNum">
<%--  if测试，如果当前页面与这个pageNum相等，则给li激活，激活高亮--%>
          <c:if test="${pageInfo.pageNum == page_num}">
                <li>
                	<a href="${APP_PATH}/emps?pn=${page_num}">${page_num}</a>
                </li>
           </c:if>
<%--   如果当前页面与这个pageNum不相等，则不激活  --%>
           <c:if test="${pageInfo.pageNum != page_num}">
                  <li>
                  	<a href="${APP_PATH}/emps?pn=${page_num}">${page_num}</a>
                 </li>
           </c:if>
```

8. 点击前一页，防止出现负数的两个解决办法
	1. 使用三元表达式
```
      <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1 ==0? pageInfo.pageNum-1:1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
       </a>
```


	2. 使用 c：if 做判断测试，pageInfo有很多的属性，可以点进去查看

#### 查询时不返回jsp页面，返回json数据
1. index.jsp页面发出ajax请求进行员工分页数据查询
2. 服务器将查出的数据以json字符串形式返回给浏览器
2. 浏览器收到js字符串，使用js对json解析
3. 使用js通过dom增删改改变页面


1. 修改controller类，为能够番号json对象，有导入Jackson，依赖如下
```
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.10.3</version>
</dependency>
```
2. 在pom中添加jar包时，要更新web下面的lib中的包，controller类的代码如下
```java
//@ResponseBody 注解表示页面发出请求时，我们返回一个PageInfo的对象
//@ResponseBody要能正常工作，需要导入jackSon包，
    @RequestMapping("/emps")
    @ResponseBody
    public PageInfo getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1" )Integer pn) {
        PageHelper.startPage(pn,5);
        List<Employee> employees=employeeService.getAll();
        PageInfo page=new PageInfo(employees,5);
        return page;
    }
```
3. 返回的pageInfo对象不具有通用性，我们在bean下仙剑一个通用类Msg，生成getter和setter，让控制器返回Mes对象(修改返回类型)。Msg类如下
```java
public class Msg {
//    code表示状态码
    private int code;
// msg就是提示信息
    private String msg;

//    返回给浏览器时包含的用户信息
    private Map<String,Object> extend=new HashMap<>();

    public static Msg success(){
        Msg msg = new Msg();
        msg.setCode(100);
        msg.setMsg("处理成功");
        return msg;
    }

    public static Msg fail(){
        Msg msg = new Msg();
        msg.setCode(200);
        msg.setMsg("处理失败");
        return msg;
    }
//给Msg添加一个add方法，返回的是一个Msg对象，这样就能链式操作,Msg对象始终只有一个，但能存多个信息

    public Msg add(String key,Object value){
        this.getExtend().put(key,value);
        return this;
    }
}
```
controller类如下
```java
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1" )Integer pn) {
        PageHelper.startPage(pn,5);
        List<Employee> employees=employeeService.getAll();
        PageInfo page=new PageInfo(employees,5);
        return Msg.success().add("pageInfo",page);
    }
```
4. 整体实现效果是我们在返回pageInfo对象同时能够添加一些新的消息，使页面更完整


#### 查询——构建员工列表
1.  在页面加载完成后发送sjax请求，在最下面的body的上面添加script，在script中发送ajax请求
2.  浏览器报bootstrap.min.js:6 Uncaught Error: Bootstrap's JavaScript requires jQuery错误，是因为我们在最前面引入了bootstrap和jquery的srcipt，jquery必须放到最前面
3.  在Network，all中能找到我们发送的所有请求以及返回的信息
4.  在一开始加载页面时就发送ajxa请求的方法，增加通用性，在加载页面是直接调用函数
```javascript
  $(function () {
      //这个函数会在已进入页面就加载执行，去第一页
      toPageNum(1);

    })
	
	 //抽取一个方法根据页号发出ajax请求
    function  toPageNum(pn) {
      $.ajax({
        url:"${APP_PATH}/emps",
        data:"pn="+pn,
        type:"get",
        success:function (result) {
          console.log(result)
          //1.请求成功后解析json并显示员工数据
          build_emps_table(result);
          //2. 解析并显示分页信息
          build_page_info(result);
          //3.显示导航条
          build_page_nav(result);

        }
      });
    }
```
5. js的一些基本函数
 ```javascript
  1. jquery的发送ajax请求,ajax四个属性，url，type，data，success，data是键值对的形式
     type是请求类型，有get，put，post，delete，success是ajax请求成功后的回调函数，默认有result参数
    $.ajax({
	url:"   ",
	data: "key=value",
	type:  ，
	success ： function（result）{
		}
	})
	
	2.jquery遍历对象，对象一般是数组，item和index是回调函数中的默认属性，item表示数组中的每一个
	$.each(对象，function（index，item）{
			
		}
	)
	3. 标签体的一些方法   
	  获取自结束标签中的内容    标签体.val()
	  给自结束标签赋值    标签体.val( 赋值信息)
	  获取成对标签的内容    标签体.text()
	  给成对标签赋值     标签体.text(赋值信息)
	  
	  标签体.append()                append()中的参数可以是标签，或文本
	  $("<td></td>").append(item.email);       加入文本 
	  $("<button></button>").append($("<span></span>")     加入标签
	  
	  创建标签体的方法
	   $("<button></button>")
	   
	   查询标签体
	    $("#id属性")   根据id获取
		
		标签体.addClass()   添加类属性
		
		标签体.empty()  清空标签体内所有内容
		标签体.removeClass(“ ”)  移除类属性
		
	
		标签体.attr("键"  ，"值")    添加属性键值对
		标签体.attr（“键"）     只传入键，是获取键对应的值
```
6.三元表达式赋值         var genderTd=$("<td></td>").append(item.gender=="M" ? "男":"女");
7.使用click方法的注意事项
使用click时，必须传入function（）函数才能被识别成点击事件
```javascript
        numLi.click(function () {
            toPageNum(item);
        })
```

#### pageInfo的一些基本属性，可进入类中查看具体属性
pageInfo.pageNum   当前第几页
pageInfo.pages    总页数
pageInfo.total   总记录数
pageInfo.hasPreviousPage   是否有前一页
pageInfo.hasNextPage   是否有下一页

#### 分页显示的细节
1. 让当前页的导航显示激活  添加active类属性
2. 禁用一个标签  添加disable类属性  prePageLi.addClass("disabled");
3. 如果要查询尾页，可以传递一个很大的数字页面，pageInfo会直接将这个页面作为最后一页处理
4. pageInfo在处理前一页和后一页时，会出现页码为负数或者大于最大页码，可以在mybatis.xml的pageInfo的插件中设置
```xml
    <plugins>
        <plugin interceptor="com.github.pagehelper.PageInterceptor">
            <property name="reasonable" value="true"/>
        </plugin>
    </plugins>
```
#### 创建新增员工模态框
1. 新增逻辑  在index.jsp 页面点击新增
2. 弹出新增模态框
3. 去数据库查询部门列表，放到模态框的下拉列表
4. 用户输入数据，完成保存

1. 在bootstrap官网中，javascript插件 ->模态框，可以找到一个样例
2. 使用js调用 ，$("#模态框id").modal(option)     option是打开模态框的一些设置,option以键值对存在
` $("#empAddModal").modal({
        backdrop:"static"
      })`
4. 使用模态框模板时，主要修改它的各个部分的id和name属性，将那么属性和员工属性一一对应，ssm就能自动识别，方便保存
5. 点击按钮,弹出模态框，需要给新增按钮绑定事件
```javascript
  $("#emp_add_modal").click(function () {
        //弹出模态框之前清除表单数据,表单重置,使用dom对象的reset方法
        $("#empAddModal form")[0].reset();
        //要移除表单中所有含有 has-error  has-success 属性和span标签体中内容
        $("#empAddModal form").find("*").removeClass("has-error  has-success")
        //使用span的id去除内容,find是寻找有help-block属性的标签
        $("#empAddModal form").find(".help-block").empty()
		//获取员工部门信息，插入到下拉列表
		getDepts("#deptName");
		
		//使用js开启模态框
		$("#empAddModal").modal({
        backdrop:"static"
      })

    })
	
	//getDepts()函数，通过发ajax请求，查询部分信息，并解析到下拉列表中
	function getDepts(ele){
      $.ajax({
        url:"${APP_PATH}/depts",
        type:"get",
        success:function (result) {

          console.log(result);
		//将部门信息放到select元素之前，要清空select元素内容，否则会多次插入多个标签
            $(ele).empty();

            //  result.extend.depts是一个列表,遍历,"#deptName"
            // <select class="form-control" name="dId" id="deptName">
            $.each(result.extend.depts,function (index,item) {
                if(item.deptId==1){
                    var option=$("<option value='1'></option>").append(item.deptName);
                }else if(item.deptId==2){
                    var option=$("<option value='2'></option>").append(item.deptName);
                }

                $(ele).append(option);

            })

        }
      })
		
```
6. 模态框样例如图
 ![enter description here](https://mk-img-1259693707.cos.ap-nanjing.myqcloud.com/小书匠/1596728643650.png)
 7. select下面的option中的value是我们提交表单时的值
 如 ` var option=$("<option value='1'></option>").append(item.deptName); ` ,选中这个下拉列表时提交的value是1，而name属性在select中
 
 8. bootstrap中，全局css样式->表单，下面要单选框 radio和多选框checkbox，注意区分


#### Rest风格的uri规定
1. /emp/{id}   发送get请求， 表示用id为参数查询员工
2. /emp      post请求    ，表示保存员工
3. / emp/{id}     put请求   ,表示修改员工
4. /emp/{id}     delete请求 ， 表示删除员工


#### 点击保存的逻辑
1. 点击保存之前，我们要对用户名和邮箱格式做一些校验，点击保存按钮绑定事件如下
```javascript
    //点击保存按钮
    $("#emp_save_btn").click(function () {
	
          // 校验用户名是否重复，没有这个属性，无法点击保存和关闭表单
          if(! $("#emp_save_btn").attr("ajax-va")=="success"){
              return false;

          }

          //校验用户名和邮箱是否合法
          if(! validate_add_from()){
              return false;
          }
		//发送ajax请求，使用表单的序列化方法，能够得到表单中的所有信息并使用&拼接

          $.ajax({
              url:"${APP_PATH}/emp",
              data:$("#empAddModal form").serialize(),
              type:"post",
              success:function (result) {

                  if(result.code==100){
                      //处理成功，要关闭模态框，同时来到最后一页查看保存的信息
                      alert(result.msg);
                      $('#empAddModal').modal('hide');
                      //来到最后一页，直接给toPageNum()传递一个最大的参数
                      toPageNum(9999);
                  }else{
                      console.log(result)
                  }
              }
          })
      })
```
2. 表单的序列化方法能获取表单所有信息并使用&拼接，`$("#empAddModal form").serialize(),`
3. 校验用户名是否重复，我们是通过在员工姓名输入框绑定改变事件，当修改完员工姓名，我们获取这个信息，向服务器发送ajax请求，查询数据库中是否有相同姓名，然后使用json返回true（姓名可用） false(姓名不可用),然后给保存按钮添加自定义属性，根据属性只判断是否能保存.
4. 查询是否有相同用户名的js如下,根据查找结果发送提示信息
```javascript

    //从数据库中查询是否邮箱相同用户名并显示信息
    $("#empName_add_input").change(function () {
        //this.value表示这个输入框的值
        var empName=this.value;
        //1. 发送ajax请求,校验用户名是否可用
        $.ajax({
            url:"${APP_PATH}/checkuser",
            data: "empName="+empName,
            type:"get",
            success:function (result) {
                if(result.code==100){
				// show_validate_msg()是增加提示信息的函数
                    show_validate_msg("#empName_add_input","success","用户名可用")
                    $("#emp_save_btn").attr("ajax-va","success");


                }else{
                    show_validate_msg("#empName_add_input","error","用户名不可用")
                    $("#emp_save_btn").attr("ajax-va","error");
                }
            }
        });
```
5. 查询是否有相同用户名的controller如下
```java
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
```
6. 提示信息函数如下。当子元素含有.control-label、.form-control 和 .help-block等属性时，如果父元素中有添加 .has-warning、.has-error 或 .has-success 类，就能校验。
```javascript
 function show_validate_msg(ele,status,msg){
        //防止给元素添加多个class，在显示信息清除父类class
		//如果父元素有has-success has-error等属性，会相互覆盖，不能生效
        $(ele).parent().removeClass("has-success has-error");
		//不清空span内容，span会保存上次的信息
        $(ele).next("span").empty();
        //ele是选择器的字符串
        if("success"==status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if("error"==status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }
```
6. 校验用户名和邮箱是否合法函数如下
```javascript
 //校验用户名和邮箱
    function validate_add_from(){
        //1.获取校验信息,使用正则校验
        var empName=$("#empName_add_input").val();
        //(^[a-zA-Z0-9_-]{4,16}$)表示数字字母，(^[\u4e00-\u9fff\w]{5,16}$)表示中文
        var regName=/(^[a-zA-Z0-9_-]{6,16}$)|(^[\u4e00-\u9fff]{2,5})/;

        if(! regName.test(empName)){

            show_validate_msg("#empName_add_input","error","姓名不合法，请输入4-16位英文数字或2-5位中文")

            return false;
        }else {

            show_validate_msg("#empName_add_input","success","");

        }

        var email=$("#email_add_input").val();
        var regEmail=/^([a-zA-Z\d])(\w|\-)+@[a-zA-Z\d]+\.[a-zA-Z]{2,4}$/;

        if(! regEmail.test(email)){
            show_validate_msg("#email_add_input","error","请输入正确邮箱")
            return false;
        }else{

            show_validate_msg("#email_add_input","success","")
        }
        return true;

    }
```

#### JSR303校验
1. 在完成前端校验时，也要做后端校验，需要导入依赖 hibernate validator
```xml
<dependency>
    <groupId>org.hibernate.validator</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>6.1.5.Final</version>
</dependency>
```
2. 校验时需要在校验类的属性上添加特殊注解，然后在保存函数的controller中对传进来的参数信息加上校验注解
3. 类属性的注解如下
```java
public class Employee {
    private Integer empId;
//regexp是正则表达式，message是校验失败时提示消息
    @Pattern(regexp = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u4e00-\\u9fff]{2,5})",
            message = "姓名不合法，请输入4-16位英文数字或2-5位中文")
    private String empName;

    private String gender;

    @Email
    private String email;

    private Integer dId;

    private Department department;
```
4. controller类如下
```java
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
```

#### 修改员工
修改逻辑如下
1. 点击编辑，弹出用户修改的模态框，显示用户的信息
2. 点击更新，完成用户修改

给编辑按钮绑定点击事件
1. 直接使用click（function（）） 不能做有效绑定,我们在创建编辑按钮时添加自定时属性只键值对，让后就能由这个键获取值，这个值就是员工id，使用id查询获取员工信息
```javascript

    //点击编辑按钮，弹出修改员工模态框,由于每次进入首页时，它先加载所有的js，然后发送ajax请求，生成按钮，之前按钮绑定事件无效
    //1.在创建按钮的时候绑定事件 2.绑定点击 on,给前面选择器（第一个参数）的后代元素（第二个参数）绑定事件
    //给整个document的子元素中有edit_btn属性的标签添加事件
    $(document).on("click",".edit_btn",function () {
        //1.查询员工信息,显示在静态模态框中,获取员工id，在创建编辑按钮时添加添加自定义属性edit-id,如editBtn.attr("edit-id",item.empId);
        getEmp($(this).attr("edit-id"));
        //2. 查询所有部门信息，并显示部门
        getDepts("#update_deptName");
        //3. 显示更新员工的模态框
        $("#empUpdateModal").modal({
            backdrop:"static"
        })

    })
```
2. 由id查询用工信息的getEmp（）方法如下
```javascript
//发送ajax请求根据id查询员工
      function  getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emp/"+id,
            type:"get",
            success:function (result) {
			//将返回的员工信息插入到编辑模态框中
                $("#empName_update_input").text(result.extend.emp.empName);
                $("#email_update_input").val(result.extend.emp.email);
				//下面的方法是在给select数name属性赋值同时选中相应的option
                $("#gender1_update_input").val([result.extend.emp.gender]);
                $("#update_deptName").val([result.extend.emp.dId]);

            }
        })
      }
```
3. 有id查询员工的controller方法如下
```java
//  @PathVariable表示这个id变量是从路径中取出id占位符的值
    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    public Msg getEmployeeById(@PathVariable(value = "id") int id){
        Employee employee=employeeService.getEmployeeById(id);
       return  Msg.success().add("emp",employee);
    }
```

#### 点击更新，更新员工信息
```javascript
 //更新按钮更新员工信息
      $("#emp_update_btn").click(function () {
          //1.校验邮箱信息是否合法
          var email=$("#email_update_input").val();
          var regEmail=/^([a-zA-Z\d])(\w|\-)+@[a-zA-Z\d]+\.[a-zA-Z]{2,4}$/;

          if(! regEmail.test(email)){
              show_validate_msg("#email_update_input","error","请输入正确邮箱")
              return false;
          }else{

              show_validate_msg("#email_update_input","success","")
          }

          //2.发送ajax请求，保存员工
            //1. 编写controller类中的保存方法,更新的表单中没有员工信息id，所以我们又传入ID
            //如何获取id，我们在点击编辑按钮时，会用到编辑按钮的edit-id这个属性，把这个属性和属性值给更新按钮加上
          $.ajax({
              url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
              type:"put",
              data:$("#empUpdateModal form").serialize() ,
              success:function (result) {
				    alert(result.msg);
                  //1. 关闭模态框
                  $("#empUpdateModal").modal("hide");
                    //回到本页面，在给分页条赋值的地方给currentPage赋值,同时也是刷新页面信息
                  toPageNum(currentPage);
              }


          })


      })
```
2. controller类中的保存方法
```java
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
```

3. 存在无法保存对象的问题
```java
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
```
4. 在web.xml中添加两个过滤器
```xml
    <filter>
        <filter-name>HiddenHttpMethodFilter</filter-name>
        <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>HiddenHttpMethodFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter>
        <filter-name>httpPutFormContentFilter</filter-name>
        <filter-class>org.springframework.web.filter.HttpPutFormContentFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>httpPutFormContentFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
```

#### 删除单一员工
1. 给删除按钮绑定事件，它和编辑按钮一样，不能直接使用click，使用on
2. 删除逻辑，点击删除，弹出对话框，显示要删除的用户和是否删除
3. 使用confir对话框，点击是，执行ajax，删除员工，并回到当前页面
```javascript

//点击删除
    $(document).on("click",".delete_btn",function () {
        //1.弹出是否确认删除对话框，要拿到删除员工姓名
        //找当前按钮的父元素tr的第二个td
        var empName=$(this).parents("tr").find("td:eq(1)").text();
        //弹出确认删除框，确认返回true
        if(confirm("确认删除【"+empName+"】吗？")){
            //发送ajax请求
            $.ajax({
                url:"${APP_PATH}/emp/"+$(this).attr("del-id"),
                type:"delete",
                success:function (result) {
                    alert(result.msg);
                    //回到本页,删除最后一页信息，存在currentPage比最大页数大，所有还是回到最后一页
                    toPageNum(currentPage);


                }

            })
        }

    })
```
4.   controller层代码如下
```java
    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.DELETE)
    //@PathVariable 将路径中id变量值赋给函数参数id
    public Msg deleteEmpById(@PathVariable("id") int id){
        employeeService.deleteEmpById(id);
        return Msg.success();

    }
```

#### 给每一项数据前面加一个选择框
```javascript
 //完成全选
      $("#check_all").click(function () {
          //attr获取checked属性是undefined，attr用于获取自定义属性，原生属性用prop获取
          //checked属性可以查看当前选择框是否被选中,prop获取时选中是true，没选中是false
          // alert($(this).attr("checked"))


          //让所有其他复选框的状态和全选保持一致，在点击全选按钮时，所有子项的按钮标签已经存在
          //所以可以根本这个标签属性，但使用click（）做事件绑定时在解析html时标签就必须存在
          $(".check_item").prop("checked",$(this).prop("checked"));


      });

      //给每个子元素的选择框添加事件
      $(document).on("click",".check_item",function () {
          //判断当前被选中的元素是不是该元素的全部个数
          var flag= $(".check_item:checked").length==$(".check_item").length;

          //如果下面的子元素没有选满，那大的元素就不是全选中状态
          $("#check_all").prop("checked",flag);


      })
```

#### 完成批量删除
1. 点击全部删除按钮，弹出是否删除，执行ajax请求，全部删除按钮绑定事件如下,将所有要删除员工的id 使用字符串拼接  如  id1-id2-id3 ,然后在controller函数中解析字符串，实现单个删除和批量删除
```javascript
  //点击全部删除按钮，完成批量删除

      $("#delete_all_emp").click(function () {
          //显示要删除的员工姓名
          var empNames="";
          var str_ids=""
          $.each($(".check_item:checked"),function (index,item) {
              //paretns是找祖先元素,
              empNames+=$(this).parents("tr").find("td:eq(2)").text()+",";
              str_ids+= $(this).parents("tr").find("td:eq(1)").text()+"-";

          });
          empNames.substring(0,empNames.length-1);
          str_ids.substring(0,empNames.length-1);

          if(confirm("是否删除【"+empNames+"】这些员工？")){
              $.ajax({
                  url:"${APP_PATH}/emp/"+str_ids,
                  type: "delete",
                  success:function (result) {
                        //弹出信息
                      alert(result.msg);
                      //清处全部选择按钮的状态
                      $("#check_all").prop("checked",false);

                      //回到当前页面
                      toPageNum(currentPage);
                  }
              })
          }
      })
  ```
  2. controller函数如下
```java
  @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    //@PathVariable 将路径中id变量值赋给函数参数id
    public Msg deleteEmpById(@PathVariable("ids") String ids){
       String[] str_ids =ids.split("-");
        System.out.println(str_ids);
		//长度为1，使用单个删除，否则批量删除
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
```
3. service层的批量删除函数如下
```java
    public void deleteBatch(List<Integer> id_list) {
        EmployeeExample employeeExample=new EmployeeExample();
        EmployeeExample.Criteria criteria=employeeExample.createCriteria();
        //andEmpIdIn这个方法判断id是否在一个list中
        //拼装的sql  delete from xxx where emp_id in 集合
        criteria.andEmpIdIn(id_list);
        employeeMapper.deleteByExample(employeeExample);

    }
```

#### 导出web项目
1. idea导出为war包，参考[csdn](https://blog.csdn.net/qq_40563761/article/details/88910424)
2. ![enter description here](https://mk-img-1259693707.cos.ap-nanjing.myqcloud.com/小书匠/1596728643730.png)