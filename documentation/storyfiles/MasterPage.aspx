<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Master Page</title>
    <link rel="stylesheet" href="../css/documentation.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-div">
            <h1 class="center-align">Master Page</h1>
            <hr />
            <br />
            <h4>File Name:</h4>
            <p>MasterPage.master</p>

            <h4>Purpose:</h4>
            <p>
                This page of <b><i>Smells Like Cookin'</i></b> is the master page which is used by all the other pages of this site.
            </p>
            <p>
                The master page has the title of the project and the menu bar. The menu bar is an unordered list of menu items
                which contains home, Browse recipe, my recipe, Order Summary, Add Recipe.
                </p>
            <ol>
                <li><b>Home:</b>
                    <p>
                        This link refers to the home page of the project. This is visible to all users.
                    </p>
                </li>
                <li>
                    <b>Browse Recipe: </b>
                    <p>
                        This link allows users to browse all the recipes in the system. This link is visible to all users.    
                    </p>
                </li>
                <li>
                    <b>Add Recipe:</b>
                    <p>
                        This link allows logged in users to add new recipe. This link is visible only to logged in users.
                    </p>
                </li>
                <li>
                    <b>Order Summary:</b>
                    <p>
                        This link takes to the Order summary page. This link is visible only to logged in users.
                    </p>
                </li>
                <li>
                    <b>My Recipes</b>
                    <p>
                       This link shows the recipes of current logged in user. This link is visible only to logged in users.
                    </p>
                </li>
                <li>
                    <b>Login Status</b>
                    <p>
                        If a user is logged in, they can logout. If not this link goes to login.aspx.
                    </p>
                </li>
                
            </ol>
            </p>
            <p>The OrderSummary, AddRecipe, MyRecipes pages are in logged in template so that only logged in users can access them.</p>
            <h4>Screen shots</h4>
            <p>Master Page - project title and menu bar:</p>
            <img src="../images/master.jpg" title="Add Recipe" alt="Add Recipe" class="image" />


            <h4>Key Functionalities</h4>
            <ul>
                <li>Ability to create a common menu for all pages</li>
                <li>Ability to create common template to put all pages into it.</li>
                
            </ul>

            

            <h4>References</h4>
            <ul>
                <li><a href="http://net4.ccs.neu.edu/home/rasala/" target="_blank">Professor Rasala's Home</a>  </li>
                
            </ul>
        </div>
    </form>
</body>
</html>
