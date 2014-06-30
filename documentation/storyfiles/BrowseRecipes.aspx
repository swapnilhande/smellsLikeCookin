<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Browse Recipes</title>
    <link rel="stylesheet" href="../css/documentation.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-div">
            <h1 class="center-align">Browse Recipes</h1>
            <hr />
            <br />
            <h4>File Name:</h4>
            <p>BrowseRecipes.aspx</p>

            <h4>Purpose:</h4>
            <p>
                This page of <b><i>Smells Like Cookin'</i></b> is where you can see all the recipes that are contributed by members.
           The page is basically divided into two sections.
            <ol>
                <li><b>Hash Tags:</b>
                    <p>
                        This is on of the features in my project that I am really proud of. Hash tags are small descriptors
                    of the recipe. When adding a recipe, user is presented with all the hash tags wherein, he can select those 
                    hash tags that describe or relate to the recipe. This helps searching the recipe conveniently. Users can select
                    the hash tags to show only those recipes that contain the selected hash tag. Every click on the hash tag causes the
                    recipes to change accordingly. This is achieved through itemcommand event of a repeater, which is used to dynamically
                    populate the hash tags from database. On every click the hash tag which is a link button the hash tag id is passed
                    as a CommandArgument and the sql statement to retrieve the recipes is changed accordingly.
                    </p>
                    <p>
                        This page also serves query parameters, so when a username is present in the query parameter only those
                    hash tags are loaded which belong to the queried user.
                    </p>
                </li>
                <li>
                    <b>Recipes: </b>
                    <p>
                        This section loads with all the recipes that are present in the system as by default all the hash tags are
                    unselected. On clicking a hash tag, the recipes are displayed that belong to that hash tag. The recipe names are an 
                    un-ordered list that is a collapsible. Clicking on the name will expand the recipe and display certain stats such as
                    owner user, comments on the recipe and a button to view the recipe in its page. 

                    </p>
                    <p>
                        Clicking on the View Recipe button calls ViewRecipe.aspx with recipe id as the query parameter. Clicking on the 
                    user opens the BrowseRecipe.aspx with the username as the query parameter.
                    </p>
                </li>
            </ol>
            </p>
            <h4>Screen shots</h4>
            <p>Default all hash tags unselected:</p>
            <img src="../images/browserecipe_2.jpg" title="Browse Recipe" alt="Browse Recipe" class="image" />
            
            <p>Selecting a hashtag filters the results, clicking the recipe name opens the recipe details:</p>
            <img src="../images/browserecipe_2.jpg" title="Browse Recipe" alt="Browse Recipe" class="image" />
            
            <h4>Key Functionalities</h4>
            <ul>
                <li>Ability to see all hashtags in the system.</li>
                <li>Ability to filter recipes by selecting hashtags.</li>
                <li>Ability to reuse the page by providing username as the query parameter to display that users recipe.</li>
                <li>Ability to see recipe details such as owner user, number of comments, posted date etc.</li>
                <li>Ability to view the recipe in its page.</li>
            </ul>

            <h4>Future Scope:</h4>
            <p>
                Currently all the hash tags filtering of recipes is done using OR boolean operator, so the recipes are returned that
                contained at least one of the selected hash tags. In future I am thinking of putting an AND | OR switch that the user can
                select to be able to set the filtering criteria. Also, ability to add more hash tags by some admin role.
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
