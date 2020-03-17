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
				<button class="btn btn-primary">新增</button>
				<button class="btn btn-danger">删除</button>
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
				$("<tr></tr>").append(empIdTd).append(empNameTd).append(
						genderTd).append(emailTd).append(deptNameTd).append(
						btnTd).appendTo("#emps_table tbody");
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
			var nextPage = $("<li></li>").append($("<a></a>").append("&raquo;"));
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
	</script>
</body>
</html>