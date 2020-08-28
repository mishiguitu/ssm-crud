<%--
  Created by IntelliJ IDEA.
  User: 19798
  Date: 2020/7/21
  Time: 14:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<html>
<head>
    <title>员工列表</title>
<%--   1. 以/ 开始的相对路径是以服务器的路径为标准，服务器路径是http://localhost:3306
        所以后面的资源要以/ 开头，有利于定位资源
       2. 下面是设置一个变量APP_PATH，它的值是request.getContextPath()，也就是服务器路径
       在其他地市使用是引用 ${APP_PATH}
       3. 使用pageContext需要依赖，jsp-api
        --%>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-md-12">
               <h1> SSM-CRUD</h1>
            </div>
        </div>

        <div class="row">
<%--使用偏移改变位置--%>
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-success btn-sm">新增</button>
                <button class="btn btn-danger btn-sm">删除</button>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <table class="table table-striped table-hover" >
                    <tr>
                        <th>#</th>
                        <th>员工姓名</th>
                        <th>性别</th>
                        <th>邮箱</th>
                        <th>所在部门</th>
                        <th>操作</th>
                    </tr>
<%--                 pageInfo.getList()方法会返回一个查询对象的列表,pageInfo.list就是员工列表   --%>
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

                </table>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4">
                当前第${pageInfo.pageNum}页,总共${pageInfo.pages}页,总共${pageInfo.total}记录
            </div>
            <div class="col-md-4 col-md-offset-8">
                <nav aria-label="Page navigation">
                    <ul class="pagination">

                        <li>
                            <a href="${APP_PATH}/emps?pn=1">首页</a>
                        </li>

                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1 ==0? 1:pageInfo.pageNum-1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>

                        <c:forEach items="${pageInfo.navigatepageNums}" var="page_num">
                            <c:if test="${pageInfo.pageNum == page_num}">
                                <li class="active"><a href="${APP_PATH}/emps?pn=${page_num}">${page_num}</a></li>
                            </c:if>
                    <%--a中的href是完整的请求路径，同时带上参数${APP_PATH}/emps?pn=${page_num}--%>
                            <c:if test="${pageInfo.pageNum != page_num}">
                                <li><a href="${APP_PATH}/emps?pn=${page_num}">${page_num}</a></li>
                            </c:if>
                        </c:forEach>

                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum ==pageInfo.pages ? pageInfo.pageNum:pageInfo.pageNum+1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pages}">末页</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</body>
</html>
