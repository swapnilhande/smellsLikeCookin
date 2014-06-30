<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Membership</title>
    <link rel="stylesheet" href="../css/documentation.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-div">
            <h1 class="center-align">Membership</h1>
            <hr />
            <br />
            
            <h4>Purpose:</h4>
            <p>
                To tell the role of membership in preventing some pages to be visible to anonymous users.
            </p>
            <p>
            Since some pages of my site are meant to be seen only by logged in users I sought membership roles to manage them, 
                preventing illegal access to them. Since the pages such as AddRecipe which accept recipe id as query parameters,
                any user can type in the address /AddRecipe.aspx?&lt;some number&gt; to get access to that recipe and edit it.
                </p>
            <p>To prevent such access, I have created a member role and put in a web.config file that prevents access to those
                pages which are in that directory if the user is not logged in. In such cases they are automatically directed to 
                login.aspx after login, they are redirected to the same page.</p>

            <h4>Key Functionalities</h4>
            <ul>
                <li>Ability to give access to certain pages only to users with certain membership.</li>
                <li>Ability to direct unauthorized users to login page.</li>
            </ul>

            <h4>Future Scope:</h4>
            <p>
                Ability to create admin user and have access to some pages such as creating hash tags to that user.
            </p>

            <h4>References</h4>
            <ul>
                <li><a href="../../../experiments/asp.net/exp11LoginControl.aspx" target="_blank">Experiment 11 - Login Control</a>  </li>
                <li><a href="http://net4.ccs.neu.edu/home/rasala/login.aspx" target="_blank">Prof.Rasala Login Experiment</a> </li>
            </ul>
        </div>
    </form>
</body>
</html>
