<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Homepage</title>
    <link rel="stylesheet" href="../css/documentation.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="container-div">
         <h1 class="center-align">Homepage</h1>
        <hr />
        <br />
         <h4>File Name:</h4>
        <p>Default.aspx</p>
        <h4>Purpose:</h4>
        <p>The homepage of <b><i>Smells Like Cookin'</i></b> is the center stage for all the activity that is going on in the project.
           The page is basically divided into three sections.
            <ol>
                <li><b>Left Pane:</b> 
                    <br />This section contains the following two lists.
                        <ul>
                            <li>
                                <i>Top Contributors</i> - This list contains the descending ordered list of users based on
                                the number of recipes contributed by them. Clicking on the user will open a page that displays all
                                the recipes contributed by him. This is done using query parameters where the username is sent as query
                                to BrowseRecipe.aspx
                            </li>
                            <li>
                                <i>Top Requested Recipes</i> - This list contains the descending ordered list of recipes based on the number
                                of times they have been ordered by users. Clicking on the recipe name will open that recipe's page. 
                                This is done using query parameters where the recipe id is sent as query to ViewRecipe.aspx
                            </li>
                        </ul>
                    
                </li>
                <li>
                    <b>Center Pane: </b>
                    <br />This section displays the images of the recipes as a list and every image has its associated recipe name and 
                    the owner user. Here also clicking on the recipe name will open the recipe page, while clicking on the user will open
                    the page to browse all the recipes contributed by that user. This is acieved in the same way using query parameters as discussed above.
                </li>
                <li>
                    <b>Right Pane:</b>
                    <br />This section contains the following two lists.
                    <ul>
                        <li>
                            <i>Top Commented Recipes</i> - This list contains the descending ordered list of recipes based on the 
                            number of comments on it. Clicking on the recipe will open a page that displays that recipe.
                             This is acieved in the same way using query parameters as discussed above.
                        </li>
                        <li>
                            <i>Recent Orders</i> - This list displays all the order activity that is going on by the most recent order
                            being the first. It displays the recipe name that was ordered and the user who ordered it. Clicking on
                            the recipe name will open its page, while clicking on the user name will open all the recipes contributed 
                            by the user. This is acieved in the same way using query parameters as discussed above.
                        </li>
                    </ul>
                </li>
            </ol>
        </p>
        <h4>Screen shots</h4>
        <img src="../images/homepage.jpg" title="Homepage" alt="Homepage Screenshot" class="image"/>
        <h4>Key Functionalities</h4>
        <ul>
            <li>Ability to see most contributing users.</li>
            <li>Ability to see most requested recipes.</li>
            <li>Ability to see recipe images present in the system.</li>
            <li>Ability to see most commented recipes.</li>
            <li>Ability to see orders log.</li>
            <li>View respective recipes, and users on display.</li>
        </ul>

        <h4>Future Scope:</h4>
        <p>Instead of a slideshow, a grid view of all the recipes is the thing I am going to try next. Changing the grid at a time
            seems to be very cool feature where multiple images are getting refreshed at certain intervals. Another feature of "like"
            as in Facebook is another feature I will work on. Ability of logged in user to comment on the recipe directly from the 
            homepage is also a neat trick to be included.
        </p>

        <%--<h4>References</h4>
            <ul>
                <li><a href="http://css-tricks.com/snippets/jquery/simple-auto-playing-slideshow/" target="_blank">CSS tricks - Slideshow</a>  </li>
            </ul>--%>
    </div>
    </form>
</body>
</html>
