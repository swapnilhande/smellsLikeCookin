<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>My Recipes</title>
    <link rel="stylesheet" href="../css/documentation.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-div">
            <h1 class="center-align">My Recipes</h1>
            <hr />
            <br />
            <h4>File Name:</h4>
            <p>MyRecipes.aspx</p>

            <h4>Purpose:</h4>
            <p>
                This page of <b><i>Smells Like Cookin'</i></b> is similar to browse recipes page in terms of functionality, but the only 
                difference is that only the logged in users recipes and hashtags are displayed.
           The page is basically divided into two sections.
            <ol>
                <li><b>Hash Tags:</b>
                    <p>
                        Instead of loading all the hash tags that are present in the system, I have only displayed the hashtags that
                        are in the recipes of the current logged in user. This makes it more convenient for the user to filter out
                        the resulting recipes as only his hash tags are displayed.
                    </p>
                    <p>
                        This page does not accept query parameters as some of the functionality in this page is dedicated for the 
                        logged in user.
                    </p>
                </li>
                <li>
                    <b>Recipes: </b>
                    <p>
                        This section loads with all the recipes that the current logged in user has contributed. On clicking a hash tag, the 
                        recipes are displayed that belong to that hash tag and that belong to the current logged in user. The recipe names are an 
                    un-ordered list that is a collapsible. Clicking on the name will expand the recipe and display certain stats such as
                    owner user, comments on the recipe and a button to view the recipe in its page. Additionally a delete button is present
                        to enable the users to delete the recipe directly from this page.

                    </p>
                    <p>
                        Clicking on the View Recipe button calls ViewRecipe.aspx with recipe id as the query parameter.
                    </p>
                </li>
            </ol>
            </p>
            <p>If any image of the recipe is not present in the database, a default image is displayed which says "No Image Uploaded"</p>
            <h4>Screen shots</h4>
            <p>Delete and View recipe button</p>
            <img src="../images/myrecipe.jpg" title="Homepage" alt="Homepage Screenshot" class="image" />
            
            
            <h4>Key Functionalities</h4>
            <ul>
                <li>Ability to see all hashtags used by the logged in user.</li>
                <li>Ability to filter recipes by selecting hashtags.</li>
                <li>Ability to delete the recipe directly from this page.</li>
                <li>Ability to see recipe details such as owner user, number of comments, posted date etc.</li>
                <li>Ability to view the recipe in its page.</li>
            </ul>

            <h4>Future Scope:</h4>
            <p>
                Can add edit recipe button as well to edit the recipe directly.
            </p>

            <h4>References</h4>
            <ul>
                <li><a href="../../../experiments/asp.net/exp12Hash.aspx" target="_blank">Experiment 12 - Hashes</a>  </li>
                <li><a href="http://api.jquery.com/slideDown" target="_blank">jQuery Slide Down</a>  </li>
            </ul>
        </div>
    </form>
</body>
</html>
