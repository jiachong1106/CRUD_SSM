<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	//获取项目路径
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>
	<!-- 员工添加的模态框 -->
	<div class="modal fade" id="empAddModel" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">员工添加</h4>
				</div>
				<div class="modal-body ">
					<form class="form-horizontal">
						<div class="form-group">
							<label for="inputEmail3" class="col-sm-2 control-label">empName</label>
							<div class="col-sm-10">
								<input type="text" class="form-control" name="empName"
									id="empName_add_input" placeholder="empName"> <span
									id="helpBlock1" class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="inputEmail3" class="col-sm-2 control-label">email</label>
							<div class="col-sm-10">
								<input type="email" class="form-control" name="email"
									id="email_add_input" placeholder="xxx@163.com"> <span
									id="helpBlock2" class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="inputEmail3" class="col-sm-2 control-label">gender</label>
							<div class="col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="gender1_add_input" value="M"
									checked="checked">男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="gender2_add_input" value="F">女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label for="inputEmail3" class="col-sm-2 control-label">department</label>
							<div class="col-sm-10">
								<!-- 部门提交部门id即可 -->
								<select class="form-control" name="dId">

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


	<!-- 搭建显示页面 -->
	<div class="container-fluid">
		<!--标题行  -->
		<div class="row">
			<div class="col-md-4">
				<h1>CRUD-查询</h1>
			</div>
		</div>
		<!-- 按钮行 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
				<button class="btn btn-danger" id="emp_del_modal_btn">删除</button>
			</div>
		</div>
		<!-- 表格行 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<!-- <th>
							<form>
								<input type="checkbox" name="" value=""><br>
							</form>
						</th> -->
							<th>#</th>
							<th>lastName</th>
							<th>email</th>
							<th>gender</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>

					</tbody>
				</table>
			</div>
		</div>
		<!-- 分页信息行 -->
		<div class="row">
			<!--分页信息  -->
			<div class="col-md-6 " id="page_info_area"></div>
			<!-- 分页导航栏 -->
			<div class="col-md-6" id="page_nav_area"></div>
		</div>
	</div>
	<script src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
	<script
		src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		var totalNum;
		//1.页面加载完成以后，直接发送ajax请求，获取分页数据
		$(function() {
			toPage(1);
		});
		//跳转页码
		function toPage(pn) {
			$.ajax({
				type : "get",
				url : "${APP_PATH}/emps",
				data : "pn=" + pn,
				success : function(result) {
					//console.log(result);
					//1.解析并显示员工数据
					build_emps_table(result);
					//2.解析并显示分页数据
					build_page_info(result);
					//3.解析显示分页条数据
					build_page_nav(result)
				}
			});
		}
		//2.解析Json并显示员工数据
		function build_emps_table(result) {
			//清空table表格
			$("#emps_table tbody").empty();
			//解析Json获取员工列表
			var emps = result.extend.pageInfo.list;
			$("#emps_table tbody").empty();
			$.each(emps, function(index, item) {
				//把员工数据添加到单元格中
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(
						item.gender == "M" ? "男" : "女");
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>")
						.append(item.department.deptName);
				/* <button class="btn btn-info btn-sm "><span class="glyphicon glyphicon-pencil">编辑</button>
				<button class="btn btn-danger btn-sm "><span class="glyphicon glyphicon-trash">删除</button>
				 */
				var editBtn = $("<button></button>").addClass(
						"btn btn-info btn-sm").append(
						$("<span></span>").addClass(
								"glyphicon glyphicon-pencil"));
				var delBtn = $("<button></button>").addClass(
						"btn btn-danger btn-sm").append(
						$("<span></span>")
								.addClass("glyphicon glyphicon-trash"));
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(
						delBtn);
				//append方法执行完后还是返回原来的元素
				$("<tr></tr>").append(empIdTd).append(empNameTd)
						.append(emailTd).append(genderTd).append(deptNameTd)
						.append(btnTd).appendTo("#emps_table tbody");
			});
		}
		//3.解析显示分页信息
		function build_page_info(result) {
			$("#page_info_area").empty();
			//定位到page_info_area元素并把数据添加到此处
			$("#page_info_area").append(
					"当前第【" + result.extend.pageInfo.pageNum + "】页，共有【"
							+ result.extend.pageInfo.pages + "】页，总计【"
							+ result.extend.pageInfo.total + "】条数据");
			totalNum = result.extend.pageInfo.total;
		}
		//4.解析显示分页导航数据
		function build_page_nav(result) {
			$("#page_nav_area").empty();
			//创建ul class="pagination"元素
			var ul = $("<ul></ul>").addClass("pagination");
			//创建首页，前页，下一页，末页元素
			var firstPage = $("<li></li>").append($("<a></a>").append("首页"));
			var prePage = $("<li></li>").append($("<a></a>").append("&laquo;"));
			if (result.extend.pageInfo.hasPreviousPage == false) {
				//不能点击
				firstPage.addClass("disabled");
				prePage.addClass("disabled");
			} else {
				firstPage.click(function() {
					toPage(1);
				});
				prePage.click(function() {
					toPage(result.extend.pageInfo.pageNum - 1);
				});
			}
			var nextPage = $("<li></li>")
					.append($("<a></a>").append("&raquo;"));
			var lastPage = $("<li></li>").append($("<a></a>").append("末页"));
			if (result.extend.pageInfo.hasNextPage == false) {
				//不能点击
				lastPage.addClass("disabled");
				nextPage.addClass("disabled");
			} else {
				lastPage.click(function() {
					toPage(result.extend.pageInfo.pages);
				});
				nextPage.click(function() {
					toPage(result.extend.pageInfo.pageNum + 1);
				});
			}
			//将首页，前页li元素添加到ul元素中
			ul.append(firstPage).append(prePage);
			//获取要显示的所有页码参数
			var nums = result.extend.pageInfo.navigatepageNums;
			$.each(nums, function(index, item) {
				var num = $("<li></li>").append($("<a></a>").append(item));
				if (result.extend.pageInfo.pageNum == item)
					//添加活动标识
					num.addClass("active");
				num.click(function() {
					toPage(item);
				});
				ul.append(num);
			});
			//添加下一页和末页提示
			ul.append(nextPage).append(lastPage);
			$("<nav></nav>").append(ul).appendTo("#page_nav_area");
		}
//为"新增"按钮绑定单击事件，启动模态框
$("#emp_add_modal_btn").click(function() {
	//清除表单数据
	reset_form("#empAddModel form");
	//弹出模态框之前先ajax请求获取部门信息
	getDepts();
	$('#empAddModel').modal({
		//点击背景，模态框不会关闭
		backdrop : false
	});
})
//清空表单样式及内容
function reset_form(ele){
	$(ele)[0].reset();
	//清空表单样式
	$(ele).find("*").removeClass("has-error has-success");
	$(ele).find(".help-block").text("");
}
		//获取部门信息
		function getDepts() {
			$.ajax({
				type : "GET",
				url : "${APP_PATH}/depts",
				success : function(result) {
					//{"code":100,"msg":"操作成功！",
					//"extend":{"depts":[{"deptName":"开发部","deptId":1},{"deptName":"测试部","deptId":2}]}}
					//console.log(result);
					$.each(result.extend.depts, function() {
						//alert(this.deptId);
						var option = $("<option></option>").append(
								this.deptName).attr("value", this.deptId);
						$("#empAddModel select").append(option);
					})
				}
			})
		};
//为"保存"按钮增加单击事件
$("#emp_save_btn").click(function() {

	//1、检验用户名和邮箱
	if(!validate_add_form()){
		return false;
	} 
	
	//2、判断之前校验用户名是否重复的结果
	if($(this).attr("nameStatus")=="error"){
		return false;
	}
	
	//3、发送ajax请求保存员工
	$.ajax({
		type : "POST",
		url : "${APP_PATH}/emp",
		data : $("#empAddModel form").serialize(),
		success : function(result) {
			if(result.code==100){
				//1.关闭模态框
				$('#empAddModel').modal('hide');
				//2.查询员工跳转到最后一页
				toPage(totalNum);
			}else{
				//显示失败信息
				console.log(result);
				//有哪个字段的错误信息就显示哪个字段的；
				if(undefined != result.extend.errorFields.email){
					//显示邮箱错误信息
					show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
				}
				if(undefined != result.extend.errorFields.empName){
					//显示员工名字的错误信息
					show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
				} 
			}
		}
	})
})
		//显示校验结果的提示信息
		function show_validate_msg(ele, status,msg) {
			//清除当前元素的校验状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			if ("success" == status) {
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			} else if ("error" == status) {
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		//校验用户名和邮箱格式
		function validate_add_form() {
			var empName = $("#empName_add_input").val();
			var email = $("#email_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
			if (!regName.test(empName)) {
				show_validate_msg("#empName_add_input", "error",
						"用户名可以是2-5位中文或者6-16位英文和数字的组合");
				return false;
			} else {
				show_validate_msg("#empName_add_input", "success", "用户名可以使用");
			}
			if (!regEmail.test(email)) {
				show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
				return false;
			} else {
				show_validate_msg("#email_add_input", "success", "");
			}
			return true;
		}

//为"empName"框增加内容改变事件
$("#empName_add_input").change(
		function() {
			var empName = this.value;
			$.ajax({
				type : "get",
				url : "${APP_PATH}/checkuser",
				data : "empName=" + empName,
				success : function(result) {
					if(result.code ==100) {
						show_validate_msg("#empName_add_input","success","用户名可用 ");
						$("#empName_add_input").attr("nameStatus","success");
					} else {
						show_validate_msg("#empName_add_input","error",result.extend.va_msg);
						$("#empName_add_input").attr("nameStatus","error");
					} 
				}
			})
		})
	</script>
</body>
</html>