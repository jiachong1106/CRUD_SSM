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
				<table class="table table-hover">
					<tr>
						<th>
							<form>
								<input type="checkbox" name="" value=""><br>
							</form>
						</th>
						<th>#</th>
						<th>lastName</th>
						<th>email</th>
						<th>gender</th>
						<th>deptName</th>
						<th>操作</th>
					</tr>
					<c:forEach items="${pageInfo.list }" var="emp">
						<tr>
							<td>
								<form>
									<input type="checkbox" name="" value=""><br>
								</form>
							</td>
							<td>${emp.empId }</td>
							<td>${emp.empName }</td>
							<td>${emp.gender=="M"?"男":"女" }</td>
							<td>${emp.email }</td>
							<td>${emp.department.deptName }</td>
							<td>
								<button class="btn btn-info btn-sm glyphicon glyphicon-pencil">编辑</button>
								<button class="btn btn-danger btn-sm glyphicon glyphicon-trash">删除</button>
							</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		<!-- 分页信息行 -->
		<div class="row">
			<div class="col-md-6 ">当前第【${pageInfo.pageNum }】页，共有【${pageInfo.pages }】页，总计【${pageInfo.total }】数据
			</div>
				<div class="col-md-6 ">
					<nav aria-label="Page navigation">
						<ul class="pagination">
							<li><a href="${APP_PATH }/emps?pn=1">首页</a></li>
							<c:if test="${pageInfo.hasPreviousPage }">
								<li><a href="${APP_PATH }/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous"> <span
										aria-hidden="true">&laquo;</span>
								</a></li>
							</c:if>
							<c:forEach items="${ pageInfo.navigatepageNums}" var="page_num">
								<c:if test="${page_num==pageInfo.pageNum }">
									<li class="active"><a href="#">${page_num}</a></li>
								</c:if>
								<c:if test="${page_num!=pageInfo.pageNum }">
									<li><a href="${APP_PATH }/emps?pn=${page_num}">${page_num}</a></li>
								</c:if>
							</c:forEach>
							<c:if test="${pageInfo.hasNextPage }">
								<li><a href="${APP_PATH }/emps?pn=${pageInfo.pageNum+1}" aria-label="Next"> <span
										aria-hidden="true">&raquo;</span>
								</a></li>
							</c:if>
							<li><a href="${APP_PATH }/emps?pn=${pageInfo.pages}">尾页</a></li>
						</ul>
					</nav>
				</div>
		</div>
	</div>
	<script src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
	<script
		src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</body>
</html>