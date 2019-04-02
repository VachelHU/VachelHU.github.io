# Apache Tomcat样例目录session操纵漏洞
### 背景
前段时间扫到的漏洞，研究了下，感觉挺有意思的，发出来和大家分享下，有啥不对的地方还请各位拍砖指正。

Apache Tomcat默认安装包含”/examples”目录，里面存着众多的样例，其中session样例(/examples/servlets /servlet/SessionExample)允许用户对session进行操纵。因为session是全局通用的，所以用户可以通过操纵 session获取管理员权限。

案例:http://www.wooyun.org/bugs/wooyun-2014-064812

### 漏洞分析
首先，我们先来看看SessionExample的部分源码

    //表单代码
    out.println("<P>");
    out.print("<form action=\"");
    out.print(response.encodeURL("SessionExample"));
    out.print("\" ");
    out.println("method=POST>");
    out.println(rb.getString("sessions.dataname"));
    out.println("<input type=text size=20 name=dataname>");
    out.println("<br>");
    out.println(rb.getString("sessions.datavalue"));
    out.println("<input type=text size=20 name=datavalue>");
    out.println("<br>");
    out.println("<input type=submit>");
    out.println("</form>");

    //核心代码
    HttpSession session = request.getSession(true);
    out.println(rb.getString("sessions.id") + " " +
    session.getId());
    out.println("<br>");
    out.println(rb.getString("sessions.created") + " ");
    out.println(new Date(session.getCreationTime()) +
    "<br>");
    out.println(rb.getString("sessions.lastaccessed") + "
    ");
    out.println(new Date(session.getLastAccessedTime()));
    String dataName = request.getParameter("dataname");//获取dataname参数的值
    String dataValue = request.getParameter("datavalue");//获取datavalue参数的值
    if (dataName != null && dataValue != null) {
    session.setAttribute(dataName, dataValue);//将dataname和datavalue写入session
    }

用户通过表单提交dataname和datavalue参数，然后通过request.getParameter（）函数获取这两个参数的值，再通过 session.setAttribute()函数将dataname和datavalue的值写入session。

因为session全局通用的特性， 所以可以通过操纵session参数的值来获取网站管理员权限的目的。

举个例子：

我们先来编写login.jsp,login2.jsp,index.jsp这三个页面，通过这三个页面来模拟一般网站身份验证的过程。

login.jsp

    <form
    action=login2.jsp method="POST" >
    用户名: <input type="text"
    name="username"><br>
    密码: <input type="text" name="password"
    ><br>
    <input
    type="submit" value="登录"><br>
    <form>

login2.jsp

    <%
    if
    (request.getParameter("username") != null &&
    request.getParameter("password")
    != null) {
    String username =
    request.getParameter("username");
    String password =
    request.getParameter("password");
    //验证身份
    if (username.equals("admin")
    && password.equals("admin")) {
    session.setAttribute("login",
    "admin");
    response.sendRedirect("index.jsp");
    }
    else {
    response.sendRedirect("login.jsp");
    }  
    }
    %>

index.jsp

    <%
    if(session.getAttribute("login")
    != null &&
    ((String)session.getAttribute("login")).equals("admin"))
    {
    out.println("Login");
    } else{
    response.sendRedirect("login.jsp");
    }
    %>

我们直接打开网站后台，即index.jsp

http://127.0.0.1:8080/examples/index.jsp

![](http://www.moonsec.com/content/uploadfile/201506/35d18da3ded8438e6ccd97635907e91320150606051951.png)

发现被重定向到login.jsp了，而且在不知道密码的前提下，我们是无法登陆进去的。接下将演示如何通过操纵session进入网站后台

打开SessionExample

http://127.0.0.1:8080/examples/servlets/servlet/SessionExample

在Name of Session Attribute: 里输入login

在Value of Session Attribute:里输入admin

![](http://www.moonsec.com/content/uploadfile/201506/aebf36291a7dd50e5bd3db8ce56d6c8d20150606051951.png)

提交后显示login=admin已经写入session

![](http://www.moonsec.com/content/uploadfile/201506/adb78857c37c499ade45ed403ddd32c720150606051952.png)

再次打开index.jsp，显示成功登录

![](http://www.moonsec.com/content/uploadfile/201506/d7a41477e0580431157de038a154560820150606051952.png)

### 修复建议
删

### 题外话
不觉得这个挺适合做后门的吗？

    <%setAttribute("request.getParameter("u")", " request.getParameter("a")%>

“u”和”a”的值看后台源码
