<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Login</title>
    <link rel="stylesheet" href="../css/documentation.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-div">
            <h1 class="center-align">Login</h1>
            <hr />
            <br />
            <h4>File Name:</h4>
            <p>Login.aspx</p>

            <h4>Purpose:</h4>
            <p>
                Purpose of this page is to provide site wide login.
            </p>
            <p>
            The page has the following controls:
            <ol>
                <li><b>User Name:</b>
                    <p>
                        Text box to enter user name.
                    </p>
                </li>
                <li>
                    <b>Password: </b>
                    <p>
                        Text box to enter password.
                    </p>
                </li>
                <li>
                    <b>Website Home:</b>
                    <p>Link to go back to the homepage of the site.
                    </p>
                </li>
                <li>
                    <b>
                        Project Home:
                    </b>
                    <p>
                        Link to go to the project homepage.
                    </p>
                </li>
                <li>
                    <b>Previous Page</b>
                    <p>
                        Link to go back to the page that brought you to login page.
                    </p>
                </li>
            </ol>
            </p>
            <h4>Screen shots</h4>
            <p>Login Page:</p>
            <img src="../images/login.jpg" title="Login" alt="Login" class="image" />

            
            <h4>Key Functionalities</h4>
            <ul>
                <li>Ability to login site wide.</li>
                <li>Ability to skip login and go to home page of website</li>
                <li>Ability to skip login and go to project home page.</li>
                <li>Ability to skip login and go back to the previous page.</li>
            </ul>

            <h4>References</h4>
            <ul>
                <li><a href="../../../experiments/asp.net/exp11LoginControl.aspx" target="_blank">Experiment 11 - Login Control</a>  </li>
                <li><a href="http://net4.ccs.neu.edu/home/rasala/login.aspx" target="_blank">Prof.Rasala Login Experiment</a> </li>
            </ul>
        </div>
    </form>
</body>
</html>
