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
  <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>

</head>
<body>
<%--员工添加模板--%>
  <div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title" id="myModalLabel">员工添加</h4>
        </div>

        <div class="modal-body">
<%--          表单--%>
          <form class="form-horizontal">

            <div class="form-group">
<%--           label for指定哪个输入框, placeholder是一个示例   --%>
              <label  class="col-sm-2 control-label">员工姓名</label>
              <div class="col-sm-10">
                <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                  <span  class="help-block"></span>
              </div>
            </div>

            <div class="form-group">
              <label for="email_add_input"  class="col-sm-2 control-label">email</label>
              <div class="col-sm-10">
                <input type="text" class="form-control" name="email" id="email_add_input" placeholder="email@163.com">
                  <span  class="help-block"></span>
              </div>
            </div>
        <%--性别使用单选按钮--%>
            <div class="form-group">
              <label  class="col-sm-2 control-label">性别</label>
              <div class="col-sm-10">
<%--                单选框的value是我们点击提交的信息--%>
                <label class="radio-inline">
                  <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                </label>
                <label class="radio-inline">
                  <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                </label>
              </div>
            </div>


            <div class="form-group">
            <%--部门名称是一个下拉列表--%>
              <label  class="col-sm-2 control-label">部门名称</label>
              <div class="col-sm-3">
                <select class="form-control" name="dId" id="deptName">

                </select>
              </div>

            </div>

          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
          <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
        </div>






      </div>
    </div>
  </div>


<%--员工修改模板--%>
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >员工修改</h4>
            </div>

            <div class="modal-body">
                <%--          表单--%>
                <form class="form-horizontal">

                    <div class="form-group">
                        <%--           label for指定哪个输入框, placeholder是一个示例   --%>
                        <label  class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <p type="text" name="empName" class="form-control-static" id="empName_update_input" ></p>
                            <span  class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email_add_input"  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="email" id="email_update_input" placeholder="email@163.com">
                            <span  class="help-block"></span>
                        </div>
                    </div>
                    <%--性别使用单选按钮--%>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <%--                单选框的value是我们点击提交的信息--%>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>


                    <div class="form-group">
                        <%--部门名称是一个下拉列表--%>
                        <label  class="col-sm-2 control-label">部门名称</label>
                        <div class="col-sm-3">
                            <select class="form-control" name="dId" id="update_deptName" >

                            </select>
                        </div>

                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>






        </div>
    </div>
</div>





  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <h1> SSM-CRUD</h1>
      </div>
    </div>

    <div class="row">
      <%--使用偏移改变位置--%>
      <div class="col-md-4 col-md-offset-8">
        <button class="btn btn-success btn-sm" id="emp_add_modal">新增</button>
        <button class="btn btn-danger btn-sm" id="delete_all_emp">全部删除</button>
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <table class="table table-striped table-hover" id="emps_table" >
          <thead>
            <tr>
                <th>
                    <input type="checkbox" id="check_all"/>
                </th>
              <th>#</th>
              <th>员工姓名</th>
              <th>性别</th>
              <th>邮箱</th>
              <th>所在部门</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>

          </tbody>
        </table>
      </div>
    </div>

    <div class="row">
      <div class="col-md-4" id="page_info_area">

      </div>
      <div class="col-md-6 col-md-offset-8" id="page_nav">

      </div>
    </div>
  </div>
  <script type="text/javascript">

      var currentPage;
    $(function () {
      //这个函数会在已进入页面就加载执行，去第一页
      toPageNum(1);

    })


    //解析员工,对照返回的数据查看，它有code，extend，msg
    function build_emps_table(result) {
      //每次使用ajax发送请求之前清空
      $("#emps_table tbody").empty();

      var emps=result.extend.pageInfo.list;
      //这里调用jQuery的遍历，第一个参数是要遍历对象，第二个参数是回调函数，函数第一个参数是索引，第二个是要遍历对象中的每一个
      $.each(emps,function (index,item) {

        var empIdTd=$("<td></td>").append(item.empId);
        var empNameTd=$("<td></td>").append(item.empName);
        var genderTd=$("<td></td>").append(item.gender=="M" ? "男":"女");
        var emailTd=$("<td></td>").append(item.email);
        var deptNameTd=$("<td></td>").append(item.department.deptName);

        var checkBox=$("<td></td>").append($("<input type='checkbox' class='check_item'/>"));


        var editBtn=$("<button></button>").addClass("btn btn-success btn-sm edit_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                    .append("编辑");

        editBtn.attr("edit-id",item.empId);
        var delBtn=$("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                .append("删除");
        delBtn.attr("del-id",item.empId);
        //append方法执行完成后返回原来的元素
        $("<tr></tr>").append(checkBox)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(editBtn)
                .append(delBtn)
                .appendTo("#emps_table tbody" );


      })
    }

    function build_page_info(result) {
      $("#page_info_area").empty();
      $("#page_info_area").append("当前第"+result.extend.pageInfo.pageNum+"页,总"+ result.extend.pageInfo.pages+"共页," +
              "共"+result.extend.pageInfo.total+"记录");
      currentPage=result.extend.pageInfo.pageNum;


    }
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
    //解析导航条
    function build_page_nav(result) {

      $("#page_nav").empty();
      var ul=$("<ul></ul>").addClass("pagination");

      var firstPageLi=$("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
      firstPageLi.click(function () {
        toPageNum(1);
      });

      var lastPageLi=$("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
      //尾页绑定去最后一页
      lastPageLi.click(function () {
        toPageNum(result.extend.pageInfo.pages)
      });

      var prePageLi=$("<li></li>").append($("<a></a>").append("&laquo;").attr("href","#"));
      prePageLi.click(function () {
        toPageNum(result.extend.pageInfo.pageNum-1);

      });

      var nextPageLi=$("<li></li>").append($("<a></a>").append("&raquo;").attr("href","#"));
      nextPageLi.click(function () {
        toPageNum(result.extend.pageInfo.pageNum+1);

      });
      //添加首页和前一页
      ul.append(firstPageLi).append(prePageLi);
      $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
        //判断当前页面是否显示激活
        if(item==result.extend.pageInfo.pageNum){
          var numLi=$("<li></li>").append($("<a></a>").append(item).attr("href","#")).addClass("active");
        }else{
          var numLi=$("<li></li>").append($("<a></a>").append(item).attr("href","#"));
        }
        //每一个li绑定一个点击事件
        numLi.click(function () {
            toPageNum(item);
        })
        ul.append(numLi);
      })
      //如果没有前一页,前一页禁用
      if(! result.extend.pageInfo.hasPreviousPage){
        prePageLi.addClass("disabled");
      }
      //没有下一页,下一页禁用
      if(!result.extend.pageInfo.hasNextPage ){
        nextPageLi.addClass("disabled");
      }

      //添加下一页和尾页
      ul.append(nextPageLi).append(lastPageLi);
      var navEle=$("<nav></nav>").append(ul);
      $("#page_nav").append(navEle);
    }


    function getDepts(ele){
      $.ajax({
        url:"${APP_PATH}/depts",
        type:"get",
        success:function (result) {

          console.log(result);

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

    }

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

    function show_validate_msg(ele,status,msg){
        //防止给元素添加多个class，在显示信息清除父类class
        $(ele).parent().removeClass("has-success has-error");
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



    //  新增按钮绑定事件,function是回调函数，自己调用，$("#empAddModal")表示模态框，.modal()是设置相关属性
    $("#emp_add_modal").click(function () {
        //弹出模态框之前清除表单数据,表单重置,使用dom对象的reset方法
        $("#empAddModal form")[0].reset();
        //要移除表单中所有含有 has-error  has-success 属性和span标签体中内容
        $("#empAddModal form").find("*").removeClass("has-error  has-success")
        //使用span的id去除内容,find是寻找有help-block属性的标签
        $("#empAddModal form").find(".help-block").empty()


        getDepts("#deptName");

      $("#empAddModal").modal({
        backdrop:"static"
      })

    })

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
                    show_validate_msg("#empName_add_input","success","用户名可用")
                    $("#emp_save_btn").attr("ajax-va","success");


                }else{
                    show_validate_msg("#empName_add_input","error","用户名不可用")
                    $("#emp_save_btn").attr("ajax-va","error");
                }
            }
        });



    })
    //点击保存按钮
    $("#emp_save_btn").click(function () {
          // 校验用户名是否重复
          if(! $("#emp_save_btn").attr("ajax-va")=="success"){
              return false;

          }

          //校验用户名和邮箱是否合法
          if(! validate_add_from()){
              return false;
          }


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

    //点击编辑按钮，弹出修改员工模态框,由于每次进入首页时，它先加载所有的js，然后发送ajax请求，生成按钮，之前按钮绑定事件无效
    //1.在创建按钮的时候绑定事件 2.绑定点击 on,给前面选择器（第一个参数）的后代元素（第二个参数）绑定事件
    //给整个document的子元素中有edit_btn属性的标签添加事件
    $(document).on("click",".edit_btn",function () {
        //1.查询员工信息,显示在静态模态框中,获取员工id，在创建编辑按钮时添加添加自定义属性edit-id,如editBtn.attr("edit-id",item.empId);
        getEmp($(this).attr("edit-id"));
        //2. 查询所有部门信息，并显示部门
        //点击编辑按钮打开模态框之前，把编辑按钮的属性给模态框的更新按钮
        $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
        getDepts("#update_deptName");
        //3. 显示更新员工的模态框
        $("#empUpdateModal").modal({
            backdrop:"static"
        })

    })

    //发送ajax请求根据id查询员工
      function  getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emp/"+id,
            type:"get",
            success:function (result) {
                $("#empName_update_input").text(result.extend.emp.empName);
                $("#email_update_input").val(result.extend.emp.email);
                //给name=gender的input输入框传递一个值，并选中
                $("#empUpdateModal input[name=gender]").val([result.extend.emp.gender]);
                $("#empUpdateModal select").val([result.extend.emp.dId]);

            }
        })

      }

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
                    //回到本页面，在给分页条赋值的地方给currentPage赋值
                  toPageNum(currentPage);

              }


          })


      })

//点击删除
    $(document).on("click",".delete_btn",function () {
        //1.弹出是否确认删除对话框，要拿到删除员工姓名
        //找当前按钮的父元素tr的第二个td
        var empName=$(this).parents("tr").find("td:eq(2)").text();
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


    });
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

  </script>
</body>
</html>
